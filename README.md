# haxe-ipc
IPC library written in haxe for all haxe targets.  
Below is an example in haxe.
```haxe
class Server{
    public static main(){
        var sockServer=SocketServer.fromURI("tcp://localhost:12345"); // only tcp works at the moment, udp on c++
        sockServer.listen(100); // start listening for connections with a 100 length queue
        var client=sockServer.accept(); // pop a client from the queue
        sockServer.close(); // server can be closed without losing accepted clients
        var message=client.read(); // objects are deserialized in read()
        client.close(); // any further reads or writes throw EOF
        trace(message); 
    }
}
```
```haxe
class Client{
    public static main(){
        var sock=SocketClient.fromURI("tcp://localhost:12345"); // usually the uri is the same
        sock.write("your data here"); // any serializeable data can be sent without explicit declaration via reflection
        sock.close();
    }
}
```
```haxe
class Parent{
    public static main(){
        var data:Array<String>;
        var proc=new Process("child");
        var ipc=new ProcessClient(proc);
        data=ipc.read();
        ipc.close();
    }
}
```
```haxe
class Child{
    public static main(){
        var data=new Array<String>();
        // code machine go brr ...
        var ipc=new ProcessClient(null); // null indicates we are the child process
        ipc.write(data);
    }
}