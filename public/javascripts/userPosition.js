$(document).ready(function() {
  
  // no lat/lon in address bar so detect location and then pass it
  if (window.location.search == "") {
    
    // Check to see if the browser supports the GeoLocation API.
    if (navigator.geolocation) {
      
      // Get the location
      navigator.geolocation.getCurrentPosition(function(position) {
        var lat = position.coords.latitude;
        var lon = position.coords.longitude;

        $("#currentLat").val(lat);
        $("#currentLon").val(lon);

        // add location to url
        window.location.replace(window.location.pathname + "?lon=" + lon + "&lat=" + lat);
      });
    } else {
      // Print out a message to the user.
      document.write('Your browser does not support GeoLocation. Do Better.');
    }
  } else if (window.location.search[0] == '?') {
    // parse url
    var search = window.location.search;
    var parts = search.split('&');
    var a = parts[0].split('=');
    var b = parts[1].split('=');
    var lon = a[1];
    var lat = b[1];
    showMap(lat, lon);
  } 

  // Show the user's position on a Google map.
  function showMap(lat, lon) {
    $("#currentLat").val(lat);
    $("#currentLon").val(lon);

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
        title: 'Your Location',
        icon: '/images/blue_dot.png'
    });

    $.each($(".list-group-item"), function(idx, item){
      var longitude = $(item).find(".lon").text();
      var latitude = $(item).find(".lat").text();
      var location = new google.maps.LatLng(longitude, latitude);
      
      var ico = '/images/red-pin.png'
      if (window.location.pathname == "/pins") { 
        ico = '/images/green-pin.png' 
      }

      var marker = new google.maps.Marker({
        position: location,
        title: $(item).find(".pin-name").text(),
        distance: $(item).find(".dist").text(),
        from: $(item).find(".from").text(),
        clickable: true,
        map: map,
        icon: ico
      });
      // Create an info box
      var infowindow = new google.maps.InfoWindow({
        content: marker.from
      });
      // Show info box on point click
      google.maps.event.addListener(marker, 'click', function() {
        infowindow.open(map, marker);
      });
    });

    var styleArray = [{
     featureType: "poi.business",
     elementType: "labels",
     stylers: [{ visibility: "off" }]
    }];

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

      window.location.replace(window.location.pathname + "?lon=" + event.latLng.F + "&lat=" + event.latLng.A);
    });
  }
});
