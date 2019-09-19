var webpack = require('webpack');
var UglifyJsPlugin = webpack.optimize.UglifyJsPlugin;
var env = process.env.WEBPACK_ENV || 'dev';
var WebpackDevServer = require('webpack-dev-server');
var CopyWebpackPlugin = require('copy-webpack-plugin');
var path = require('path');

var appName = 'app';
var host = '0.0.0.0';
var port = '9000';

var plugins = [], outputFile;



plugins.push(
  new CopyWebpackPlugin([
      { from: './lib/home_app_build.js', to: '../../public/assets/javascripts/home_app_build.js' },
      { from: './lib/home_app_build.js.map', to: '../../public/assets/javascripts/home_app_build.js.map' },

      { from: './lib/listing_app_build.js', to: '../../public/assets/javascripts/listing_app_build.js' },
      { from: './lib/listing_app_build.js.map', to: '../../public/assets/javascripts/listing_app_build.js.map' },

      { from: './lib/carts_app_build.js', to: '../../public/assets/javascripts/carts_app_build.js' },
      { from: './lib/carts_app_build.js.map', to: '../../public/assets/javascripts/carts_app_build.js.map' },

      { from: './lib/checkout_app_build.js', to: '../../public/assets/javascripts/checkout_app_build.js' },
      { from: './lib/checkout_app_build.js.map', to: '../../public/assets/javascripts/checkout_app_build.js.map' },

    ])
);


function outputFile(name) {
  var filename = '';
  if (env === 'build') {
    plugins.push(new UglifyJsPlugin({ minimize: true }));
    filename = `${name}.min.js`;
  } else {
    filename = `${name}.js`;
  }
  return filename;
}

var config = {
  test: function() {
    return "hello";
  },
  entry: {
    home_app: './src/home_app.jsx',
    listing_app: './src/listing_app.jsx',
    carts_app: './src/carts_app.jsx',
    checkout_app: './src/checkout_app.jsx'
  },
  devtool: 'source-map',
  output: {
    path: __dirname + '/lib',
    filename: "[name]_build.js",
    publicPath: __dirname + '/example'
  },

  module: {
    loaders: [
      {
        test: /(\.jsx|\.js)$/,
        loader: 'babel',
        exclude: /(node_modules|bower_components)/,
        query: {
          presets: ['react', 'es2015']
        }
      },
      // {
      //   test: /(\.jsx|\.js)$/,
      //   loader: "eslint-loader",
      //   exclude: /node_modules/
      // },
      {
        test: /\.css$/,
        loaders: [ 'style-loader', 'css-loader' ]
      },
      {
        test: /\.json$/,
        loader: 'json-loader'
      }
    ]
  },
  resolve: {
    root: path.resolve('./src'),
    extensions: ['', '.js', '.jsx']
  },
  plugins: plugins
};

if (env === 'dev') {
  new WebpackDevServer(webpack(config), {
    contentBase: './htmls',
    hot: true,
    debug: true
  }).listen(port, host, function (err, result) {
    if (err) {
      console.log(err);
    }
  });
  console.log('-------------------------');
  console.log('Local web server runs at http://' + host + ':' + port);
  console.log('-------------------------');
}

module.exports = config;
