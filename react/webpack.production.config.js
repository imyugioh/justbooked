var webpack = require('webpack');
var path = require('path');
var loaders = require('./webpack.loaders');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var WebpackCleanupPlugin = require('webpack-cleanup-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');
var fs = require('fs');
var gracefulFs = require('graceful-fs');


gracefulFs.gracefulify(fs);

loaders.push({
  test: /\.scss$/,
  loader: ExtractTextPlugin.extract({fallback: 'style-loader', use : 'css-loader?sourceMap&localIdentName=[local]___[hash:base64:5]!sass-loader?outputStyle=expanded'}),
  exclude: ['node_modules']
});

module.exports = {
  entry: {
    home_app: './src/home_app.jsx',
    search_filter_app: './src/search_filter_app.jsx'
  },  
  output: {
    path: path.join(__dirname, 'public'),
    filename: '[name].js',
    publicPath: './'
  },
  resolve: {
    extensions: ['.js', '.jsx']
  },
  module: {
    loaders
  },
  plugins: [
    new WebpackCleanupPlugin(),
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: '"production"'
      }
    }),
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false,
        screw_ie8: true,
        drop_console: true,
        drop_debugger: true
      }
    }),
    new webpack.optimize.OccurrenceOrderPlugin(),
    new ExtractTextPlugin({
      filename: 'style.css',
      allChunks: true
    }),
    new HtmlWebpackPlugin({
      template: './src/template.html',
      files: {
        css: ['style.css'],
        js: ['bundle.js'],
      }
    }),
    new CopyWebpackPlugin([
        { from: './public/home_app.js', to: '../public/assets/javascripts/home_app.js' },
        { from: './public/search_filter_app.js', to: '../public/assets/javascripts/search_filter_app.js' }
    ])
  ]
};
