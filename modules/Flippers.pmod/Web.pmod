import Tools.Logging;

static int createAdminUser(string username, string password) { 
  Log.info("Creating admin user %O\n", username);
  object newuser = Flippers.Objects.User();
  newuser["username"] = username;
  newuser["password"] = Crypto.make_crypt_md5(password);
  newuser["admin"] = 1;
  newuser->save();
  return newuser["id"];
}
