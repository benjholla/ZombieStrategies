// set home base for ames,ia (42.022864, -93.626792)
var centerLatitude = 42.022864;
var centerLongitude = -93.626792;
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
	
    listMarkers();

    GEvent.addListener(map, "click", function(overlay, latlng) {
	  
	  // get current list  of items and html checkboxes
	  //updateItems(); enable this if items are added regulary, if they are peridically added
	  // its better to only load on page initialization
	
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
	
	var array = document.getElementById("store_items").childNodes;

	for(var i=0; i<array.length; i++){
		if(array[i].checked == 1){
	   		getVars += "&store[items][]=" + array[i].value;
		}
	} 

    var request = GXmlHttp.create();

    //call the store_marker action back on the server
    request.open('GET', 'stores/create.js' + getVars, true);
    request.onreadystatechange = function() {
        if (request.readyState == 4) {
            //the request is complete

            var success=false;
            var content='Error contacting web service';
			var id;
            try {
              //parse the result to JSON (simply by eval-ing it)
              res=eval( "(" + request.responseText + ")" );
              content=res.content;
			  id = res.id;
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
                var marker = createMarker(latlng, content, id);
                map.addOverlay(marker);
                map.closeInfoWindow();
            }
        }
    }
    request.send(null);
    return false;
}

function createMarker(latlng, html, id) {
     var marker = new GMarker(latlng);
     GEvent.addListener(marker, 'click', function() {
		  //requery items for this store, reset html
          updateStore(id, marker);
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
			for (var j=0; j<marker.items.length; j++)
			{
				if(marker.items[j].item){
					html += '<li>' + marker.items[j].item + '</li>';
				}
			}
			html += '</ul>' + '</div>';
		
        	var marker = createMarker(latlng, html, marker.id);
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
		  curItemsHTML += '<div id="store_items">';
		  for (var i=0; i<curItems.length; i++)
		  {
		  	curItemsHTML += '<input type="checkbox" name="items" value="' + curItems[i].item.id + '"  /> ' + curItems[i].item.item + '<br />';
		  }
		  curItemsHTML += '</div>';
		}
	}
	request.send(null);
}

// returns the latest html for a given store id
function updateStore(id, marker){
	var request = GXmlHttp.create();
	//tell the request where to retrieve data from.
	request.open('GET', 'stores/' + id + '.js', true);
	//tell the request what to do when the state changes.
	var storeHTML;
 	request.onreadystatechange = function() {
		if (request.readyState == 4) {
	    	//parse the result to JSON,by eval-ing it.
	    	//The response is an array of items in the DB
	    	storeVar = eval( "(" + request.responseText + ")" );
			var storeHTML = '<div><strong>Store: </strong> ' + storeVar.store.store;
			storeHTML += '<ul>';
			for (var i=0; i<storeVar.store.items.length; i++)
			{
				if(storeVar.store.items[i].item){
					storeHTML += '<li>' + storeVar.store.items[i].item + '</li>';
				}
			}
			storeHTML += '</ul>' + '</div>';
			marker.openInfoWindowHtml(storeHTML);
		}
	}
	request.send(null);
}

window.onload = init;
window.onunload = GUnload;
