/*
    Massively by HTML5 UP
    html5up.net | @ajlkn
    Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
*/

var paramCounts = {
    'order': 2,
    'cancel': 2
};

var addOrderParamButton  = $('#add-order-param');
var addCancelParamButton = $('#add-cancel-param');
var orderParamContainer  = $('#order-param-container');
var cancelParamContainer = $('#cancel-param-container');

function addRow( type ) {
    if ( !(type in paramCounts) ) {
        paramCounts[type] = 0;
    }
    paramCounts[type]++;

    var button    = $(`#add-${type}-param`);
    var container = button.parent("div")[0];

    var textDiv = addTextDiv(type);
    var boxDiv  = addCheckboxDiv(type);

    var textHTML = textDiv.outerHTML;
    var boxHTML  = boxDiv.outerHTML;

    container.insertAdjacentHTML( 'beforebegin', textHTML );
    container.insertAdjacentHTML( 'beforebegin', boxHTML );

    var id = boxDiv.firstChild.getAttribute("id");
    id = '#' + id;
    button[0].setAttribute("href", `#${id}`);
    
    return false;
}

function addTextDiv ( type ) {
    var formattedType = type.charAt(0).toUpperCase() + type.slice(1);

    // Create elements
    var newOuterDiv = document.createElement('div');
    var newInput    = document.createElement('input');
    var newLabel    = document.createElement('label');

    // Add classes and IDs
    newOuterDiv.setAttribute( "class", "col-6" );
    
    newInput.setAttribute( "type", "text" );
    newInput.setAttribute( "name", `${formattedType} Param ${paramCounts[type]}` );
    newInput.setAttribute( "id", `${type}-param-${paramCounts[type]}`);

    newLabel.setAttribute( "for", newInput.getAttribute( "id" ) );
    newLabel.textContent = `Parameter ${numberToWords.toWords(paramCounts[type])}`;

    newOuterDiv.innerHTML += newInput.outerHTML + newLabel.outerHTML;

    return newOuterDiv;
}

function addCheckboxDiv ( type ) {
    var formattedType = type.charAt(0).toUpperCase() + type.slice(1);

    // Create elements
    var outerDiv = document.createElement('div');
    var checkbox = document.createElement('input');
    var label    = document.createElement('label');

    // Add classes and IDs
    outerDiv.setAttribute( "class", "col-6" );

    checkbox.setAttribute( "type", "checkbox" );
    checkbox.setAttribute( "name", `${formattedType} Param ${paramCounts[type]}` );
    checkbox.setAttribute( "id", `${type}-param-${paramCounts[type]}` );

    label.setAttribute( "for", checkbox.getAttribute("id") );
    label.textContent = "Required";

    outerDiv.innerHTML += checkbox.outerHTML + label.outerHTML;

    return outerDiv;
}

function addOrderField () {
    addRow('order');
}

function addCancelField () {
    addRow('cancel');
}
