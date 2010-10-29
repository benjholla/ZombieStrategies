// button states, 0 = off (unselected), 1 == on (selected)
var addButtonState = 0;
var modifyButtonState = 0;
var removeButtonState = 0;
var trafficButtonState = 0;

// image setters for Add button
function setAddButtonSelected()
{
	document.images["addButton"].src= "../images/location_map_controls/add_selected_button.png";
	addButtonState = 1;
	setModifyButtonUnselected();
	setRemoveButtonUnselected();
	document.getElementById("map").className = "edit";
	//update the hidden location form
	document.getElementById("location_lat").value = "";
	document.getElementById("location_lng").value = "";
	document.getElementById("flash-message").innerHTML = "";
	// don't need to hide other forms, because buttoms getting unselected will call these for us
	hideViewLocationForm();
	return true;
}

function setAddButtonUnselected()
{
	document.images["addButton"].src = "../images/location_map_controls/add_unselected_button.png";
	addButtonState = 0;
	document.getElementById("map").className = "view";
	//update the hidden location form
	document.getElementById("location_lat").value = "";
	document.getElementById("location_lng").value = "";
	document.getElementById("flash-message").innerHTML = "";
	// hide the add form
	hideNewLocationForm();
	window.location.href='#top';
	// don't need to hide other forms, because buttoms getting unselected will call these for us
	return true;
}

// image setters for Modify button
function setModifyButtonSelected()
{
	document.getElementById("location_lat").value = "";
	document.getElementById("location_lng").value = "";
	document.getElementById("flash-message").innerHTML = "";
	document.images["modifyButton"].src= "../images/location_map_controls/modify_selected_button.png";
	modifyButtonState = 1;
	setAddButtonUnselected();
	setRemoveButtonUnselected();	
	hideViewLocationForm();
	// don't need to hide other forms, because buttoms getting unselected will call these for us
	return true;
}

function setModifyButtonUnselected()
{
	document.images["modifyButton"].src = "../images/location_map_controls/modify_unselected_button.png";
	modifyButtonState = 0;
	// hide the modify form
	hideModifyLocationForm();
	window.location.href='#top';
	return true;
}

// image setters for Remove button
function setRemoveButtonSelected()
{
	document.getElementById("flash-message").innerHTML = "";
	document.images["removeButton"].src= "../images/location_map_controls/remove_selected_button.png";
	removeButtonState = 1;
	setAddButtonUnselected();
	setModifyButtonUnselected();
	hideViewLocationForm();
	// don't need to hide other forms, because buttoms getting unselected will call these for us
	return true;
}

function setRemoveButtonUnselected()
{
	document.getElementById("flash-message").innerHTML = "";
	document.images["removeButton"].src = "../images/location_map_controls/remove_unselected_button.png";
	removeButtonState = 0;
	return true;
}

// image setters for Traffic button
function setTrafficButtonSelected()
{
	document.getElementById("flash-message").innerHTML = "";
	document.images["trafficButton"].src= "../images/location_map_controls/traffic_selected_button.png";
	trafficButtonState = 1;
	return true;
}

function setTrafficButtonUnselected()
{
	document.getElementById("flash-message").innerHTML = "";
	document.images["trafficButton"].src = "../images/location_map_controls/traffic_unselected_button.png";
	trafficButtonState = 0;
	return true;
}


// ----- HANDLERS  -----

// Add button handers
function handleAddButtonMouseOver()
{
	document.getElementById("hint-box").innerHTML = "<p><b>Hint: </b>To add a new supply location, click the Add button and then click the location on the map where you would like to add a new entry.</p>";
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
	document.getElementById("hint-box").innerHTML = "<p><b>Hint: </b>To modify a new supply location, click the Modify button and then click the location marker on the map which you would like to modify.</p>";
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
	document.getElementById("hint-box").innerHTML = "<p><b>Hint: </b>To delete a supply location, click the Delete button and then click the location marker on the map which you would like to remove.</p>";
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
	document.getElementById("hint-box").innerHTML = "<p><b>Hint: </b>Heavily populated areas equal more zombies in the event of a zombie outbreak!  The traffic view shows the density of traffic in real time.</p>";
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

// special effects

// special effects
function redFadeIn(elemID) {
  element = document.getElementById(elemID);
  var b = 0;
  function f() {
    element.style.color = 'rgb('+b+',0,0)';
    if (b < 255) {
	  b+=5;
      setTimeout(f, 20);
    }
  };
  f();
}