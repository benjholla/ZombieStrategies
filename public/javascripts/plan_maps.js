// set default position, center of U.S.
var centerLatitude = 37.0625;
var centerLongitude = -95.677068;
var startZoom = 4;
var map;

var curItems;
var curItemsHTML = '';

var trafficInfo;

// this is to combat an event (movend) that is triggered when adding a traffic overlay or single map clicks
var suppressMoveEnd = false;

// ====== Create a Client Geocoder ======
var geo = new GClientGeocoder(); 

// ====== Array for decoding the failure codes ======
var reasons=[];
reasons[G_GEO_SUCCESS]            = "Success";
reasons[G_GEO_MISSING_ADDRESS]    = "Missing Address: The address was either missing or had no value.";
reasons[G_GEO_UNKNOWN_ADDRESS]    = "Unknown Address:  No corresponding geographic location could be found for the specified address.";
reasons[G_GEO_UNAVAILABLE_ADDRESS]= "Unavailable Address:  The geocode for the given address cannot be returned due to legal or contractual reasons.";
reasons[G_GEO_BAD_KEY]            = "Bad Key: The API key is either invalid or does not match the domain for which it was given";
reasons[G_GEO_TOO_MANY_QUERIES]   = "Too Many Queries: The daily geocoding quota for this site has been exceeded.";
reasons[G_GEO_SERVER_ERROR]       = "Server error: The geocoding request could not be successfully processed.";

// ===== list of words to be standardized =====
var standards = [   ["road","rd"],   
                    ["street","st"], 
                    ["avenue","ave"], 
                    ["av","ave"], 
                    ["drive","dr"],
                    ["saint","st"], 
                    ["north","n"],   
                    ["south","s"],    
                    ["east","e"], 
                    ["west","w"],
                    ["expressway","expy"],
                    ["parkway","pkwy"],
                    ["terrace","ter"],
                    ["turnpike","tpke"],
                    ["highway","hwy"],
                    ["lane","ln"]
                 ];

// ===== convert words to standard versions =====
function standardize(a) {
  for (var i=0; i<standards.length; i++) {
    if (a == standards[i][0])  {a = standards[i][1];}
  }
  return a;
}

