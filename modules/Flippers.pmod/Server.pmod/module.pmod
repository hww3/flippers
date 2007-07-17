import Tools.Logging;

static array ports = ({});

void start(array ports) {
  // Takes an array of server ports from the Model to start.
  foreach(ports, object _p) {
    object p = Flippers.Server.Port();
    p->address(_p["address"]);
    p->port(_p["port"]);
    if (_p["ssl"]) {
      // FIXME
      // I don't really know what's needed in terms of SSL management.
      if (_p["ssl_cert_path"] && sizeof(_p["ssl_cert_path"]) && Stdio.exist(_p["ssl_cert_path"])) {
	if (_p["ssl_key_path"] && sizeof(_p["ssl_key_path"]) && Stdio.exist(_p["ssl_key_path"]))
	  p->ssl(_p["ssl_cert_path"], _p["ssl_key_path"]);
	else
	  p->ssl(_p["ssl_cert_path"]);
      }
      else {
	Log.error("Can't start SSL port without an actual SSL certificate.\n");
      }
    }
    // FIXME
    // Add instances with their regexps and callbacks here.
    p->start();
    ports += ({ p });
  }
}

void stop() {
  ports->stop();
}

array status() {
  return ports->status();
}
