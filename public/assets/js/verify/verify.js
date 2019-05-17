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
    if ( $('#api-info-table').length != 0 ) {
        $('#api-info-table').remove();
    }

    var jsonObj  = JSON.parse(data);
    var newDiv   = document.createElement('div');
    var newTable = document.createElement('table');
    var innards  = '';

    // Set attributes
    newDiv.setAttribute( 'id', 'api-info-table' );
    newTable.setAttribute( 'id', 'api-data' );
    newTable.setAttribute( 'class', 'alt' );

    var groupReturn = generateColGroups();
    innards += groupReturn;

    var headReturn = generateTableHeader();
    innards += headReturn;

    var standardsReturn = generateStandardParts(jsonObj);
    jsonObj  = standardsReturn[0];
    innards += standardsReturn[1];

    innards += generateFunctionHeader();

    var funcBody        = document.createElement('tbody');
    funcBody.innerHTML += generateFunctionBodyHeader();

    console.log('Iterating over keys...');
    $.each(jsonObj, function(key) {
        console.log('In the loop');
        var params = jsonObj[key].params;
        console.log('Params are:');
        console.log(params);
        var call   = jsonObj[key].call;
        console.log('Call is:');
        console.log(call);
        var completed = 0;
        console.log('Iterating over the parameters');
        $.each(params, function(key) {
            console.log('In the loop...');
            console.log('Creating a row');
            var row = document.createElement('tr');
            console.log('Calling generateParamRow for ' + key);
            var cols = generateParamRow(params[key], completed);
            if ( completed == 0 ) {
                console.log('Completed is 0');
                console.log('Calling generateFunctionCallHeader');
                row.innerHTML += generateFunctionCallHeader(params, call);
                row.innerHTML += cols[0];
                row.innerHTML += cols[1];
            }
            else if ( completed % 2 == 0 ) {
                console.log('Completed is even');
                row.innerHTML += cols[0];
                row.innerHTML += cols[1];
            }
            else {
                console.log('Completed is not even or zero');
                row.innerHTML += cols[0];
                row.innerHTML += cols[1];
            }
            console.log('Adding the row to the funcBody');
            funcBody.innerHTML += row.outerHTML;
            completed++;
        });
    });

    console.log('Adding the funcbody to the innards');
    innards += funcBody.outerHTML;

    console.log('Adding the innards to the table');
    newTable.innerHTML += innards;
    console.log('Adding the table to the div');
    newDiv.innerHTML += newTable.outerHTML;

    $('#form')[0].insertAdjacentHTML( 'afterend', newDiv.outerHTML );
}

function generateStandardParts (jsonObj) {
    var baseGroup = document.createElement('tbody');

    baseGroup.innerHTML += generateRequiredHeader();

    var baseReturn = generateBaseURLRow(jsonObj);
    jsonObj = baseReturn[0];
    baseGroup.innerHTML += baseReturn[1];

    var userReturn = generateUsernameRow(jsonObj);
    jsonObj = userReturn[0];
    baseGroup.innerHTML += userReturn[1];

    var passReturn = generatePasswordRow(jsonObj);
    jsonObj = passReturn[0];
    baseGroup.innerHTML += passReturn[1];

    var queryReturn = generateQueryRow(jsonObj);
    jsonObj = queryReturn[0];
    baseGroup.innerHTML += queryReturn[1];

    var rows = baseGroup.outerHTML;

    return [jsonObj, rows];
}

function generateRequiredHeader () {
    var headerRow = document.createElement('tr');
    var header1   = document.createElement('th');
    var header2   = document.createElement('th');
    var header3   = document.createElement('th');

    header1.setAttribute( 'class', 'small-header left alt' );
    header2.setAttribute( 'class', 'small-header alt' );
    header3.setAttribute( 'class', 'small-header alt' );

    header2.textContent  = "Parameter";
    header3.textContent  = "Value";
    headerRow.innerHTML += header1.outerHTML + header2.outerHTML + header3.outerHTML;

    return headerRow.outerHTML;
}

function generateBaseURLRow (jsonObj) {
    var baseRow = document.createElement('tr');
    var baseFunc  = document.createElement('td');
    var baseParam = document.createElement('td');
    var baseValue = document.createElement('td');
    baseParam.textContent = 'base_url';
    baseValue.textContent = jsonObj.base_url;
    delete jsonObj.base_url;
    baseRow.innerHTML += baseFunc.outerHTML + baseParam.outerHTML + baseValue.outerHTML;

    return [jsonObj, baseRow.outerHTML];
}

