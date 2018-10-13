var reflectMetadata = require("reflect-metadata");
var ng = {
  core: require("@angular/core"),
  http: require("@angular/http"),
  router: require("@angular/router")
};

var CustomerDetailsComponent = ng.core.Component({
  selector: "shine-customer-details",
  template: require("./CustomerDetailsComponent.html")
}).Class({
  constructor: [
    ng.router.ActivatedRoute,
    ng.http.Http,
    function(activatedRoute, http) {
      this.activatedRoute = activatedRoute;
      this.customer = null;
      this.http = http;
    }
  ],

  ngOnInit: function() {
    var self = this;
    var observableFailed = function(response) {
      window.alert(response);
    };

    var customerGetSuccess = function(response) {
      self.customer = response.json().customer;
    };

    var routeSuccess = function(params) {
      self.http.get(
        "/customers/" + params['id'] + ".json"
      ).subscribe(customerGetSuccess, observableFailed);
    };

    self.activatedRoute.params.subscribe(routeSuccess, observableFailed);
    // self.activatedRoute.params.subscribe(
    //   function(params) {
    //     var id = +params['id'];
    //     self.id = id;
    //   }
    // );
  }
});

module.exports = CustomerDetailsComponent;
