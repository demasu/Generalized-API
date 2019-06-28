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

var typingTimer;                // Timer identifier
var doneTypingInterval = 100;   // Time in milliseconds

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
    $('#form-row-container').on('change', '#func-list-container', function() {
        console.log('Function dropdown was changed');
        updateForm( $('#func-list') );
    });
    $('#form-row-container').on('keyup', '#value-list-container', function() {
        clearTimeout(typingTimer);
        typingTimer = setTimeout(doneTyping, doneTypingInterval);
    });
    $('#form-row-container').on('keydown', '#value-list-container', function() {
        clearTimeout(typingTimer);
    });

    $('#submit-button').click(function() {
        //return false;
        // TODO: Add functionality
        // Probably AJAX call to run the thing
        // Load a spinner
        // Maybe redirect to a results page?
        // Maybe have a modal to show the results?
        $.ajax({
            url: 'https://astudyinfutility.com/fancy/test',
            type: 'POST',
            data: $('#api-selector').serialize(),
            success: function(msg) {
                console.log('Message is:');
                console.log(msg);
            }
        });
        return false;
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
    console.log('Element is:');
    console.log(element);
    console.log('Checking the selection');
    if ( checkSelection(element) ) {
        console.log('checkSelection returned true');
        // Do something good
        var apiOptionRegex   = /api/i;
        var funcOptionRegex  = /function/i;
        var valueOptionRegex = /func-value/i;
        var elementName      = element[0].name.toString();

        if ( elementName.match(apiOptionRegex) ) {
            console.log('element name matched the api option regex');
            updateFunctionList();
        }
        else if ( elementName.match(funcOptionRegex) ) {
            console.log('element name matched the function option regex');
            updateValueList();
        }
        else if ( elementName.match(valueOptionRegex) ) {
            console.log('Can we get here?');
            enableSubmitButton();
        }
    }
    else {
        console.log('checkSelection returned false');
        // Do something bad
        return false;
    }
}

function updateFunctionList () {
    var functions = getFunctionData();
    addFunctionsToDropdown(functions);
}

function getFunctionData () {
    console.log('In getFunctionData');

    var options;
    $.ajax({
        beforeSend: function(){fetchingData = 1;},
        url: 'https://astudyinfutility.com/fancy/test/functions',
        dataType: 'json',
        async: false,
        method: 'POST',
        data: $('#api-list').serialize(),
        success: function(msg) {
            console.log('Returned data is:');
            console.log(msg);
            options = msg;
            fetchingData = 0;
        },
    })
    .fail(function(jqxhr, textstatus, errorthrown) {
        console.log("Failure happened");
        console.log("Error is");
        console.log(textstatus);
        fetchingData = 0;
        return "Failure";
    });

    console.log('Out of the ajax call');
    console.log('options is:');
    console.log(options);
    console.log('End of getFunctionData');

    return options;
}

function addFunctionsToDropdown (functions) {
    console.log('In addFunctionsToDropdown');
    console.log('Functions are:');
    console.log(functions);
    var submitButton = $('#submit-button');
    submitButton[0].insertAdjacentHTML( 'beforebegin', functionListContainerHTML );

    var funcListOption = $('#func-list');
    functions.forEach(function(name) {
        var optionHTML = `<option value="${name}">${name}</option>`;
        funcListOption[0].insertAdjacentHTML( 'beforeend', optionHTML );
    });
    console.log('Done with addFunctionsToDropdown');
}

function updateValueList () {
    var submitButton = $('#submit-button');
    submitButton[0].insertAdjacentHTML( 'beforebegin', valueListContainerHTML );
}

function checkSelection (element) {
    console.log('In checkSelection');
    console.log('Element is:');
    console.log(element);
    if ( element.val() == '' ) {
        console.log('Value equaled \'\'');
        $('#submit-button').prop('disabled', true);
        return false;
    }
    else {
        console.log('Value did not equal \'\'');
        return true;
    }
}

function enableSubmitButton () {
    console.log('Enabling the submit button');
    $('#submit-button').prop('disabled', false);
}

function doneTyping () {
    console.log('User stopped typing');

    console.log('Calling updateForm');
    updateForm( $('#func-value') );
}
