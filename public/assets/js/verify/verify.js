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
        console.log(data);
        apiList = data;
        console.log(typeof(data));
        data.forEach(function(item) {
            addOption(item);
        });
    })
    .fail(function() {
        console.log("Failure happened");
        return "Failure";
    });

    // Bind to events
    $('#submit-button').submit(function(e) {
        console.log("Button clicked");
        e.preventDefault();
        return false;
    });
});

function addOption (item) {
    console.log("addOption called");
    var select = $('#api-list');

    var newOption = document.createElement('option');
    newOption.setAttribute( "value", item );

    var name = item;
    name = name.replace('.json', '');
    name = name.replace(/_/g, ' ');
    newOption.textContent = name;
    console.log("New option is:", )

    select[0].insertAdjacentHTML( 'beforeend', newOption.outerHTML );
}