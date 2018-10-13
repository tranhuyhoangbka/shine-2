var reflectMetadata = require("reflect-metadata");
var ng = {
  core: require("@angular/core"),
  http: require("@angular/http"),
  router: require("@angular/router")
};

var CustomerSearchComponent = ng.core.Component({
  selector: "shine-customer-search",
  template: require("./CustomerSearchComponent.html")
}).Class({
  constructor: [
    ng.http.Http,
    ng.router.Router,
    function(http, router) {
      this.customers = null;
      this.http = http;
      this.router = router;
      this.keywords = "";
    }
  ],
  search: function($event) {
    var self = this;
    self.keywords = $event;
    if (self.keywords.length < 3) {
      return;
    }
    self.http.get(
      "/customers.json?keywords=" + self.keywords
    ).subscribe(
      function(response) {
        self.customers = response.json().customers;
      },
      function(response) {
        alert(response);
      }
    );
  },

  viewDetails: function(customer) {
    this.router.navigate(["/", customer.id]);
  },
});

module.exports = CustomerSearchComponent;
