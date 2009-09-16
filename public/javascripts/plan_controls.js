// button states, 0 = off (unselected), 1 == on (selected)
var addButtonState = 0;
var modifyButtonState = 0;
var removeButtonState = 0;

// image setters for Add button
function setAddButtonSelected()
{
	document.images["addButton"].src= "/images/add_selected_button.png";
	addButtonState = 1;
	setModifyButtonUnselected();
	setRemoveButtonUnselected();
	return true;
}

function setAddButtonUnselected()
{
	document.images["addButton"].src = "/images/add_unselected_button.png";
	addButtonState = 0;
	return true;
}

// image setters for Modify button
function setModifyButtonSelected()
{
	document.images["modifyButton"].src= "/images/modify_selected_button.png";
	modifyButtonState = 1;
	setAddButtonUnselected();
	setRemoveButtonUnselected();
	return true;
}

function setModifyButtonUnselected()
{
	document.images["modifyButton"].src = "/images/modify_unselected_button.png";
	modifyButtonState = 0;
	return true;
}

// image setters for Remove button
function setRemoveButtonSelected()
{
	document.images["removeButton"].src= "/images/remove_selected_button.png";
	removeButtonState = 1;
	setAddButtonUnselected();
	setModifyButtonUnselected();
	return true;
}

function setRemoveButtonUnselected()
{
	document.images["removeButton"].src = "/images/remove_unselected_button.png";
	removeButtonState = 0;
	return true;
}

// HANDLERS

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
	if(addButtonState == 0){
		setAddButtonUnselected();
	}
	else{
		setAddButtonSelected();
	}
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
	if(modifyButtonState == 0){
		setModifyButtonUnselected();
	}
	else{
		setModifyButtonSelected();
	}
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
	if(removeButtonState == 0){
		setRemoveButtonUnselected();
	}
	else{
		setRemoveButtonSelected();
	}
	return true;
}