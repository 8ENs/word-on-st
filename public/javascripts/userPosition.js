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
    zoom: 14,
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
      title: 'YOUR LOCATION',
      icon: '/images/blue_dot.png'
  });

  // var pins = map.data.loadGeoJson('https://api.myjson.com/bins/36fm8');

  var pins = [{"_id":"5562a19ad0ba3a3ae4000001","coordinates":[60.72004402309875,-135.0508548904907],"created_at":"2015-05-24T21:14:18-07:00","message":"Baked","recipient":"Ben","updated_at":"2015-05-24T21:14:18-07:00","url":null,"user_id":"55623d2ed0ba3af89c000001"},{"_id":"5562a1a5d0ba3a3ae4000002","coordinates":[60.71549959999999,-135.0489237],"created_at":"2015-05-24T21:14:29-07:00","message":"MakeIT","recipient":"Ben","updated_at":"2015-05-24T21:14:29-07:00","url":null,"user_id":"55623d2ed0ba3af89c000001"},{"_id":"5562a1c4d0ba3a3ae4000003","coordinates":[60.73737190278714,-135.0754416827392],"created_at":"2015-05-24T21:15:00-07:00","message":"YuKonstruct","recipient":"Public","updated_at":"2015-05-24T21:15:00-07:00","url":null,"user_id":"55623d2ed0ba3af89c000001"}];

  for (var x in pins) {
    var pin = pins[x];
    var location = new google.maps.LatLng(pin.coordinates[0], pin.coordinates[1]);
    var marker = new google.maps.Marker({
      position: location,
      title: pin.message,
      map: map
  });
  }

  // var pins = [{"_id":"5562a19ad0ba3a3ae4000001","coordinates":[60.72004402309875,-135.0508548904907],"created_at":"2015-05-24T21:14:18-07:00","message":"Baked","recipient":"Ben","updated_at":"2015-05-24T21:14:18-07:00","url":null,"user_id":"55623d2ed0ba3af89c000001"},{"_id":"5562a1a5d0ba3a3ae4000002","coordinates":[60.71549959999999,-135.0489237],"created_at":"2015-05-24T21:14:29-07:00","message":"MakeIT","recipient":"Ben","updated_at":"2015-05-24T21:14:29-07:00","url":null,"user_id":"55623d2ed0ba3af89c000001"},{"_id":"5562a1c4d0ba3a3ae4000003","coordinates":[60.73737190278714,-135.0754416827392],"created_at":"2015-05-24T21:15:00-07:00","message":"YuKonstruct","recipient":"Public","updated_at":"2015-05-24T21:15:00-07:00","url":null,"user_id":"55623d2ed0ba3af89c000001"}]

  // $.getJSON("/pins.json", function(data){
  //    // loop  and add markers
  //    map.data.loadGeoJson('/pins.json');
  // });

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

  // Redirect to page WITH lat/lon
  // window.location.replace("/pins?lon=" + lon + "&lat=" + lat);
}
