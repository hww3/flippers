dojo.require("dojo.event.*");
dojo.require("dojo.widget.*");
dojo.require("dojo.widget.Button");

function init() {
  var showLoginButton = dojo.widget.byId("showLoginButton");
  dojo.event.connect(showLoginButton, 'onClick', 'showLoginPressed');
}

function showLoginPressed() {
  alert("test");
}
