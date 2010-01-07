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
	if(!clearCheckmarks()){
		alert("Could not contact webserver!");
		return false;
	}
	// give it a half sec to finish clearing checkboxes
    setTimeout('setCheckboxes()', 500);
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
      		//The response is an array of two arrays [[categories][products]]
      		resource=eval( "(" + request.responseText + ")" );
			if(resource == null){
				alert("Profile does not exist!");
				return false;
			}
      		for (var i = 0 ; i < resource.location_profile.categories.length ; i++) {
				var category = resource.location_profile.categories[i];
				document.getElementById("category_ids_" + category.id).checked = true;
      		} // end of categories for loop
			for (var i = 0 ; i < resource.location_profile.products.length ; i++) {
				var product = resource.location_profile.products[i];
				document.getElementById("product_ids_" + product.id).checked = true;
      		} // end of products for loop
    	} //if
	} //function
	request.send(null);	
}

function clearCheckmarks(){
	if(clearCategoryCheckmarks() && clearProductCheckmarks()){
		return true;
	}
	return false;
}

function clearCategoryCheckmarks(){
	var url = '/categories.js';
	// create request
  	var request = GXmlHttp.create();
  	//tell the request where to retrieve data from.
  	request.open('GET', url, true);
  	//tell the request what to do when the state changes.
  	request.onreadystatechange = function() {
    	if (request.readyState == 4) {
			//parse the result to JSON,by eval-ing it.
      		categories=eval( "(" + request.responseText + ")" );
			if(categories == null){
				// uh o, something really bad if this happens
				return false;
			}
			// clear all category checkmarks
			for (var i = 0 ; i < categories.length ; i++) {
				var category = categories[i].category;
				document.getElementById("category_ids_" + category.id).checked = false;
      		}
    	}
	} 
	request.send(null);
	return true;
}

function clearProductCheckmarks(){
	var url = '/products.js';
	// create request
  	var request = GXmlHttp.create();
  	//tell the request where to retrieve data from.
  	request.open('GET', url, true);
  	//tell the request what to do when the state changes.
  	request.onreadystatechange = function() {
    	if (request.readyState == 4) {
			//parse the result to JSON,by eval-ing it.
      		products=eval( "(" + request.responseText + ")" );
			if(products == null){
				// uh o, something really bad if this happens
				return false;
			}
			// clear all product checkmarks
			for (var i = 0 ; i < products.length ; i++) {
				var product = products[i].product;
				document.getElementById("product_ids_" + product.id).checked = false;
      		}
    	}
	}
	request.send(null);
	return true;
}