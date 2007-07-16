import Fins;
inherit Fins.FinsController;
import Tools.Logging;

Fins.FinsController admin;

void start() {
  admin = load_controller("admin_controller");
}

public void index(Request id, Response response, mixed args) {
  if (id->misc->session_variables->userid) {
    response->redirect("/admin");
  }
  object v;
  if (sizeof(Flippers.Objects.User()->find(([ "admin" : 1 ])))) {
    mapping page = ([ 
	"title" : "Welcome to Flippers",
	"name"  : "welcome"
      ]);
    v = view->get_view(page->name);
    v->add("page", page);
    v->add("fins.version", Fins.__version);
  }
  else {
    mapping page = ([ 
	"title" : "Welcome to Flippers",
	"name"  : "createfirstuser"
      ]);
    v = view->get_view(page->name);
    v->add("page", page);
    v->add("fins.version", Fins.__version);
  }
  response->set_view(v);
}

public void createfirstuser(Request id, Response response, mixed args) {
  if (sizeof(Flippers.Objects.User()->find(([ "admin" : 1 ])))) {
    response->redirect("/");
  }
  if (id->variables->ajax) {
    int uid = createAdminUser(id->variables->username, id->variables->password);
    if (uid) {
      string json = Tools.JSON.serialize(([ "username" : Flippers.Objects.User(uid)["username"], "uid" : uid ]));
      id->misc->session_variables->userid = uid;
      response->set_data(json);
    }
  }
  else {
    mapping page = ([ 
	"title" : "Welcome to Flippers",
	"name"  : "createfirstuser"
      ]);
    object v = view->get_view(page->name);
    v->add("page", page);
    v->add("fins.version", Fins.__version);
    response->set_view(v);
  }
}

public void login(Request id, Response response, mixed args) {
  mapping page = ([ 
      "title" : "Welcome to Flippers",
      "name"  : "login"
      ]);
  object v = view->get_view(page->name);
  v->add("page", page);
  v->add("fins.version", Fins.__version);
  if (id->variables->username &&
      stringp(id->variables->username) &&
      sizeof(id->variables->username) &&
      id->variables->password &&
      stringp(id->variables->password) &&
      sizeof(id->variables->password)
      ) {
     array _users = Flippers.Objects.User()->find(([ "username" : id->variables->username ]));
     if (sizeof(_users)) {
       object user = _users[0];
       if (Crypto.verify_crypt_md5(id->variables->password, user["password"])) {
	 if (id->variables->ajax) {
	   id->misc->session_variables->userid = user["id"];
	   string json = Tools.JSON.serialize(([ "auth" : "1", "redirect" : "/admin" ]));
	   response->set_data(json);
	 }
	 else {
	   id->misc->session_variables->userid = user["id"];
	   response->redirect("/admin");
	 }
       }
       else {
	 if (id->variables->ajax) {
	   response->set_data((string)Tools.JSON.serialize(([ "auth" : "0", "flash" : "Incorrect password" ])));
	 }
	 else {
	   v->add("flash", "Incorrect Password");
	   response->set_view(v);
	 }
       }
     }
     else {
       if (id->variables->ajax) {
	 string json = Tools.JSON.serialize(([ "auth" : 0, "flash" : "User unknown" ]));
	 response->set_data(json);
       }
       else {
	 v->add("flash", "User Unknown");
	 response->set_view(v);
       }
     }
  }
  else {
    response->set_view(v);
  }
}

static int createAdminUser(string username, string password) { 
  Log.info("Creating admin user %O\n", username);
  object newuser = Flippers.Objects.User();
  newuser["username"] = username;
  newuser["password"] = Crypto.make_crypt_md5(password);
  newuser["admin"] = 1;
  newuser->save();
  return newuser["id"];
}
