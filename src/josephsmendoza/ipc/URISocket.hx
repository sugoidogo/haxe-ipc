package josephsmendoza.ipc;

import sys.net.UdpSocket;
import sys.net.Host;
import sys.net.Socket;

class URISocket extends Socket {
	public static function fromURI(uri:String, bind = false) {
		final regex = ~/^(?:([\w.+]+?)(?::))(?:[\\\/][\\\/](?:(.+?)(?::(.+?))?(?:@))?(?:\[)?([\w:.]+?)?(?:\])?(?::(\d+))?)?([\\\/][\w\\\/]*?)?(?:\?(.+?))?(?:#(.+))?$/;
		if (!regex.match(uri)) {
			throw "invalid uri";
		}
		final host = new Host(regex.matched(4));
		final port = Std.parseInt(regex.matched(5));
		var socket:Socket;
		switch (regex.matched(1)) {
			case "tcp":
                socket = new Socket();
            #if (!cpp && !neko)
			case "udp":
                socket = new UdpSocket();
            #end
			default:
				throw "unsupported protocol";
		}
		if (bind) {
			socket.bind(host, port);
		} else {
			socket.connect(host, port);
		}
		return socket;
	}
}
