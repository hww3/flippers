#!/usr/local/bin/pike -Mlib -DLOCALE_DEBUG

#define DOJO_RELEASE "0.4.3"

inherit Fins.AdminTools.FinServe;

import Fins;
import Tools.Logging;

void print_help() {
  werror("Help: flippers [-p portnum|--port=portnum|--hilfe] [-d]  appname configname\n");
}

int main(int argc, array argv) {
  // Test for and install Dojo.
  if (!Stdio.exist(combine_path(getcwd(), sprintf("static/js/dojo-%s-kitchen_sink", DOJO_RELEASE)))) {
    write("You don't have Dojo %s installed, downloading...\n", DOJO_RELEASE);
    mixed q = Protocols.HTTP.get_url(sprintf("http://download.dojotoolkit.org/release-%s/dojo-%s-kitchen_sink.tar.gz", DOJO_RELEASE, DOJO_RELEASE));
    if (q && q->ok) {
      Stdio.write_file(combine_path(getcwd(), sprintf("static/js/dojo-%s-kitchen_sink.tar.gz", DOJO_RELEASE)), q->data());
      string oldcwd = getcwd();
      cd(combine_path(getcwd(), "static/js"));
      Process.popen(sprintf("tar zxvf dojo-%s-kitchen_sink.tar.gz", DOJO_RELEASE));
      System.symlink(sprintf("dojo-%s-kitchen_sink", DOJO_RELEASE), "dojo");
      cd(oldcwd);
    }
  }
  argv += ({"-a", ".", "-c", "flippers", "--no-virtual"});
  return ::main(sizeof(argv), argv);
}
