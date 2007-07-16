dojo.require("dojo.widget.Spinner");
dojo.require("dojo.event.*");
dojo.require("dojo.style");
dojo.require("dojo.io.*");

function init() {
  var button = document.getElementById("createfirstuser");
  button.type = 'button';
  dojo.event.connect(button, 'onclick', goCreateUser);
}

function goCreateUser() {
  var username = document.getElementById('username');
  var password = document.getElementById('password');
  var confirm = document.getElementById('confirm');
  var warning = 0;
  if (username.value.length < 3) {
    dojo.style.addClass(username, 'warning');
    document.getElementById('username_label').innerHTML = 'Name (3+ chars)';
    warning++;
  }
  else {
    dojo.style.removeClass(username, 'warning');
    document.getElementById('username_label').innerHTML = 'Name';
    if (password.value.length < 3) {
      dojo.style.addClass(password, 'warning');
      dojo.style.addClass(confirm, 'warning');
      document.getElementById('password_label').innerHTML = 'Password (3+ chars)';
      warning++;
    }
    else if (password.value != confirm.value) {
      dojo.style.addClass(password, 'warning');
      dojo.style.addClass(confirm, 'warning');
      document.getElementById('password_label').innerHTML = 'Password (no match)';
      warning++;
    }
    else {
    dojo.style.removeClass(password, 'warning');
    dojo.style.removeClass(confirm, 'warning');
    document.getElementById('password_label').innerHTML = 'Password';
    }
  }
  if (!warning) {
    var table = document.getElementById("createfirstusertable");
    document.getElementById('username').disabled=true;
    document.getElementById('password').disabled=true;
    document.getElementById('confirm').disabled=true;
    document.getElementById('createfirstuser').disabled=true;
    //dojo.style.setVisibility(table, 0);
    // replace with dojo.fx.wipeOut
    dojo.lfx.html.fadeOut(table, 750, dojo.lfx.easeInOut, function() {
      var u = username.value;
      var p = password.value;
      var div = table.parentNode;
      div.removeChild(table);
      var orig = div.innerHTML;
      div.innerHTML = orig + '<p>Creating user and attempting to log in...</p>';
      var bindArgs = {
	//url : '/createfirstuser?ajax=1',
	formNode : buildForm( '/createfirstuser', { ajax: 1, username : u, password : p } ),
	mimetype : 'text/html',
	sync : false,
	error : function(type, errObj) {
		  div.innerHTML = orig + '<p>Create user failed.</p>';
		  dojo.style.addClass(div.lastChild, 'warning');
		},
	load : function(type, data, evt) {
		 window.location = '/admin';
	       }
      };
      dojo.io.bind(bindArgs);
    }).play();
  }
}

dojo.addOnLoad(init);
