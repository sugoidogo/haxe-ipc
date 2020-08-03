package josephsmendoza.ipc;

import sys.net.Socket;

interface Server {
    /**
        Begin listening for connections.
        @param connections the amount of connections to queue
    **/
    public function listen(connections:Int):Void;
    /**
        Get a connected client from the queue. You must call listen() before any clients can connect.
        @returns an IPC Client
    **/
    public function accept():Client;
    /**
        This method closes the IPC Server and cleans up any leftover resources.
        @throws Resource a resource or resources that couldn't be cleaned up.
    **/
    public function close():Void;
}