function generateUsernameRow (jsonObj) {
    var usernameRow = document.createElement('tr');
    var userFunc    = document.createElement('td');
    var userParam   = document.createElement('td');
    var userValue   = document.createElement('td');
    userParam.textContent = 'username';
    userValue.textContent = jsonObj.username;
    delete jsonObj.username;
    usernameRow.innerHTML += userFunc.outerHTML + userParam.outerHTML + userValue.outerHTML;

    return [jsonObj, usernameRow.outerHTML];
}

function generatePasswordRow (jsonObj) {
    var passRow = document.createElement('tr');
    var passFunc  = document.createElement('td');
    var passParam = document.createElement('td');
    var passValue = document.createElement('td');
    passParam.textContent = 'password';
    passValue.textContent = jsonObj.password.replace(/./g, '*');
    delete jsonObj.password;
    passRow.innerHTML += passFunc.outerHTML + passParam.outerHTML + passValue.outerHTML;

    return [jsonObj, passRow.outerHTML];
}

function generateQueryRow (jsonObj) {
    var queryRow = document.createElement('tr');
    var queryFunc  = document.createElement('td');
    var queryParam = document.createElement('td');
    var queryValue = document.createElement('td');
    queryParam.textContent = 'query_method';
    queryValue.textContent = jsonObj.query_method;
    delete jsonObj.query_method;
    queryRow.innerHTML += queryFunc.outerHTML + queryParam.outerHTML + queryValue.outerHTML;

    return [jsonObj, queryRow.outerHTML];
}

function generateParamRow (param, num) {
    var paramCol = document.createElement('td');
    var valCol   = document.createElement('td');

    if ( num % 2 != 0 ) {
        paramCol.setAttribute( 'class', 'cell-no-left' );
    }

    paramCol.textContent = param.name;
    if ( param.required == 'on' ) {
        valCol.textContent = '(required)';
    }
    else {
        valCol.textContent = '(optional)';
    }

    return [paramCol.outerHTML, valCol.outerHTML];
}

function generateColGroups () {
    var group = document.createElement('colgroup');
    var col   = document.createElement('col');
    group.innerHTML += col.outerHTML + col.outerHTML + col.outerHTML;

    return group.outerHTML;
}

function generateTableHeader () {
    var header     = document.createElement('thead');
    var theadRow   = document.createElement('tr');

    theadRow.setAttribute( 'class', 'header-row' );

    var theadCol   = document.createElement('th');
    var theadColh4 = document.createElement('h4');

    theadCol.setAttribute( 'colspan', '3' );
    theadCol.setAttribute( 'scope', 'colgroup' );
    theadCol.setAttribute( 'class', 'big-header' );
    theadColh4.textContent = 'RequiredParameters';
    theadCol.innerHTML    += theadColh4.outerHTML;

    theadRow.innerHTML  += theadCol.outerHTML;
    header.innerHTML    += theadRow.outerHTML;

    return header.outerHTML;
}

function generateFunctionHeader () {
    var functionHeader = document.createElement('tbody');
    var funcHeadRow    = document.createElement('tr');
    var funcHeadCol    = document.createElement('th');
    var funcHeadColh4  = document.createElement('h4');

    funcHeadCol.setAttribute( 'colspan', '3' );
    funcHeadCol.setAttribute( 'scope', 'colgroup' );
    funcHeadCol.setAttribute( 'class', 'big-header alt' );
    funcHeadRow.setAttribute( 'class', 'header-row' );
    funcHeadColh4.textContent = 'Functions';

    funcHeadCol.innerHTML    += funcHeadColh4.outerHTML;
    funcHeadRow.innerHTML    += funcHeadCol.outerHTML;
    functionHeader.innerHTML += funcHeadRow.outerHTML;

    return functionHeader.outerHTML;
}

function generateFunctionBodyHeader () {
    var funcBodyHeadRow   = document.createElement('tr');
    var funcBodyHeadLeft  = document.createElement('th');
    var funcBodyHeadMid   = document.createElement('th');
    var funcBodyHeadRight = document.createElement('th');

    funcBodyHeadLeft.setAttribute( 'class', 'small-header left' );
    funcBodyHeadMid.setAttribute( 'class', 'small-header' );
    funcBodyHeadRight.setAttribute( 'class', 'small-header' );

    funcBodyHeadMid.textContent   = 'Parameter';
    funcBodyHeadRight.textContent = 'Value';

    funcBodyHeadRow.innerHTML += funcBodyHeadLeft.outerHTML + funcBodyHeadMid.outerHTML + funcBodyHeadRight.outerHTML;

    return funcBodyHeadRow.outerHTML;
}

function generateFunctionCallHeader (params, call) {
    var funcCol = document.createElement('th');
    var numRows = Object.keys(params).length;
    funcCol.setAttribute( 'rowspan', numRows );
    funcCol.setAttribute( 'scope', 'rowgroup' );
    funcCol.setAttribute( 'class', 'func-header' );

    funcCol.textContent = call;

    return funcCol.outerHTML;
}