package josephsmendoza.ipc;

import haxe.macro.Expr.Catch;
import haxe.io.Eof;
import haxe.io.Bytes;
import haxe.Serializer;
import haxe.Unserializer;
import haxe.io.Output;
import haxe.io.Input;

/**
	IPC client for raw [Input](https://api.haxe.org/haxe/io/Input.html)
	/ [Output](https://api.haxe.org/haxe/io/Output.html).
**/
class IOClient implements Client {
	private final input:Input;
	private final output:Output;

	/**
		@param IN the [Input](https://api.haxe.org/haxe/io/Input.html)
		exclusively for sending messages
		@param OUT the [Output](https://api.haxe.org/haxe/io/Output.html)
		exclusevely for receiving messages
	**/
	public function new(IN:Input, OUT:Output) {
		input = IN;
		output = OUT;
		Serializer.USE_CACHE = true;
	}

	public function read():Dynamic {
		var message = input.readLine();
		try {
			return Unserializer.run(message);
		} catch (exception) {
			trace(message);
			trace(input.readAll());
			return null;
		}
	}

	/**
		This method calls `prepare(message)`, `write(message)`, and `flush()` on `this.output`.
		This method expects the output of `this.serialize(message)`.
		@see https://api.haxe.org/haxe/io/Output.html
		@see #serialize(message,exception)
	**/
	private function rawWrite(message:Bytes):Void {
		#if (!python && !cs)
		output.prepare(message.length);
		#end
		output.write(message);
		output.flush();
	}

	/**
		Serializes a message, appends `\n` (new line), and returns the raw [Bytes](https://api.haxe.org/haxe/io/Bytes.html)
		@param exception defaults `false`, set `true` to serialize an exception.
		@see https://api.haxe.org/haxe/Serializer.html#run
		@see https://api.haxe.org/haxe/io/Bytes.html#ofString
	**/
	private function serialize(message:Dynamic):Bytes {
		return Bytes.ofString(Serializer.run(message) + '\n');
	}

	public function write(message:Dynamic):Void {
		rawWrite(serialize(message));
	}

	/**
		calls `close()` on the input and output
		@return an annonymous structure containing:
		`exception`: the exception thrown by `close()`, and
		`resource`: the resource that threw the exception
	**/
	public function close():Void {
		input.close();
		#if (!eval && !neko)
		output.close();
		#end
	}
}
