dojo.require("dojo.event.*");
dojo.require("dojo.style");
dojo.require("dojo.io.*");

function init() {
  var button = document.getElementById('login_show');
  button.type = 'button';
  dojo.event.connect(button, 'onclick', buttonPressed);
  dojo.style.setVisibility(document.getElementById('login_options'), 0);
}

function buttonPressed() {
  var table = document.getElementById('login_options');
  var button = document.getElementById('login_show');
  button.disabled = true;
  dojo.style.setOpacity(table, 0);
  dojo.style.setVisibility(table, 1);
  var x = dojo.html.getAbsoluteX(button);
  var y = dojo.html.getAbsoluteY(button);
  dojo.html.setStyleAttributes(table, 'position : absolute; left : ' + x + 'px; top : ' + y + 'px; height: auto;');

  dojo.lfx.html.fadeOut(button, 750, dojo.lfx.easeInOut, function() {}).play();
  dojo.lfx.html.fadeIn(table, 750, dojo.lfx.easeInOut, function() {}).play();

  var submit = document.getElementById('login_go');
  submit.type = 'button';
  dojo.event.connect(submit, 'onclick', ajaxLogin);
}

function ajaxLogin() {
  var u = document.getElementById('username');
  var p = document.getElementById('password');
  var flash = document.getElementById('flash');
  var submit = document.getElementById('login_go');
  var table = document.getElementById('login_options');
  u.disable = true;
  p.disable = true;
  submit.disable = true;
  flash.innerHTML = '';
  var bindArgs = {
    formNode : buildForm( '/login', { ajax : 1, username : u.value, password : p.value } ),
    mimetype : 'text/html',
    sync : false,
    error : function(type, errObj) {
	      flash.innerHTML = 'Server error while logging in';
	      dojo.style.setOpacity(flash, 0);
	      dojo.style.setVisibility(dojo, 1);
	      dojo.lfx.html.fadeIn(flash, 750, dojo.lfx.easeInOut, function() {
		  u.disable = false;
		  p.disable = false;
		  submit.disable = false;
		  }).play();
	    },
    load : function(type, data, evt) {
	     res = dojo.json.evalJson(data.toString());
	     if (res['auth'] > 0) {
	       dojo.lfx.html.fadeOut(table, 750, dojo.lfx.easeInOut, function() { window.location = res.redirect; }).play();
	     }
	     else {
	       flash.innerHTML = res.flash;
	       dojo.style.setOpacity(flash, 0);
	       dojo.style.setVisibility(dojo, 1);
	       dojo.lfx.html.fadeIn(flash, 750, dojo.lfx.easeInOut, function() {
		   u.disable = false;
		   p.disable = false;
		   submit.disable = false;
		   }).play();
	     }
	   }
  };
  dojo.io.bind(bindArgs);
}

dojo.addOnLoad(init);
