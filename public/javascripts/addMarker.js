$(document).ready(function() {

  // Check to see if the browser supports the GeoLocation API.
  if (navigator.geolocation) {
    // Get the location
    navigator.geolocation.getCurrentPosition(function(position) {
      var lat = position.coords.latitude;
      var lon = position.coords.longitude;

      // Show the map
      showMap(lat, lon);
    });
  } else {
    // Print out a message to the user.
    document.write('Your browser does not support GeoLocation.  Do Better.');
  }

  // Go to http://127.0.0.1:3000/pins.json || $(window).location + ".json" and loop through the results (which would be your pins)
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
      title: 'TEST TITLE'
  });

  // Create an info box
  var infowindow = new google.maps.InfoWindow({
    content: marker.title
  });
  // Show info box on point click
  google.maps.event.addListener(marker, 'click', function() {
    infowindow.open(map, marker);
  });
}