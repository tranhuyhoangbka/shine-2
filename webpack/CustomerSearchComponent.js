var reflectMetadata = require("reflect-metadata");
var ng = {
  core: require("@angular/core"),
  http: require("@angular/http")
};

var CustomerSearchComponent = ng.core.Component({
  selector: "shine-customer-search",
  template: '\
    <header> \
      <h1 class="h2">Customer Search</h1> \
    </header> \
    <section class="search-form"> \
      <form> \
        <div class="input-group input-group-lg"> \
          <label for="keywords" class="sr-only">Keywords></label> \
          <input type="text" id="keywords" name="keywords" \
            placeholder="First Name, Last Name, or Email Address"\
            class="form-control input-lg" bindon-ngModel="keywords" \
            on-ngModelChange="search($event)">\
          <span class="input-group-btn"> \
          </span> \
        </div> \
      </form> \
    </section> \
    <section class="search-results" *ngIf="customers"> \
      <header> \
        <h1 class="h3">Results</h1> \
      </header> \
      <ol class="list-group"> \
        <li *ngFor="let customer of customers" \
          class="list-group-item clearfix"> \
          <h3 class="float-right"> \
            <small class="text-uppercase">Joined</small> \
            {{customer.created_at}}\
          </h3> \
          <h2 class="h3"> \
            {{customer.first_name}} {{customer.last_name}}\
            <small>{{customer.username}}</small> \
          </h2> \
          <h4>{{customer.email}}</h4> \
        </li> \
      </ol> \
    </section> \
  '
}).Class({
  constructor: [
    ng.http.Http,
    function(http) {
      this.customers = null;
      this.http = http;
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
  }
});

module.exports = CustomerSearchComponent;
