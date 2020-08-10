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
}
