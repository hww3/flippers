
dojo.require("dojo.event.*");
dojo.require("dojo.style");
dojo.require("dojo.io.*");

function init() {
  /* Hook the buttons up to their ajaxiness */
  dojo.event.connect(document.getElementById('logout'), 'onclick', logoutPressed);
  enableButtons();
}

function pageLoader(page, init) {
  var bindArgs = {
    url : '/admin/' + page,
    sync : false,
    error : function(type, errObj) {
	      for (prop in errObj) {
		console.debug(prop + ' : ' + errObj[prop]);
	      }
	      flash('Unknown error');
	    },
    load : function(type, data, evt) {
	     var html = data.toString();
	     sendToBack('page_content', html);
	     crossFade('page_content', function() { disableButton(page); if (init) { init(); } });
	   }
  };
  dojo.io.bind(bindArgs);
}

function crossFade(el, done) {
  var front = document.getElementById(el + '_front');
  var back = document.getElementById(el + '_back');
  dojo.lfx.html.fadeOut(back, 750, dojo.lfx.easeInOut, function() { dojo.style.setVisibility(back, 0); }).play();
  dojo.lfx.html.fadeIn(front, 750, dojo.lfx.easeInOut, done).play();
}

function sendToBack(el, html) {
  var front = document.getElementById(el + '_front');
  var back = document.getElementById(el + '_back');

  /* Hide the back element */
  dojo.style.setVisibility(back, 0);
  dojo.style.setOpacity(back, 1);

  /* Copy the content from front to back */
  back.innerHTML = front.innerHTML;

  /* Position and resize the back element to match the front one */
  var x = dojo.html.getAbsoluteX(front);
  var y = dojo.html.getAbsoluteY(front);
  dojo.html.setStyleAttributes(back, 'position : absolute; left : ' + x + 'px; top : ' + y + 'px;');
  dojo.html.setContentBox(back, dojo.html.getContentBox(front));

  /* The elements should match now */
  dojo.style.setVisibility(back, 1);
  dojo.style.setOpacity(front, 0);
  dojo.style.setVisibility(front, 1);

  /* Populate the front with the new content */
  front.innerHTML = html;
}

function flash(msg) {
  sendToBack('flash', msg);
  crossFade('flash', function() {});
}

function logoutPressed() {
  window.location = '/admin/logout';
}

function disableButton(disable) {
  var buttons = [ 'ports', 'applications', 'users', 'servers', 'statistics', 'prefs' ];
  for (id in buttons) {
    var el;
    try { el = document.getElementById(buttons[id]); 
      if (el) {
	if (el.id == disable)
	  el.disabled = true;
	else
	  el.disabled = false;
      }
      el = 0;
    } catch(e) {}
  }
}

function enableButtons() {
  try {
    var el = document.getElementById('ports');
    dojo.event.connect(el, 'onclick', function() {
	  pageLoader('ports', ports_init);
	});
  } catch(e) {}
  try {
    var el = document.getElementById('applications');
    dojo.event.connect(el, 'onclick', function() {
	  pageLoader('applications', applications_init);
	});
  } catch(e) {}
  try {
    var el = document.getElementById('users');
    dojo.event.connect(el, 'onclick', function() {
	  pageLoader('users', users_init);
	});
  } catch(e) {}
  var el = document.getElementById('servers');
  dojo.event.connect(el, 'onclick', function() {
      pageLoader('servers', servers_init);
      });
  var el = document.getElementById('statistics');
  dojo.event.connect(el, 'onclick', function() {
      pageLoader('statistics', statistics_init);
      });
  var el = document.getElementById('prefs');
  dojo.event.connect(el, 'onclick', function() {
      pageLoader('prefs', prefs_init);
      });
}

function ports_init() {
  dojo.event.connect(document.getElementById('create_port'), 'onclick', ports_showCreatePort);
}

function ports_showCreatePort() {
  var table = document.getElementById('create_port_table');
  var button = document.getElementById('create_port');
  button.disabled = true;
  dojo.style.setOpacity(table, 0);
  dojo.style.setVisibility(table, 1);
  var x = dojo.html.getAbsoluteX(button);
  var y = dojo.html.getAbsoluteY(button);
  dojo.html.setStyleAttributes(table, 'position : absolute; left : ' + x + 'px; top : ' + y + 'px; height: auto;');

  dojo.lfx.html.fadeOut(button, 750, dojo.lfx.easeInOut, function() {}).play();
  dojo.lfx.html.fadeIn(table, 750, dojo.lfx.easeInOut, function() {}).play();
}

function applications_init() {
}

function users_init() {
}

function servers_init() {
}

function statistics_init() {
}

function prefs_init() {
}

dojo.addOnLoad(init);
