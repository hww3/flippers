static int _port;
static string _addr;
static int _ssl;
static string _cert;
static string _key;

void start() {
}

void stop() {
}

.Status status() {
  return .Status();
}

int port(void|int __port) {
  if (port) {
    _port = __port;
  }
  return _port;
}

string address(void|string __addr) {
  if (address && stringp(address) && sizeof(address)) {
    _addr = __addr;
  }
}

int ssl(string __cert, void|string __key) {
  _ssl = 1;
}
