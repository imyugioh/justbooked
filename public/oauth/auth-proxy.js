// This auth-proxy.js can be placed on any HTML page to turn it into a
//  CloudSponge Proxy URL. 
// It pulls the proper OAuth parameters out and sends them to CloudSponge
//  to complete the next stage in the contact import. 
window.cloudspongeProxy = (function() {
  var proxyHost = 'https://api.cloudsponge.com/auth';
  var isOAuthPage, queryParams, oauthParams, key;
  var redirecting = false;

  // serializes an object into a query-string
  var serializeParams = function(params) {
    var k, results = [];
    for (k in params) {
      results.push(k + "=" + encodeURIComponent(params[k]));
    }
    return results.join('&');
  }

  // converts the URL string into an object
  var parseParams = function(url) {
    var obj = {};
    url.replace(/([^?=&]+)(=([^&]*))?/g, function($0, $1, $2, $3) {
      return obj[$1] = decodeURIComponent($3);
    });
    return obj;
  }

  // parse the query string
  var queryParams = parseParams(window.location.search);

  // selects just the OAuth-related params out of the query
  oauthParams = {};
  for (key in queryParams) {
    if (key === 'code' || key === 'state' || key === 'error' || key === 'error_code' || key === 'forward') {
      oauthParams[key] = queryParams[key];
    }
  }

  // checks to see if this page actually the necessary received OAuth params
  // and then flings the state and code up to CloudSponge to do the heavy lifting work
  if (oauthParams.state && (oauthParams.code || oauthParams.error || oauthParams.error_code)) {
    redirecting = true;
    window.location = proxyHost + '?' + serializeParams(oauthParams);
  }

  // add the redirect endpoint to any .cs-proxy links on the page
  window.addEventListener('load', function(){
    var i;
    var links = document.getElementsByClassName('cs-force');
    for (i = 0; i < links.length; i++) {
      links[i].href = proxyHost + window.location.search;
    }
  }, false)

  return {
    redirecting: redirecting,
    force: function(){
      window.location = proxyHost + window.location.search;
      return false;
    }
  };
})();