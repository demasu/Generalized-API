/*jshint esversion:6*/
var apiData;
var fetchingData = 1;

var valueListContainerHTML = `
                                <div class="col-12" id="value-list-container">
                                    <label for="func-value">What value do you want to use?</label>
                                    <input id="func-value" type="text" name="func-value" placeholder="Value">
                                </div>
`;
var functionListContainerHTML = `
                                <div class="col-12" id="func-list-container">
                                    <label for="function">What method do you want to test?</label>
                                    <select name="function" id="func-list">
                                        <option value="">- Select Function -</option>
                                    </select>
                                </div>
`;

// For inserting:
//var submitButton = $('#submit-button');
//submitButton[0].insertAdjacentHTML( 'beforebegin', valueListContainerHTML );

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

$(document).ready(function() {
    $.ajax({
        beforeSend: function(){fetchingData = 1;},
        url: 'https://astudyinfutility.com/fancy/api/list',
        dataType: 'json',
    })
    .done(function(data) {
        apiList = data;
        data.forEach(function(item) {
            addOption(item);
        });
        fetchingData = 0;
    })
    .fail(function(jqxhr, textstatus, errorthrown) {
        console.log("Failure happened");
        console.log("Error is");
        console.log(textstatus);
        fetchingData = 0;
        return "Failure";
    });

    $('#submit-button').prop('disabled', true);

    $('#api-list').change(function() {
        console.log('Dropdown was changed');
        updateForm( $('#api-list') );
    });
});

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

function updateForm (element) {
    console.log('Fetching data is:');
    console.log(fetchingData);
    if ( fetchingData ) {
        return false;
    }
    if ( checkSelection(element) ) {
        // Do something good
        var apiOptionRegex   = /api/i;
        var funcOptionRegex  = /function/i;
        var valueOptionRegex = /func-value/i;
        var elementName      = element[0].name.toString();

        if ( elementName.match(apiOptionRegex) ) {
            updateFunctionList();
        }
        else if ( elementName.match(funcOptionRegex) ) {
            updateValueList();
        }
        else if ( elementName.match(valueOptionRegex) ) {
            console.log('Can we get here?');
            enableSubmitButton();
        }
    }
    else {
        // Do something bad
        return false;
    }
}

function checkSelection (element) {
    if ( element.val() == '' ) {
        return false;
    }
    else {
        return true;
    }
}
