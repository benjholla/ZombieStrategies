// set default position, center of U.S.
var centerLatitude = 37.0625;
var centerLongitude = -95.677068;
var startZoom = 4;
var map;

var marker; // stores the single marker that is maninpulated in this map

// gets the array of elements in the forms for form 0 (the first form)
oFormObject = document.forms[0];

// this grabs the current value in the form for lat/lng
//latFormElement = oFormObject.elements["user_lat"];
//lngFormElement = oFormObject.elements["user_lng"];

// ******************************* START GEOCODER HELPER FUNCTIONS *******************************

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
	// clear out old markers
	clearMarkers();
	// get search query value
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
					// add a marker at the center bounds
					setMarker(bounds.getCenter());
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

// ******************************* END GEOCODER HELPER FUNCTIONS *******************************

function init() {
  	if (GBrowserIsCompatible()) {
    	map = new GMap2(document.getElementById("map"));
	
		// used to store a resulting message from the geocoder
		var location = "";
		
	    // If ClientLocation was filled in by the loader, use that info instead
	    if (google.loader.ClientLocation) {
	    	startZoom = 13;
	    	centerLatitude = google.loader.ClientLocation.latitude;
			centerLongitude = google.loader.ClientLocation.longitude;
			setMarker(new google.maps.LatLng(centerLatitude, centerLongitude));
	    	location = "Showing IP-based location: <b>" + getFormattedLocation() + "</b>";
	    }
	
		// sets the map to the default position listed above, or the IP geocododed location if found
		map.setCenter(new GLatLng(centerLatitude, centerLongitude), startZoom);
		
		// update the location div element
		document.getElementById("message").innerHTML = location;

		// add some nice controls to the map
		map.addControl(new GLargeMapControl());
		map.addControl(new GScaleControl());
		map.addControl(new GMapTypeControl());
		
		// add the terrain map type
		map.addMapType(G_PHYSICAL_MAP);
	
		// zoom controls
		//map.enableDoubleClickZoom(); 
		map.enableContinuousZoom();
		map.enableScrollWheelZoom();
	
		// this is disabled by default, because it overlaps with the other prefered controls, but it can also be used
		//map.enableGoogleBar();  //should either enable this or the scale (they like to overlap)
	
		// Uncomment this code to set that max and min zoom levels for all map types
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
	
		// add click action listener
		GEvent.addListener(map, "click", function(overlay, latlng){
			setMarker(latlng);
		});
	}
}

// deletes the old marker and adds a new marker at the given locations
// also updates form lat lng input fields
function setMarker(latlng){
	// if the new marker is the same as the old marker, do nothing
	if(marker && (marker == new GMarker(latlng))){
		return false;
	}
	// if theres an old marker, delete it
	if(marker)
	{
		map.removeOverlay(marker);
	}
	// add a new marker
	marker = new GMarker(latlng);
	map.addOverlay(marker);
	// update the input form 
	oFormObject.elements["user_lat"].value = latlng.lat();
	oFormObject.elements["user_lng"].value = latlng.lng();
	return false;
}

function clearMarkers(){
	map.clearOverlays();
}

// clears any markers on the map if the lat/lng fields are edited manually
function clearMarkersOnTyping(myfield,e){
	var keycode;
    if (window.event) keycode = window.event.keyCode;
    else if (e) keycode = e.which;
    else return true;
	
	clearMarkers();
	return true;
}

// an alternate method to using a submit button for the search bar, adds return key search functionality
function submitEnter(myfield,e)
{
    var keycode;
    if (window.event) keycode = window.event.keyCode;
    else if (e) keycode = e.which;
    else return true;

    if (keycode == 13)
    {
        showAddress();
        return false;
    }
    else
        return true;
}

// initialize and cleanup google maps
google.load("maps", "2", {callback: init});
window.onunload = GUnload;
