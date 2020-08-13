package josephsmendoza;

import haxe.io.Bytes;
import haxe.io.Output;
import haxe.io.Input;
import haxe.Serializer;
import haxe.Unserializer;
#if sys
import sys.io.Process;
import sys.net.Socket;
#end

class IPC {
	/**
		This function does the raw write to the client.
		@param message the serialized data to be written
	**/
	private dynamic function rawWrite(message:String) {
		throw "unimplemented";
	}

	/**
		This function does the raw read from the client.
		@returns the serialized data that was read
	**/
	private dynamic function rawRead():String {
		throw "unimplemented";
	}

	/**
		This function closes the IPC connection.  
		Further read/write operations result in errors.
	**/
	public dynamic function close() {
		throw "unimplemented";
	}

	/**
		Creates a new IPC client with the specified transport methods.  
		This is for using transports unknown to the library.  
		The string argument/return is serialized data.  
		If you're using this, you should submit a bug report!
	**/
	public function new(rawRead, rawWrite, close) {
		this.rawRead = rawRead;
		this.rawWrite = rawWrite;
		this.close = close;
		Serializer.USE_CACHE = true;
	}

	/**
		This function reads and unserializes a message.  
		This will block on blocking transports (stdio).
		@return the data that was read
	**/
	public function read() {
		return Unserializer.run(rawRead());
	}

	/**
		This function serializes and writes a message.  
		This will block on blocking transports (stdio).
		@param message the data to be written
	**/
	public function write(message) {
		rawWrite(Serializer.run(message) + '\n');
	}

	/**
		This function creates an IPC client from any Input and Output.  
		@param input the Input for reading messages
		@param output the Output for writing messages
	**/
	public static function fromIO(input:Input, output:Output) {
		return new IPC(function read() {
			return input.readLine();
		}, function write(message) {
			var bytes = Bytes.ofString(message);
			try {
				output.prepare(bytes.length);
			} catch (e) {}
			output.write(bytes);
			output.flush();
		}, function close() {
			input.close();
			try {
				output.close();
			} catch (e) {}
		});
	}

	#if sys
	/**
		This function creates an IPC client from a connected Socket.  
		@param socket a connected socket
	**/
	public static function fromSocket(socket:Socket) {
		var client = fromIO(socket.input, socket.output);
		client.close = function close() {
			socket.close();
		}
		return client;
	}

	/**
		This function creates an IPC client from stdio streams.
		@param process the child process, use `null` for this process.
	**/
	public static function fromProcess(process:Process) {
		if (process == null) {
			return fromIO(Sys.stdin(), Sys.stdout());
		}
		return fromIO(process.stdout, process.stdin);
	}
	#end
}
