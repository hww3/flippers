import Fins;
import Tools.Logging;
inherit Fins.JSONRPCController;
inherit Flippers.Web;

public void createfirstuser(Request id, Response response, mixed args) {
  if (sizeof(Flippers.Objects.User()->find(([ "admin" : 1 ])))) {
    response->redirect("/");
  }
  int uid = createAdminUser(id->variables->username, id->variables->password);
  if (uid) {
    return ([ "user" : Flippers.Objects.User(uid) ]);
  }
  else
    response->redirect("/");
}

public void test(Request id, Response response, mixed args) { 
  return ([ "a" : 1, "b" : 2, "c" : "d" ]);
}
