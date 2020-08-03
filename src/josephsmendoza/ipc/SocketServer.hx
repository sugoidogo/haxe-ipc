package josephsmendoza.ipc;

import haxe.ValueException;
import sys.net.Socket;

class SocketServer implements Server {
    private final socket:Socket;
    public function new(socket:Socket) {
        this.socket=socket;
    }
    public function listen(connections:Int):Void {
        socket.listen(connections);
    }
    public function accept():SocketClient {
        return new SocketClient(socket.accept());
    }
    public static function fromURI(uri:String):SocketServer {
        return new SocketServer(URISocket.fromURI(uri,true));
    }
    public function close():Void {
        socket.close();
    }
}