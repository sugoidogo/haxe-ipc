package josephsmendoza.ipc;

import sys.FileSystem;
import sys.net.Socket;

class Test {
	static function main() {
		var server = SocketServer.fromURI("tcp://localhost:12345");
		server.listen(1);
		var client = SocketClient.fromURI("tcp://localhost:12345");
		var daemon = server.accept();
		server.close();
		client.write("pass");
		var out = new ProcessClient(null);
		out.write(daemon.read());
		daemon.close();
		out.close();
	}

	static function clean() {
		if (Sys.systemName() == "Windows") {
			Sys.command("rmdir bin /s /q");
		} else {
			Sys.command("rm -rf bin");
		}
	}

    static function await() {
        while(Sys.command("haxe",["ipc.hxml","--macro","josephsmendoza.ipc.Test.wait()"])!=0){}
    }
	static function wait() {
		while (true) {
			try {
                SocketServer.fromURI("tcp://localhost:12345").close();
                return;
			} catch (e) {}
		}
	}
}
