// set default position, center of U.S.
var centerLatitude = 37.0625;
var centerLongitude = -95.677068;
var startZoom = 4;
var map;
var resultsToDisplay = 25;

// used to give the user a hint for setting the home location, this is a one time only event
var dragHomeHintGiven = false;

// used to clear the hint window box for dragging and droping home location if its open, one time only event
var dragHomeHintGivenCleared = true;

// used to give the user a hint for setting the home location using search bar
var searchHomeHintGiven = false;

// custom home icon to use as the marker
// Google Map Custom Marker Maker 2009
// Please include the following credit in your code
// Sample custom marker code created with Google Map Custom Marker Maker
// http://www.powerhut.co.uk/googlemaps/custom_markers.php
var houseIcon = new GIcon();
houseIcon.image = '../images/house_icon_marker/image.png';
houseIcon.shadow = '../images/house_icon_marker/shadow.png';
houseIcon.iconSize = new GSize(43,44);
houseIcon.shadowSize = new GSize(65,44);
houseIcon.iconAnchor = new GPoint(22,44);
houseIcon.infoWindowAnchor = new GPoint(22,0);
houseIcon.printImage = '../images/house_icon_marker/printImage.gif';
houseIcon.mozPrintImage = '../images/house_icon_marker/mozPrintImage.gif';
houseIcon.printShadow = '../images/house_icon_marker/printShadow.gif';
houseIcon.transparent = '../images/house_icon_marker/transparent.png';
houseIcon.imageMap = [23,0,24,1,25,2,27,3,28,4,29,5,31,6,32,7,33,8,34,9,36,10,37,11,38,12,40,13,41,14,41,15,41,16,41,17,41,18,41,19,41,20,41,21,41,22,41,23,41,24,41,25,41,26,41,27,41,28,41,29,41,30,39,31,38,32,36,33,34,34,33,35,31,36,30,37,28,38,26,39,25,40,23,41,21,42,20,43,17,43,16,42,15,41,14,40,13,39,11,38,10,37,8,36,7,35,6,34,4,33,3,32,2,31,2,30,2,29,2,28,2,27,2,26,2,25,2,24,2,23,2,22,2,21,2,20,2,19,2,18,2,17,2,16,1,15,0,14,0,13,0,12,1,11,2,10,3,9,3,8,4,7,5,6,6,5,7,4,7,3,8,2,9,1,10,0];

var marker; // stores the single marker that is maninpulated in this map

