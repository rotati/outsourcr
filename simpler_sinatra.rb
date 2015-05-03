require 'rubygems'
require 'sinatra'
require 'simpler_tiles'

# Grab the user's home directory
ROOT = File.expand_path("~")

set :port, 80
set :bind, '0.0.0.0'

# Set up a route that will grab the path to a shapefile and render the
# index template below.
get '/shape/*' do
  erb :index
end

# Set up the tile url to capture x, y, z coordinates for slippy tile generation
get '/tiles/*/:x/:y/:z.png' do

  # Let the browser know we are sending a png
  content_type 'image/png'

  # Create a Map object
  map = SimplerTiles::Map.new do |m|
    # Set the background color to black
    m.bgcolor = "#000000"

    # Set the slippy map parameters from the url
    m.slippy params[:x].to_i, params[:y].to_i, params[:z].to_i

    # Add a layer based on the parameters in the URL
    m.layer File.join(ROOT, params[:splat].first) do |l|

	puts File.join(ROOT, params[:splat].first)

      # Grab all of the data from the shapefile
      l.query "select * from '#{File.basename(params[:splat].first, '.shp')}'" do |q|

        # Add a style for stroke, fill, weight and set the line-join to be round
        q.styles 'stroke' => '#002240',
                 'weight' => '1',
                  'line-join' => 'round',
                   'fill' => '#ffffff',
                   "radius" => "1"
      end
    end
  end

  # Finally, render the map and ship it off
  map.to_png
end

# A simple inline template for the map
__END__

@@index
<!doctype html>
<html>
<head>
  <link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.css" />
  <script src="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.js"></script>
  <style>
    body, html {
      margin: 0;
      padding: 0;
      background-color: #000000;
      width: 100%;
      height: 100%;
    }
    #map {
      width: 100%;
      height: 100%;
    }
  </style>
</head>
<body>
  <div id="map"></div>
  <script>
    var map = new L.Map('map');
    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);
    var layer = new L.TileLayer('/tiles/<%= params[:splat].first %>/{x}/{y}/{z}.png')
    map.addLayer(layer).setView(new L.LatLng(38, -95), 1);
  </script>
</body>
</html>

