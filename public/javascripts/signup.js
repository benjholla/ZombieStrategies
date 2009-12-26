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

function init() {
  	if (GBrowserIsCompatible()) {
    	map = new GMap2(document.getElementById("map"));
	
		// used to store a resulting message from the geocoder
		//var location = "";
		
	    // If ClientLocation was filled in by the loader, use that info instead
	    if (google.loader.ClientLocation) {
	    	startZoom = 13;
	    	centerLatitude = google.loader.ClientLocation.latitude;
			centerLongitude = google.loader.ClientLocation.longitude;
			setMarker(new google.maps.LatLng(centerLatitude, centerLongitude));
	    	//location = "Showing IP-based location: <b>" + getFormattedLocation() + "</b>";
	    }
	
		// sets the map to the default position listed above, or the IP geocododed location if found
		map.setCenter(new GLatLng(centerLatitude, centerLongitude), startZoom);

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

// an alternate method to using a submit button for the search bar, adds return key search functionality
function submitenter(myfield,e)
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
