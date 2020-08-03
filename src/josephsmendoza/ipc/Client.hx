package josephsmendoza.ipc;

import haxe.io.Output;
import haxe.io.Input;

interface Client {
    /**
        Reads a single message from this client.
    **/
    public function read():Dynamic;
    /**
        Writes a single message to this client.
    **/
    public function write(message:Dynamic):Void;
    /**
        This method closes the IPC connection and cleans up any leftover resources.
        @throws Resource a resource or resources that couldn't be cleaned up.
    **/
    public function close():Void;
}