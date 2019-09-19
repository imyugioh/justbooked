import Reflux from 'reflux';
import HttpService  from '../http_service'
// import SearchActions  from  '../search_actions'

let SearchStore = Reflux.createStore({
  // listenables: [SearchActions],

  search: function(params) {
    HttpService.get('/api/search.json', params)
          .then(function(json) {
            this.result = json;
            // console.log("from store...");
            // console.log(this.result); 
            this.fireUpdate();
          }.bind(this));
  },

  filters: function() {
    HttpService.get('/api/search/filters.json')
          .then(function(json) {
            this.result = json;
            this.fireUpdate();
          }.bind(this));
  },

  fireUpdate: function() {
    this.trigger(this.result);
  }

});


export default SearchStore;
