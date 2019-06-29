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

var typingTimer;                // Timer identifier
var doneTypingInterval = 100;   // Time in milliseconds
var validFunction = false;
var validAPI      = false;

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

    disableSubmitButton();

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

    $('#form-row-container').on('keyup', '[id*="value-for"]', function() {
        clearTimeout(typingTimer);
        var element = this;
        typingTimer = setTimeout(function() {doneTyping(element);}, doneTypingInterval);
    });
    $('#form-row-container').on('keydown', '[id*="value-for"]', function() {
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
            beforeSend: validateForms(),
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
        var valueOptionRegex = /value-for/i;
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
            console.log('Matched the value option regex');
            if ( validateAllParams() ) {
                console.log('validateAllParams returned true');
                enableSubmitButton();
            }
            else {
                disableSubmitButton();
            }
        }
        else {
            console.log('Did not match anything');
        }
    }
    else {
        console.log('checkSelection returned false');
        // Do something bad
        return false;
    }
}

function updateFunctionList () {
    if ( $('#api-list').val() == '' ) {
        validAPI = false;
        return false;
    }
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
            validAPI = true;
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
    var submitButton = $('#button-container');
    submitButton[0].insertAdjacentHTML( 'beforebegin', functionListContainerHTML );

    var funcListOption = $('#func-list');
    functions.forEach(function(name) {
        var optionHTML = `<option value="${name}">${name}</option>`;
        funcListOption[0].insertAdjacentHTML( 'beforeend', optionHTML );
    });
    console.log('Done with addFunctionsToDropdown');
}

function updateValueList () {
    if ( $('#func-list').val() == '' ) {
        validFunction = false;
        return false;
    }
    var parameters = getParameterData();
    addParametersToPage(parameters);
}

function getParameterData () {
    console.log('In getParameterData');

    var options;
    var postData = $('#api-list').serialize() + '&' + $('#func-list').serialize();
    console.log('Post data is:');
    console.log(postData);

    $.ajax({
        beforeSend: function(){fetchingData = 1;},
        url: 'https://astudyinfutility.com/fancy/test/parameters',
        dataType: 'json',
        async: false,
        method: 'POST',
        data: postData,
        success: function(msg) {
            console.log('Returned data is:');
            console.log(msg);
            options = msg;
            fetchingData = 0;
            validFunction = true;
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
    console.log('End of getParameterData');

    return options;
}

function addParametersToPage (parameters) {
    console.log('In addParametersToPage');
    var submitButton = $('#button-container');

    console.log('Iterating over the parameters');
    parameters.forEach(function(obj) {
        var newContainerDiv = document.createElement('div');
        newContainerDiv.setAttribute( 'class', 'col-12' );
        newContainerDiv.setAttribute( 'id', `${obj.name}-param-container` );

        var required;
        if ( obj.required ) {
            required = true;
        }
        else {
            required = false;
        }

        var labelText = 'Value';
        labelText    += (required === true) ? '*' : '';
        labelText    += ' for the ';
        labelText    += obj.name;
        labelText    += ' method?';

        var newLabel  = document.createElement('label');
        newLabel.setAttribute( 'for', obj.name );
        newLabel.setAttribute( 'name', 'Parameter Name' );
        newLabel.setAttribute( 'id', `label-for-${obj.name}` );
        newLabel.textContent = labelText;

        var inputID  = (required === true) ? 'required-' : '';
        inputID     += `value-for-${obj.name}`;
        var newInput = document.createElement('input');
        newInput.setAttribute( 'name', inputID );
        newInput.setAttribute( 'type', 'text' );
        newInput.setAttribute( 'id', inputID );
        newInput.setAttribute( 'value', '' );

        newContainerDiv.innerHTML += newLabel.outerHTML;
        newContainerDiv.innerHTML += newInput.outerHTML;

        submitButton[0].insertAdjacentHTML( 'beforebegin', newContainerDiv.outerHTML );
    });
    console.log('Done iterating');
}

function checkSelection (element) {
    console.log('In checkSelection');
    console.log('Element is:');
    console.log(element);

    var paramRegex = /value-for/;

    if ( element.attr('id').match(paramRegex) ) {
        console.log('Matched the param regex');
        return true;
    }

    if ( element.val() == '' ) {
        console.log('Value equaled \'\'');
        disableSubmitButton();
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

function disableSubmitButton () {
    $('#submit-button').prop('disabled', true);
}

function doneTyping (element) {
    console.log('User stopped typing');

    console.log('Calling updateForm');
    updateForm( $(`#${element.id}`) );
}

function validateAllParams () {
    var params = $('[id*="-param-"]');
    console.log('Params is:');
    console.log(params);

    var length = params.length;
    console.log('Length is:');
    console.log(length);

    var valid = false;
    console.log('Iterating over params');
    $.each(params, function(key) {
        console.log('Key is:');
        console.log(key);
        console.log('params[key] is:');
        console.log(params[key]);
        var id = params[key].id;
        var children = $(`#${id}`).children('input');
        console.log('Iterating over children');
        $.each(children, function(key) {
            console.log('Key is:');
            console.log(key);
            var elem = $(`#${children[key].id}`);
            var requiredRegex = /required-value/;
            console.log('ID is:');
            console.log(elem.attr('id'));
            var id = elem.attr('id');
            if ( elem.attr('id').match(requiredRegex) ) {
                console.log('Matched required regex');
                if ( elem.val() == '' ) {
                    console.log('Value of element is empty');
                    valid = false;
                }
                else {
                    console.log('Value is:');
                    console.log(elem.val());
                    valid = true;
                }
            }
        });
    });


    return valid;
}

function validateForms () {
    return false;
}
