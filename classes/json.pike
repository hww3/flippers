import Fins;
import Tools.Logging;
//inherit Fins.JSONRPCController;
inherit Fins.FinsController;
inherit Flippers.Web;

public void createfirstuser(Request id, Response response, mixed args) {
  if (sizeof(Flippers.Objects.User()->find(([ "admin" : 1 ])))) {
    response->redirect("/");
  }
  int uid = createAdminUser(id->variables->username, id->variables->password);
  if (uid) {
    response->set_data(Tools.JSON.serialize(([ "user" : Flippers.Objects.User(uid) ])));
  }
  else
    response->redirect("/");
}

public void test(Request id, Response response, mixed args) { 
  response->set_data(Tools.JSON.serialize(([ "a" : 1, "b" : 2, "c" : "d" ])));
}
