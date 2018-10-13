var ng = {
  core: require("@angular/core")
};

var AppComponent = ng.core.Component({
  selector: "shine-customers-app",
  template: "<router-outlet></router-outlet>"
}).Class({
  constructor: [
    function() {}
  ]
});

module.exports = AppComponent;
