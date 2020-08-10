package josephsmendoza.ipc;

import sys.net.UdpSocket;
import sys.net.Host;
import sys.net.Socket;

class SocketClient extends IOClient {

    public function new(socket:Socket) {
        super(socket.input,socket.output);
    }

    public static function fromURI(uri:String):SocketClient {
        return new SocketClient(URISocket.fromURI(uri));
    }

}