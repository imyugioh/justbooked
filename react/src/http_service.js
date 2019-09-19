import 'whatwg-fetch'

export default class HttpService  {
  static get(urlString, params) { 
    let baseUrl = window.location.protocol + "//" + window.location.host
    var url = new URL(baseUrl + urlString)

    if (params) {
      var searchParams = new URLSearchParams()
      Object.keys(params).forEach((key) => {
        searchParams.append(key, params[key])
      })
      url.search = searchParams.toString()
    }

    // return Fetch.json(url.toString())
    return fetch(url.toString(), {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'X-CSRF-Token': this.token(),
        },
        method: 'get',
        credentials: 'include'
      }).then(function(response) {
        if (response.status === 401) {
         HttpService.redirect_to_login();
        } else {
          return response.json();
        }
        }).catch(function(error) {
          console.log("Error fetching........ " + error);
    });
  }


  static post(url, params) {
    return fetch(url, {
      headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.token(),
      },
      method: 'post',
      credentials: 'include',
      body: JSON.stringify(params)
    }).then(function(response) {
      if (response.status === 401) {
       HttpService.redirect_to_login();
      } else if (response.status === 201) {
        console.log("201 response error")
      } else {
        return response.json();
      }
      }).catch(function(error) {
        console.log("Error fetching........ " + error);
    });
  }

  static put(url, params) {
      return fetch(url, {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'X-CSRF-Token': this.token(),
        },
        method: 'put',
        credentials: 'include',
        body: JSON.stringify(params)
      }).then(function(response) {
        if (response.status === 401) {
         HttpService.redirect_to_login();
        } else if (response.status !== 200) {
         console.log("Put error ...................");
         console.log(response)
        } else {
          return response.json();
        }
        }).catch(function(error) {
          console.log("Error fetching........ " + error);
      });
  }


  static delete(url, params) {
      return fetch(url, {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'X-CSRF-Token': this.token(),
        },
        method: 'delete',
        credentials: 'include',
        body: JSON.stringify(params)
      }).then(function(response) {
        if (response.status === 401) {
         HttpService.redirect_to_login();
        } else if (response.status !== 200) {
         console.log("Delete error ...................");
         console.log(response)
        } else {
          return response.json();
        }
        }).catch(function(error) {
          console.log("Error fetching........ " + error);
      });
  }

  static token() {
    let el = document.querySelector('meta[name="csrf-token"]')
    return el ? el.getAttribute('content') : '';
  }

  static redirect_to_login() {
    console.log("Logged out redirect to login page");
    window.location.href = "/sign_in";
  }
}
