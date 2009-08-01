var centerLatitude = 37.4419;
var centerLongitude = -122.1419;
var startZoom = 12;
var map;

var curItems;
var curItemsHTML = '';

function init() {
  updateItems();
  if (GBrowserIsCompatible()) {
    map = new GMap2(document.getElementById("map"));
    map.setCenter(new GLatLng(centerLatitude, centerLongitude), startZoom);
	map.addControl(new GLargeMapControl());
	map.addControl(new GScaleControl());
	map.addControl(new GMapTypeControl());
	map.enableScrollWheelZoom();
    listMarkers();

    GEvent.addListener(map, "click", function(overlay, latlng) {
	  
	  // get current list  of items and html checkboxes
	  updateItems();
	
      if (overlay == null) {
        //create an HTML DOM form element
        var inputForm = document.createElement("form");
        inputForm.setAttribute("action","");
        inputForm.id='store-input'
        inputForm.onsubmit = function() {storeMarker(); return false;};
        
        //retrieve the longitude and lattitude of the click point
        var lng = latlng.lng();
        var lat = latlng.lat();
  
        inputForm.innerHTML = '<fieldset style="width:150px;">'
            + '<span style="color:"black">'
            + '<legend>New Store</legend>'
            + '<label for="store">Store</label>'
            + '<input type="text" id="store" name="store" style="width:100%;"/>'
			+ '<br /><br />'
			+ curItemsHTML
			+ '<br />'
			+ '<input type="submit" value="Save"/>'
            + '<input type="hidden" id="longitude" name="lng" value="' + lng + '"/>'
            + '<input type="hidden" id="latitude" name="lat" value="' + lat + '"/>'
            + '</span>'
            + '</fieldset>';
  
        map.openInfoWindow (latlng,inputForm);
      }
    });
  }
}

function storeMarker(){
    var lng = document.getElementById("longitude").value;
    var lat = document.getElementById("latitude").value;

    var getVars =  "?store[store]=" + document.getElementById("store").value
        + "&store[lng]=" + lng
        + "&store[lat]=" + lat ;

    var request = GXmlHttp.create();

    //call the store_marker action back on the server
    request.open('GET', 'stores/create.js' + getVars, true);
    request.onreadystatechange = function() {
        if (request.readyState == 4) {
            //the request is complete

            var success=false;
            var content='Error contacting web service';
            try {
              //parse the result to JSON (simply by eval-ing it)
              res=eval( "(" + request.responseText + ")" );
              content=res.content;
              success=res.success;              
            }catch (e){
              success=false;
            }

            //check to see if it was an error or success
            if(!success) {
                alert(content);
            } else {
                //create a new marker and add its info window
                var latlng = new GLatLng(parseFloat(lat),parseFloat(lng));
                var marker = createMarker(latlng, content);
                map.addOverlay(marker);
                map.closeInfoWindow();
            }
        }
    }
    request.send(null);
    return false;
}

function createMarker(latlng, html) {
     var marker = new GMarker(latlng);
     GEvent.addListener(marker, 'click', function() {
          var markerHTML = html;
          marker.openInfoWindowHtml(markerHTML);
    });
    return marker;
}

// plots all of the markers, on the google map, that are returned from the stores.js controller
function listMarkers() {
  var request = GXmlHttp.create();
  //tell the request where to retrieve data from.
  request.open('GET', 'stores.js', true);
  //tell the request what to do when the state changes.
  request.onreadystatechange = function() {
    if (request.readyState == 4) {
      //parse the result to JSON,by eval-ing it.
      //The response is an array of markers

      markers=eval( "(" + request.responseText + ")" );
	
      for (var i = 0 ; i < markers.length ; i++) {
        
		var marker = markers[i].store ; // so get the list of attributes we want here
		
        var lat=marker.lat;
        var lng=marker.lng;
        //check for lat and lng so MSIE does not error
        //on parseFloat of a null value
        if (lat && lng) {
        	var latlng = new GLatLng(parseFloat(lat),parseFloat(lng));
        	var html = '<div><strong>Store: </strong> ' + marker.store;
			html += '<ul>';
			for (j=0; j<marker.items.length; j++)
			{
				if(marker.items[j].item){
					html += '<li>' + marker.items[j].item + '</li>';
				}
			}
			html += '</ul>' + '</div>';
		
        	var marker = createMarker(latlng, html);
        	map.addOverlay(marker);
        } // end of if lat and lng
      } // end of for loop
    } //if
  } //function
  request.send(null);
}


// updates the global variable curItems to contain the latest array of items returned by the items.js controller
function updateItems(){
	var request = GXmlHttp.create();
	//tell the request where to retrieve data from.
	request.open('GET', 'items.js', true);
	//tell the request what to do when the state changes.
 	request.onreadystatechange = function() {
		if (request.readyState == 4) {
	      //parse the result to JSON,by eval-ing it.
	      //The response is an array of items in the DB
	      curItems = eval( "(" + request.responseText + ")" );
		  curItemsHTML = '<label for="items">Items</label><br />';
		  for (i=0; i<curItems.length; i++)
		  {
		  	curItemsHTML += '<input type="checkbox" name="items" value="' + curItems[i].item.id + '"  /> ' + curItems[i].item.item + '<br />';
		  }
		}
	}
	request.send(null);
}

window.onload = init;
window.onunload = GUnload;