// ===== check if two addresses are sufficiently different =====
function different(a,b) {
  // only interested in the bit before the first comma in the reply
  var c = b.split(",");
  b = c[0];
  // convert to lower case
  a = a.toLowerCase();
  b = b.toLowerCase();
  // remove apostrophies
  a = a.replace(/'/g ,"");
  b = b.replace(/'/g ,"");
  // replace all other punctuation with spaces
  a = a.replace(/\W/g," ");
  b = b.replace(/\W/g," ");
  // replace all multiple spaces with a single space
  a = a.replace(/\s+/g," ");
  b = b.replace(/\s+/g," ");
  // split into words
  awords = a.split(" ");
  bwords = b.split(" ");
  // perform the comparison
  var reply = false;
  for (var i=0; i<bwords.length; i++) {
    //GLog.write (standardize(awords[i])+"  "+standardize(bwords[i]))
    if (standardize(awords[i]) != standardize(bwords[i])) {reply = true}
  }
  //GLog.write(reply);
  return (reply);
}

function getFormattedLocation() {
  if (google.loader.ClientLocation.address.country_code == "US" &&
    google.loader.ClientLocation.address.region) {
    return google.loader.ClientLocation.address.city + ", " 
        + google.loader.ClientLocation.address.region.toUpperCase();
  } else {
    return  google.loader.ClientLocation.address.city + ", "
        + google.loader.ClientLocation.address.country_code;
  }
}

function showExactAddress(address) {
  document.getElementById("message").innerHTML = "";
  document.getElementById("search").value = address;
  showAddress();
}

  // ====== Geocoding ======
  function showAddress() {
    var search = document.getElementById("search").value;
    // ====== Perform the Geocoding ======        
    geo.getLocations(search, function (result)
    { 
        // If that was successful
        if (result.Status.code == G_GEO_SUCCESS) {
		 	// ===== If there was more than one result, "ask did you mean" on them all =====
		 	if (result.Placemark.length > 1) { 
				document.getElementById("message").innerHTML = "Did you mean:";
				// Loop through the results
				for (var i=0; i<result.Placemark.length; i++) {
			   		var p = result.Placemark[i].Point.coordinates;
			   		document.getElementById("message").innerHTML += "<br>"+(i+1)+": <a href='javascript:showExactAddress(\"" + result.Placemark[i].address + "\")'>" + result.Placemark[i].address + "<\/a>";
		    	}
		 	}
		 	// ===== If there was a single marker, check if the returned address significantly different =====
		 	else 
		 	{
		 		document.getElementById("message").innerHTML = "";
				if (different(search, result.Placemark[0].address)) {
					document.getElementById("message").innerHTML = "Did you mean: ";
			    	var p = result.Placemark[0].Point.coordinates;
			    	document.getElementById("message").innerHTML += "<a href='javascript:showExactAddress(\"" + result.Placemark[0].address +"\")'>"+ result.Placemark[0].address+"<\/a>";
				}
			 	else
			 	{
			    	var p = result.Placemark[0].Point.coordinates;
					// ===== Look for the bounding box of the first result =====
		          	var N = result.Placemark[0].ExtendedData.LatLonBox.north;
		          	var S = result.Placemark[0].ExtendedData.LatLonBox.south;
		          	var E = result.Placemark[0].ExtendedData.LatLonBox.east;
		          	var W = result.Placemark[0].ExtendedData.LatLonBox.west;
		          	var bounds = new GLatLngBounds(new GLatLng(S,W), new GLatLng(N,E));
		          	// Choose a zoom level that fits
		          	var zoom = map.getBoundsZoomLevel(bounds);
		          	map.setCenter(bounds.getCenter(),zoom);
		  	 	}
		  	}
        }
        // ====== Decode the error status ======
        else {
          	var reason="Code " + result.Status.code;
          	if (reasons[result.Status.code]) {
            	reason = reasons[result.Status.code]
          	}
 			document.getElementById("message").innerHTML = 'Could not find "' + search + '"<br />' + '<font color="red">' + reason + '</font>';
        }
      }
    );
  }

 function disableTraffic() {
     map.removeOverlay(trafficInfo);
 } 


 function enableTraffic() {
	 var trafficOptions = {incidents:false}; // change to true to add traffic incidents
	 trafficInfo = new GTrafficOverlay(trafficOptions);
	 suppressMoveEnd = true;
     map.addOverlay(trafficInfo);
 }


function init() {
  if (GBrowserIsCompatible()) {
    map = new GMap2(document.getElementById("map"));

	var location = "";
    // If ClientLocation was filled in by the loader, use that info instead
    if (google.loader.ClientLocation) {
    	startZoom = 13;
    	centerLatitude = google.loader.ClientLocation.latitude;
		centerLongitude = google.loader.ClientLocation.longitude;
    	location = "Showing IP-based location: <b>" + getFormattedLocation() + "</b>";
    }
	map.setCenter(new GLatLng(centerLatitude, centerLongitude), startZoom);
	
	document.getElementById("message").innerHTML = location;
    
	map.addControl(new GLargeMapControl());
	map.addControl(new GScaleControl());
	map.addControl(new GMapTypeControl());
	
	

	// terrain view
	map.addMapType(G_PHYSICAL_MAP);
	
	// zoom controls
	map.enableDoubleClickZoom(); 
	map.enableContinuousZoom();
	map.enableScrollWheelZoom();
	
	
	//map.enableGoogleBar();  //should either enable this or the scale (they like to overlap)
	
	//Uncomment this code to set that max and min zoom levels for all map types
	/*
	var minMapScale = 5;
	var maxMapScale = 14;
	// get array of map types
	var mapTypes = map.getMapTypes();
	// overwrite the getMinimumResolution() and getMaximumResolution() methods for each map type
	for (var i=0; i<mapTypes.length; i++) {
		mapTypes[i].getMinimumResolution = function() {return minMapScale;}
		mapTypes[i].getMaximumResolution = function() {return maxMapScale;}
	}
	*/
	
	// add markers that are in view to the map
    listMarkers(map.getCenter());

	// if the map is scrolled update markers, this also catches 'zoomend' events
	GEvent.addListener(map, 'moveend', function(){
		if(suppressMoveEnd == false){
			listMarkers(map.getCenter());
		}
		suppressMoveEnd = false;
	});

    GEvent.addListener(map, "click", function(overlay, latlng) {
		if(addButtonState == 1){
			// user is adding a location
			addLocation(overlay, latlng);
		}
    });

  }
}

function addLocation(overlay, latlng){
	if (overlay == null) {
        //create an HTML DOM form element
        var inputForm = document.createElement("form");
        inputForm.setAttribute("action","");
        inputForm.id='location-input'
        inputForm.onsubmit = function() {redirectToNewLocations(); return false;};
        
        //retrieve the longitude and lattitude of the click point
        var lng = latlng.lng();
        var lat = latlng.lat();
  
        inputForm.innerHTML = '<fieldset style="width:230px;">'
            + '<span style="color:"black">'
            + '<legend>New Location</legend>'	
			+ '<br />'
			+ '<p>Latitude = ' + lat + '</p>'
			+ '<p>Longitude = ' + lng + '</p>'
			+ '<br />'
			+ '<center><input type="submit" value="   Add New Entry Here   "/></center>'
            + '<input type="hidden" id="longitude" name="lng" value="' + lng + '"/>'
            + '<input type="hidden" id="latitude" name="lat" value="' + lat + '"/>'
            + '</span>'
            + '</fieldset>';
  
		suppressMoveEnd = true;
        map.openInfoWindow (latlng,inputForm);
      }
}

function viewLocation(id, marker){
	var request = GXmlHttp.create();
	//tell the request where to retrieve data from.
	request.open('GET', 'locations/' + id + '.js', true);
	//tell the request what to do when the state changes.
	var locationHTML;
 	request.onreadystatechange = function() {
		if (request.readyState == 4) {
	    	//parse the result to JSON,by eval-ing it.
	    	//The response is an array of items in the DB
	    	resource = eval( "(" + request.responseText + ")" );
			var locationHTML = '<center><strong>Location Type:&nbsp;&nbsp;' + resource.location.location_profile.name + '</strong><br /><br />'
			+ '<input type="button" value="    View Location    " onclick="window.location.href=\'/locations/' + resource.location.id  + '\'"/></center>';
			suppressMoveEnd = true;
			marker.openInfoWindowHtml(locationHTML);
		}
	}
	request.send(null);
}

function modifyLocation(id, marker){
	var request = GXmlHttp.create();
	//tell the request where to retrieve data from.
	request.open('GET', 'locations/' + id + '.js', true);
	//tell the request what to do when the state changes.
	var locationHTML;
 	request.onreadystatechange = function() {
		if (request.readyState == 4) {
	    	//parse the result to JSON,by eval-ing it.
	    	//The response is an array of items in the DB
	    	resource = eval( "(" + request.responseText + ")" );
			var locationHTML = '<center><strong>Location Type:&nbsp;&nbsp;' + resource.location.location_profile.name + '</strong><br /><br />'
			+ '<input type="button" value="    Edit Location    " onclick="window.location.href=\'/locations/' + resource.location.id  + '\'"/></center>';
			suppressMoveEnd = true;
			marker.openInfoWindowHtml(locationHTML);
		}
	}
	request.send(null);
}

function deleteLocation(id, marker){
	var request = GXmlHttp.create();
	//tell the request where to retrieve data from.
	request.open('GET', 'locations/' + id + '.js', true);
	//tell the request what to do when the state changes.
	var locationHTML;
 	request.onreadystatechange = function() {
		if (request.readyState == 4) {
	    	//parse the result to JSON,by eval-ing it.
	    	//The response is an array of items in the DB
	    	resource = eval( "(" + request.responseText + ")" );
			var locationHTML = '<center><strong>Location Type:&nbsp;&nbsp;' + resource.location.location_profile.name + '</strong><br /><br />'
			+ '<input type="button" value="    Delete Location    " onclick="window.location.href=\'/locations/' + "destroy/" + + resource.location.id + '\'"/></center>';
			suppressMoveEnd = true;
			marker.openInfoWindowHtml(locationHTML);
		}
	}
	request.send(null);
}

function redirectToNewLocations(){
	var lat = document.getElementById("latitude").value;
	var lng = document.getElementById("longitude").value;
	
	window.location='/locations/new' + '?lat=' + lat + '&lng=' + lng;
	
    return false;
}

function createMarker(latlng, html, id) {
	var marker = new GMarker(latlng);
	GEvent.addListener(marker, 'click', function() {
		if(modifyButtonState == 1){
			// user is modifying a location
			modifyLocation(id, marker);
		}else if(removeButtonState == 1){
			// user is deleting a location
			deleteLocation(id, marker);
		}else{
			// no action selected, just open it for viewing
			viewLocation(id, marker);
		}
    });
    return marker;
}

// plots all of the markers, on the google map, that are returned from the stores.js controller
function listMarkers(latlng) {
	// clear screen and repopulate with new information
	map.clearOverlays();
	// if traffic maps are enabled add it back in because it just got cleared
	if(trafficButtonState == 1){
		enableTraffic();
	}
	// format request to perform server side filtering of location points
	var bounds = map.getBounds();
	var southWest = bounds.getSouthWest();
	var northEast = bounds.getNorthEast();
	var url = 'locations.js?ne=' + northEast.toUrlValue() + '&sw=' + southWest.toUrlValue() + '&ll=' + latlng.toUrlValue();
	// create request
  	var request = GXmlHttp.create();
  	//tell the request where to retrieve data from.
  	request.open('GET', url, true);
  	//tell the request what to do when the state changes.
  	request.onreadystatechange = function() {
    	if (request.readyState == 4) {
      		//parse the result to JSON,by eval-ing it.
      		//The response is an array of markers
      		markers=eval( "(" + request.responseText + ")" );
      		for (var i = 0 ; i < markers.length ; i++) {
				var marker = markers[i].location ; // get each location object
        		var lat=marker.lat;
        		var lng=marker.lng;
        		//check for lat and lng so MSIE does not error
        		//on parseFloat of a null value
        		if (lat && lng) {
        			var latlng = new GLatLng(parseFloat(lat),parseFloat(lng));
        			var html = 'test';
        			var marker = createMarker(latlng, html, marker.id);
        			map.addOverlay(marker);
        		} // end of if lat and lng
      		} // end of for loop
    	} //if
	} //function
	request.send(null);
}

google.load("maps", "2", {callback: init});
//window.onload = init;
window.onunload = GUnload;
