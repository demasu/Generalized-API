var apiData;

function getAPIData (api) {
    $.ajax({
        url: `/api/${api}/data`,
    })
    .done(function(data) {
        apiData = data;
    })
    .fail(function() {
        return "Failure";
    });
}

var apiList;

$(document).ready(function() {
    $.ajax({
        url: `/api/list`,
        dataType: 'json',
    })
    .done(function(data) {
        apiList = data;
        data.forEach(function(item) {
            addOption(item);
        });
    })
    .fail(function() {
        console.log("Failure happened");
        return "Failure";
    });

    $('#submit-button').prop('disabled', true);

    // Bind to events
    $('#submit-button').click(function(e) {
        $.ajax({
            url: '/verify',
            type: 'POST',
            data: $('#api-selector').serialize(),
            success: function(msg) {
                generateTableContents(msg);
            }
        });
        //e.preventDefault();
        return false;
    });

    $('#api-list').change(function(element) {
        checkSelection(element);
    });
});

function checkSelection (element) {
    var value = element.target.value;
    if ( value == "" ) {
        $('#submit-button').prop('disabled', true);
        return false;
    }
    else {
        $('#submit-button').prop('disabled', false);
        return true;
    }
}

function addOption (item) {
    var select = $('#api-list');

    var newOption = document.createElement('option');
    newOption.setAttribute( "value", item );

    var name = item;
    name = name.replace('.json', '');
    name = name.replace(/_/g, ' ');
    newOption.textContent = name;

    select[0].insertAdjacentHTML( 'beforeend', newOption.outerHTML );
}

function generateTableContents (data) {
    console.log("In generateTableContents");

    var jsonObj   = JSON.parse(data);
    var newDiv    = document.createElement('div');
    var newTable  = document.createElement('table');
    var newRow    = document.createElement('tr');
    var newHeader = document.createElement('th');
    var newColumn = document.createElement('td');

    // Set attributes
    newDiv.setAttribute( 'id', 'api-info-table' );
    newTable.setAttribute( 'id', 'api-data' );

    /*************************************************************
    * Note to self: Replace every reuse of 'newRow', 'newHeader' *
    * and 'newColumn' with their own document.createElement      *
    **************************************************************/
    var headerRow = newRow;
    var header1 = newHeader;
    var header2 = newHeader;
    var header3 = newHeader;
    header1.textContent = "Function"
    header2.textContent = "Parameter";
    header3.textContent = "Value";
    headerRow.innerHTML += header1.outerHTML + header2.outerHTML + header3.outerHTML;

    var baseRow = newRow;
    console.log("Base row is:");
    console.log(baseRow.outerHTML);
    var baseFunc  = newColumn;
    var baseParam = newColumn;
    var baseValue = newColumn;
    baseParam.textContent = 'base_url';
    baseValue.textContent = jsonObj.base_url;
    delete jsonObj.base_url;
    console.log("Base func column is:");
    console.log(baseFunc.outerHTML);
    console.log("Base param column is:");
    console.log(baseParam.outerHTML);
    console.log("Base value column is:");
    console.log(baseValue.outerHTML);
    baseRow.innerHTML += baseFunc.outerHTML + baseParam.outerHTML + baseValue.outerHTML;
    console.log("Base row is:");
    console.log(baseRow.outerHTML);

    var usernameRow = newRow;
    var userFunc    = newColumn;
    var userParam   = newColumn;
    var userValue   = newColumn;
    userParam.textContent = 'username';
    userValue.textContent = jsonObj.username;
    delete jsonObj.username;
    usernameRow.innerHTML += userFunc.outerHTML + userParam.outerHTML + userValue.outerHTML;

    var passRow = newRow;
    var passFunc  = newColumn;
    var passParam = newColumn;
    var passValue = newColumn;
    passParam.textContent = 'password';
    passValue.textContent = jsonObj.password.replace(/./g, '*');
    delete jsonObj.password;
    passRow.innerHTML += passFunc.outerHTML + passParam.outerHTML + passValue.outerHTML;

    var queryRow = newRow;
    var queryFunc  = newColumn;
    var queryParam = newColumn;
    var queryValue = newColumn;
    queryParam.textContent = 'query_method';
    queryValue.textContent = jsonObj.query_method;
    delete jsonObj.query_method;
    queryRow.innerHTML += queryFunc.outerHTML + queryParam.outerHTML + queryValue.outerHTML;

    newTable.innerHTML += headerRow.outerHTML  + baseRow.outerHTML
                       + usernameRow.outerHTML + passRow.outerHTML
                       + queryRow.outerHTML;

    $.each(jsonObj, function(key, value) {
        //console.log("Key:", key);
        //console.log("Value:", value);
        var currentRow = newRow;
        var funcCol = newColumn;
        funcCol.textContent = jsonObj[key].call;
        currentRow.innerHTML += funcCol.outerHTML;
        newTable.innerHTML += currentRow.outerHTML;


        var params = jsonObj[key].params;
        $.each(params, function(key, value) {
            var paramRow = newRow;
            var funcCol  = newColumn;
            var paramCol = newColumn;
            var valCol   = newColumn;

            paramCol.textContent = params.name;
            if ( params.required == 'on' ) {
                valCol.textContent = '(required)';
            }
            else {
                valCol.textContent = '(optional)';
            }
            paramRow.innerHTML += funcCol.outerHTML + paramCol.outerHTML + valCol.outerHTML;
            newTable.innerHTML += paramRow.outerHTML;
        });
    });

    console.log(newTable);
    newDiv.innerHTML += newTable.outerHTML;

    $('#form')[0].insertAdjacentHTML( 'afterend', newDiv.outerHTML );
}