$(document).ready(function() {

  // Check to see if the browser supports the GeoLocation API.
  if (navigator.geolocation) {
    // Get the location
    navigator.geolocation.getCurrentPosition(function(position) {
      var lat = position.coords.latitude;
      var lon = position.coords.longitude;

      // Show the map
      showMap(lat, lon);
      $("#currentLat").val(lat);
      $("#currentLon").val(lon);

      //Do ajax only if something...
      if(window.location.pathname == "/pins"){
        $.ajax("/pins.json", 
          {
            method: "GET",
            data: {long: lon, lat: lat}, 
            success: function(data) {
              //This is where you have to use the data
              $.each(data, function(idx, pin){
                //Add a pin to map
                console.log(pin, pin.coordinates[0], pin.coordinates[1])
              })
            }
          }
        );
      }
    });
  } else {
    // Print out a message to the user.
    document.write('Your browser does not support GeoLocation.  Do Better.');
  }

});

// Show the user's position on a Google map.
function showMap(lat, lon) {
  // Create a LatLng object with the GPS coordinates.
  var myLatLng = new google.maps.LatLng(lat, lon);

  // Create the Map Options
  var mapOptions = {
    zoom: 16,
    center: myLatLng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  // Generate the Map
  var map = new google.maps.Map(document.getElementById('map'), mapOptions);

  // Add a Marker to the Map
  var marker = new google.maps.Marker({
      position: myLatLng,
      map: map,
      clickable: true,
      draggable: true,
      title: 'YOUR LOCATION'
  });

  // Create an info box
  var infowindow = new google.maps.InfoWindow({
    content: marker.title
  });
  // Show info box on point click
  google.maps.event.addListener(marker, 'click', function() {
    infowindow.open(map, marker);
  });

  // Update coordinates on marker
  google.maps.event.addListener(marker, 'dragend', function(event) {
    $("#currentLat").val(event.latLng.A);
    $("#currentLon").val(event.latLng.F);
  });


}
