// button states, 0 = off (unselected), 1 == on (selected)
var addButtonState = 0;
var modifyButtonState = 0;
var removeButtonState = 0;
var trafficButtonState = 0;

// image setters for Add button
function setAddButtonSelected()
{
	document.images["addButton"].src= "/images/location_map_controls/add_selected_button.png";
	addButtonState = 1;
	setModifyButtonUnselected();
	setRemoveButtonUnselected();
	document.getElementById("map").className = "edit";
	//update the hidden location form
	document.getElementById("location_lat").value = "";
	document.getElementById("location_lng").value = "";
	// hide other forms
	return true;
}

function setAddButtonUnselected()
{
	document.images["addButton"].src = "/images/location_map_controls/add_unselected_button.png";
	addButtonState = 0;
	document.getElementById("map").className = "view";
	//update the hidden location form
	document.getElementById("location_lat").value = "";
	document.getElementById("location_lng").value = "";
	// hide other forms
	hideNewLocationForm();
	window.location.href='#top';
	return true;
}

// image setters for Modify button
function setModifyButtonSelected()
{
	document.images["modifyButton"].src= "/images/location_map_controls/modify_selected_button.png";
	modifyButtonState = 1;
	setAddButtonUnselected();
	setRemoveButtonUnselected();
	return true;
}

function setModifyButtonUnselected()
{
	document.images["modifyButton"].src = "/images/location_map_controls/modify_unselected_button.png";
	modifyButtonState = 0;
	return true;
}

// image setters for Remove button
function setRemoveButtonSelected()
{
	document.images["removeButton"].src= "/images/location_map_controls/remove_selected_button.png";
	removeButtonState = 1;
	setAddButtonUnselected();
	setModifyButtonUnselected();
	return true;
}

function setRemoveButtonUnselected()
{
	document.images["removeButton"].src = "/images/location_map_controls/remove_unselected_button.png";
	removeButtonState = 0;
	return true;
}

// image setters for Traffic button
function setTrafficButtonSelected()
{
	document.images["trafficButton"].src= "/images/location_map_controls/traffic_selected_button.png";
	trafficButtonState = 1;
	return true;
}

function setTrafficButtonUnselected()
{
	document.images["trafficButton"].src = "/images/location_map_controls/traffic_unselected_button.png";
	trafficButtonState = 0;
	return true;
}


// ----- HANDLERS  -----

// Add button handers
function handleAddButtonMouseOver()
{
	return true;
}

function handleAddButtonMouseOut()
{
	return true;
}

function handleAddButtonMouseDown()
{
	if(addButtonState == 0){
		setAddButtonSelected();
	}else{
		setAddButtonUnselected();
	}
	return true;
}

function handleAddButtonMouseUp()
{
	return true;
}


// Modify button handers
function handleModifyButtonMouseOver()
{
	return true;
}

function handleModifyButtonMouseOut()
{
	return true;
}

function handleModifyButtonMouseDown()
{
	if(modifyButtonState == 0){
		setModifyButtonSelected();
	}else{
		setModifyButtonUnselected();
	}
	return true;
}

function handleModifyButtonMouseUp()
{
	return true;
}


// Remove button handers
function handleRemoveButtonMouseOver()
{
	return true;
}

function handleRemoveButtonMouseOut()
{
	return true;
}

function handleRemoveButtonMouseDown()
{
	if(removeButtonState == 0){
		setRemoveButtonSelected();
	}else{
		setRemoveButtonUnselected();
	}
	return true;
}

function handleRemoveButtonMouseUp()
{
	return true;
}


// Traffic button handers
function handleTrafficButtonMouseOver()
{
	return true;
}

function handleTrafficButtonMouseOut()
{
	return true;
}

function handleTrafficButtonMouseDown()
{
	if(trafficButtonState == 0){
		setTrafficButtonSelected();
		enableTraffic();
	}else{
		setTrafficButtonUnselected();
		disableTraffic();
	}
	return true;
}

function handleTrafficButtonMouseUp()
{
	return true;
}