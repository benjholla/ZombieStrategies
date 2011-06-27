/*****

Should update this file, to first make the requests and and store the result, then clear and then set using the preretrieved results

this would solve the json delay issues and take away the need for the 500 ms delay...

*/


function promptLoad(){
	if(document.getElementById("location_location_profile_name").value == ""){
		alert("You must enter the name of a profile in the \"Location Type\" field to load a location profile!");
		return;
	}
	var r=confirm("This action will overwrite all records of the current location!");
	if (r==true){
		// continue with load
		loadProfile();
	}
}

function loadProfile(){	
	// clear all checkmarks
	clearCheckmarks();
	// add the checkbox marks
    setCheckboxes();
}

function setCheckboxes(){
	var url = '/location_profiles/' + document.getElementById("location_location_profile_name").value + '.js';
	// create request
  	var request = GXmlHttp.create();
  	//tell the request where to retrieve data from.
  	request.open('GET', url, true);
  	//tell the request what to do when the state changes.
  	request.onreadystatechange = function() {
    	if (request.readyState == 4) {
			//parse the result to JSON,by eval-ing it.
      		//The response is an array of two arrays [[categories][items]]
      		resource=eval( "(" + request.responseText + ")" );
			if(resource == null){
				alert("Profile does not exist! If you create a new location with this profile name, a new profile will be created for you automatically.");
				return false;
			}
      		for (var i = 0 ; i < resource.location_profile.categories.length ; i++) {
				var category = resource.location_profile.categories[i];
				document.getElementById("category_ids_" + category.id).checked = true;
      		} // end of categories for loop
			for (var i = 0 ; i < resource.location_profile.items.length ; i++) {
				var item = resource.location_profile.items[i];
				document.getElementById("item_ids_" + item.id).checked = true;
      		} // end of items for loop
    	} //if
	} //function
	request.send(null);	
}

function clearCheckmarks(){
	//clear categories
	var cat_index = 1;
	while(document.getElementById("category_ids_" + cat_index)){
		document.getElementById("category_ids_" + cat_index).checked = false;
		cat_index++;
	}
	
	//clear items
	var pro_index = 1;
	while(document.getElementById("item_ids_" + pro_index)){
		document.getElementById("item_ids_" + pro_index).checked = false;
		pro_index++;
	}
	return true;
}

function clearProfileForm(){
	document.getElementById("location_location_profile_name").value = "";
}

function clearLocationInfoForm(){
	document.getElementById("location_info").value = "";
}

function clearLocationAddressFields(){
	document.getElementById("location_name").value = "";
	document.getElementById("location_address").value = "";
	document.getElementById("location_city").value = "";
	document.getElementById("location_state_providence").value = "";
	document.getElementById("location_zip").value = "";
	document.getElementById("location_country").value = "";
}

function resetLocationClassificationField(){
	var selection = document.classifications.location_classification_id;
	if(selection[0]){
		selection[0].checked = true;
	}
}