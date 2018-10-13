require ("application.css");
require("bootstrap/dist/css/bootstrap.css");
var coreJS = require('core-js');
var zoneJS = require('zone.js');
var reflectMetadata = require('reflect-metadata');
var ng = {
  core: require("@angular/core"),
  common: require("@angular/common"),
  compiler: require("@angular/compiler"),
  forms: require("@angular/forms"),
  platformBrowser: require("@angular/platform-browser"),
  platformBrowserDynamic: require("@angular/platform-browser-dynamic"),
  router: require("@angular/router"),
  http: require("@angular/http")
};

var AngularTestComponent = ng.core.Component({
  selector: "shine-angular-test",
  template: '\
    <h2 *ngIf="salutation">Hello {{salutation}}!</h2> \
    <form> \
      <div class="form-group"> \
        <label for="name">Name</label> \
        <input type="text" id="name" class="form-control" name="name" bindon-ngModel="salutation"> \
      </div> \
    </form> \
  '
}).Class({
  constructor: function() {
    this.salutation = null;
  }
});

var AngularTestAppModule = ng.core.NgModule({
  imports: [ ng.platformBrowser.BrowserModule, ng.forms.FormsModule ],
  declarations: [ AngularTestComponent ],
  bootstrap: [ AngularTestComponent ]
})
.Class({
  constructor: function() {}
});

var CustomerAppComponent = require("./CustomerAppComponent");
var CustomerSearchComponent = require("./CustomerSearchComponent");
var CustomerDetailsComponent = require("./CustomerDetailsComponent");

var routing = ng.router.RouterModule.forRoot([
  {
    path: "",
    component: CustomerSearchComponent
  },
  {
    path: ":id",
    component: CustomerDetailsComponent
  }
]);

var CustomerSearchAppModule = ng.core.NgModule({
  imports: [
    ng.platformBrowser.BrowserModule,
    ng.forms.FormsModule,
    ng.http.HttpModule,
    routing],
  declarations: [
    CustomerSearchComponent,
    CustomerDetailsComponent,
    CustomerAppComponent
  ],
  bootstrap: [CustomerAppComponent]
}).Class({
  constructor: function() {}
});

document.addEventListener('DOMContentLoaded', function() {
  var shouldBootstrap = document.getElementById("angular-test");
  if (shouldBootstrap) {
    ng.platformBrowserDynamic.platformBrowserDynamic().bootstrapModule(AngularTestAppModule);
  }
  // if(document.getElementById("shine-customer-search")) {
  //   ng.platformBrowserDynamic.platformBrowserDynamic().bootstrapModule(CustomerSearchAppModule);
  // }
  if (document.getElementById("shine-customer-search")) {
    ng.platformBrowserDynamic.
      platformBrowserDynamic().
      bootstrapModule(CustomerSearchAppModule);
  }
});
