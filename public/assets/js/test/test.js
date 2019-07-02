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
        fetchingData = 0;
        return "Failure";
    });

    disableSubmitButton();

    $('#api-list').change(function() {
        updateForm( $('#api-list') );
    });
    $('#form-row-container').on('change', '#func-list-container', function() {
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

    $('#results-modal').dialog({
        autoOpen: false,
        resizable: true,
        modal: true,
        buttons: {
            Ok: function() {
                $( this ).dialog( "close" );
            }
        },
        maxHeight: 1200,
        maxWidth: 1500,
        minHeight: 200,
        minWidth: 200,
        height: 800,
        width: 1000,
    });

    $('#submit-button').click(function() {
        $.ajax({
            beforeSend: validateForms(),
            url: 'https://astudyinfutility.com/fancy/test',
            type: 'POST',
            data: $('#api-selector').serialize(),
            success: function(msg) {
                displayResult(msg);
            }
        });
        return false;
    });

    $('#reset-button').click(function() {
        clearForm(true);
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
    if ( fetchingData ) {
        return false;
    }
    if ( checkSelection(element) ) {
        var apiOptionRegex   = /api/i;
        var funcOptionRegex  = /function/i;
        var valueOptionRegex = /value-for/i;
        var elementName      = element[0].name.toString();

        if ( elementName.match(apiOptionRegex) ) {
            clearForm(false);
            updateFunctionList();
        }
        else if ( elementName.match(funcOptionRegex) ) {
            updateValueList();
        }
        else if ( elementName.match(valueOptionRegex) ) {
            if ( validateAllParams() ) {
                enableSubmitButton();
            }
            else {
                disableSubmitButton();
            }
        }
    }
    else {
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

    var options;
    $.ajax({
        beforeSend: function(){fetchingData = 1;},
        url: 'https://astudyinfutility.com/fancy/test/functions',
        dataType: 'json',
        async: false,
        method: 'POST',
        data: $('#api-list').serialize(),
        success: function(msg) {
            options = msg;
            fetchingData = 0;
            validAPI = true;
        },
    })
    .fail(function(jqxhr, textstatus, errorthrown) {
        fetchingData = 0;
        return "Failure";
    });

    return options;
}

function addFunctionsToDropdown (functions) {
    var submitButton = $('#button-container');
    submitButton[0].insertAdjacentHTML( 'beforebegin', functionListContainerHTML );

    var funcListOption = $('#func-list');
    functions.forEach(function(name) {
        var optionHTML = `<option value="${name}">${name}</option>`;
        funcListOption[0].insertAdjacentHTML( 'beforeend', optionHTML );
    });
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

    var options;
    var postData = $('#api-list').serialize() + '&' + $('#func-list').serialize();

    $.ajax({
        beforeSend: function(){fetchingData = 1;},
        url: 'https://astudyinfutility.com/fancy/test/parameters',
        dataType: 'json',
        async: false,
        method: 'POST',
        data: postData,
        success: function(msg) {
            options = msg;
            fetchingData = 0;
            validFunction = true;
        },
    })
    .fail(function(jqxhr, textstatus, errorthrown) {
        fetchingData = 0;
        return "Failure";
    });

    return options;
}

function addParametersToPage (parameters) {
    var submitButton = $('#button-container');

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
}

function checkSelection (element) {
    var paramRegex = /value-for/;

    if ( element.attr('id').match(paramRegex) ) {
        return true;
    }

    if ( element.val() == '' ) {
        disableSubmitButton();
        return false;
    }
    else {
        return true;
    }
}

function enableSubmitButton () {
    $('#submit-button').prop('disabled', false);
}

function disableSubmitButton () {
    $('#submit-button').prop('disabled', true);
}

function doneTyping (element) {
    updateForm( $(`#${element.id}`) );
}

function validateAllParams () {
    var params = $('[id*="-param-"]');

    var length = params.length;

    var valid = false;
    $.each(params, function(key) {
        var id = params[key].id;
        var children = $(`#${id}`).children('input');
        $.each(children, function(key) {
            var elem = $(`#${children[key].id}`);
            var requiredRegex = /required-value/;
            var id = elem.attr('id');
            if ( elem.attr('id').match(requiredRegex) ) {
                if ( elem.val() == '' ) {
                    valid = false;
                }
                else {
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

function displayResult (data) {
    try {
        var json = JSON.parse(data);
        var jsonString = JSON.stringify(json, undefined, 4);
        var formattedHTML = syntaxHighlight(jsonString);
        $('#results-modal > pre').html(formattedHTML);
        $('#results-modal').dialog('open');
    }
    catch (e) {
        var error = 'There was an error formatting the result:\n';
        error    += e;
        $('#results-modal > pre').insertAdjacentHTML('beforeend', error);
    }

    return false;
}

function syntaxHighlight (json) {
    json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
        var cls = 'number';
        if (/^"/.test(match)) {
            if (/:$/.test(match)) {
                cls = 'key';
            } else {
                cls = 'string';
            }
        } else if (/true|false/.test(match)) {
            cls = 'boolean';
        } else if (/null/.test(match)) {
            cls = 'null';
        }
        return '<span class="' + cls + '">' + match + '</span>';
    });
}

function clearForm (fullReset) {
    if ( fullReset ) {
        $('#api-list').val('');
    }
    var functionDropdown = $('#func-list-container');
    var paramContainers  = $('[id*="-param-container"]');

    functionDropdown.remove();
    paramContainers.remove();

    $('#submit-button').prop('disabled', true);
}
