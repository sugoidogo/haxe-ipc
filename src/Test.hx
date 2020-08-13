import josephsmendoza.IPC;
import sys.net.Host;
import sys.net.Socket;

class Test {
    static function main() {
        var server=new Socket();
        server.bind(new Host("localhost"),12345);
        server.listen(1);
        var client=new Socket();
        client.connect(new Host("localhost"),12345);
        var parent=IPC.fromSocket(server.accept());
        var child=IPC.fromSocket(client);
        child.write("pass");
        child.close();
        var message=parent.read();
        parent.close();
        IPC.fromProcess(null).write(message);
    }
}