// gets the array of elements in the forms for form 0 (the first form)
oFormObject = document.forms[0];

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
  document.getElementById("searchresults").innerHTML = "";
  document.getElementById("search").value = address;
  showAddress();
}

  // ====== Geocoding ======
  function showAddress() {
	// user seems to know what thier doing, they don't need search hints
	searchHomeHintGiven = true;
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
				document.getElementById('continue-button').style.display = 'none';
				document.getElementById("message").innerHTML = '';
				document.getElementById("lat").innerHTML = '<b>Latitude:&nbsp;</b>?';
				document.getElementById("lng").innerHTML = '<b>Longitude:&nbsp;</b>?';
				document.getElementById("searchresults").innerHTML = "Did you mean:";
				// Loop through the results
				for (var i=0; i<result.Placemark.length; i++) {
			   		var p = result.Placemark[i].Point.coordinates;
			   		document.getElementById("searchresults").innerHTML += "<br>"+(i+1)+": <a href='javascript:showExactAddress(\"" + result.Placemark[i].address + "\")'>" + result.Placemark[i].address + "<\/a>";
		    	}
		 	}
		 	// ===== If there was a single marker, check if the returned address significantly different =====
		 	else 
		 	{
		 		document.getElementById("searchresults").innerHTML = "";
				if (different(search, result.Placemark[0].address)) {
					document.getElementById('continue-button').style.display = 'none';
					document.getElementById("message").innerHTML = '';
					document.getElementById("lat").innerHTML = '<b>Latitude:&nbsp;</b>?';
					document.getElementById("lng").innerHTML = '<b>Longitude:&nbsp;</b>?';
					document.getElementById("searchresults").innerHTML = "Did you mean: ";
			    	var p = result.Placemark[0].Point.coordinates;
			    	document.getElementById("searchresults").innerHTML += "<a href='javascript:showExactAddress(\"" + result.Placemark[0].address +"\")'>"+ result.Placemark[0].address+"<\/a>";
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
 			document.getElementById("searchresults").innerHTML = 'Could not find "' + search + '"<br />' + '<font color="red">' + reason + '</font>';
			document.getElementById("message").innerHTML = '';
			document.getElementById('continue-button').style.display = 'none';
			document.getElementById("lat").innerHTML = '<b>Latitude:&nbsp;</b>?';
			document.getElementById("lng").innerHTML = '<b>Longitude:&nbsp;</b>?';
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
		
	    // If ClientLocation was filled in by the loader, use that info instead default center of the U.S.
	    if (google.loader.ClientLocation) {
	    	startZoom = 13;
	    	centerLatitude = google.loader.ClientLocation.latitude;
			centerLongitude = google.loader.ClientLocation.longitude;
			setMarker(new google.maps.LatLng(centerLatitude, centerLongitude));
	    	location = "Showing IP-based location: <b>" + getFormattedLocation() + "</b>";
			document.getElementById('continue-button').style.display = 'block';
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
			if(dragHomeHintGivenCleared == false){
				map.closeInfoWindow();
			}
			setMarker(latlng);
		});
		
		GEvent.addListener(map, "mouseover", function(overlay){
			if(searchHomeHintGiven == false){
				document.getElementById("message").innerHTML = "<b>Hint: Higher accuracy yields better results.<br .>Try entering your home address in the search<br />bar to set your home location.</b>";
				searchHomeHintGiven = true;
				redFadeIn("message");
			}
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
	var markerOptions = {icon:houseIcon, draggable: true};
	marker = new GMarker(latlng, markerOptions);
	
	// add dragable listener
	GEvent.addListener(marker, "dragend", function() {
		updateLatLngInputFields(marker.getLatLng());
		// clear messages
		document.getElementById("message").innerHTML = "";
	});
	
	GEvent.addListener(marker, "dragstart", function() {
		if(dragHomeHintGivenCleared == false){
			map.closeInfoWindow();
		}
	});
	
	GEvent.addListener(marker, "mouseover", function() {
		if(dragHomeHintGiven==false)
		{
			marker.openInfoWindowHtml("<p>&nbsp;&nbsp;&nbsp;Hint: You can click the map <br />&nbsp;&nbsp;&nbsp;or drag and drop the icon to<br />&nbsp;&nbsp;&nbsp;fine tune your home location!</p>");
			dragHomeHintGiven = true;
			dragHomeHintGivenCleared = false;
		}
	});
	
	map.addOverlay(marker);
	
	// clear messages
	document.getElementById("message").innerHTML = "";
	
	// update the input form 
	updateLatLngInputFields(latlng);
}

function updateLatLngInputFields(latlng){
	document.getElementById("lat").innerHTML = '<b>Latitude:&nbsp;</b>' + latlng.lat();
	document.getElementById("lng").innerHTML = '<b>Longitude:&nbsp;</b>' + latlng.lng();
	centerLatitude = latlng.lat();
	centerLongitude = latlng.lng();
	document.getElementById('continue-button').style.display = 'block';
	document.getElementById("searchresults").innerHTML = "";
}

function clearMarkers(){
	map.clearOverlays();
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

function showOptions()
{
	document.getElementById('url-generator').style.display = 'none';
	document.getElementById('generator-options').style.display = 'block';
	document.getElementById('link').value = 'http://www.zombiestrategies.com/locations.pdf?ll=' + centerLatitude + ',' + centerLongitude + '&results=' + resultsToDisplay;
	//window.location.href = '/locations.pdf?ll=' + centerLatitude + ',' + centerLongitude + '&results=' + resultsToDisplay;
	return false;
}

function downloadPDF()
{
	window.location.href = '/locations.pdf?ll=' + centerLatitude + ',' + centerLongitude + '&results=' + resultsToDisplay;
	return false;
}

function done()
{
	window.location.href = '/guide';
	return false;
}

function handleDoneMouseOver()
{
	document.images["doneButton"].src= "../images/location_map_controls/done_selected_button.png";
	return false;
}

function handleDoneMouseOut()
{
	document.images["doneButton"].src= "../images/location_map_controls/done_unselected_button.png";
	return false;
}

function handleDownloadMouseOver()
{
	document.images["downloadButton"].src= "../images/location_map_controls/download_selected_button.png";
	return false;
}

function handleDownloadMouseOut()
{
	document.images["downloadButton"].src= "../images/location_map_controls/download_unselected_button.png";
	return false;
}

function handleContinueMouseOver()
{
	document.images["continueButton"].src= "../images/location_map_controls/continue_selected_button.png";
	return false;
}

function handleContinueMouseOut()
{
	document.images["continueButton"].src= "../images/location_map_controls/continue_unselected_button.png";
	return false;
}

// special effects
function redFadeIn(elemID) {
  element = document.getElementById(elemID);
  var b = 0;
  function f() {
    element.style.color = 'rgb('+b+',0,0)';
    if (b < 175) {
	  b+=5;
      setTimeout(f, 20);
    }
  };
  f();
}

// initialize and cleanup google maps
google.load("maps", "2", {callback: init});
window.onunload = GUnload;
