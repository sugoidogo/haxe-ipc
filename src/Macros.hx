import haxe.macro.Compiler;
import josephsmendoza.ipc.SocketServer;
import haxe.zip.Writer;
import sys.io.File;
import haxe.io.Path;
import sys.FileSystem;
import haxe.zip.Entry;

class Macros {
    static function zip(paths:Array<String>) {
        final paths = new List<String>();
        paths.add("src");
        paths.add("haxelib.json");
		paths.add("extraParams.hxml");
		paths.add("LICENSE");
		paths.add("README.md");
        final entries = new List<Entry>();
		while (paths.length > 0) {
			final path = paths.pop();
			if (FileSystem.isDirectory(path)) {
				for (sub in FileSystem.readDirectory(path)) {
					paths.push(Path.join([path, sub]));
				}
			} else {
				final stat = FileSystem.stat(path);
				entries.push({
					fileTime: stat.mtime,
					fileSize: stat.size,
					fileName: path,
					dataSize: stat.size,
					data: File.getBytes(path),
					crc32: null,
					compressed: false
				});
			}
		}
		var out = File.write("ipc.zip");
		new Writer(out).write(entries);
		out.flush();
		out.close();
    }
    
    static function clean() {
		if (Sys.systemName() == "Windows") {
			Sys.command("rmdir bin /s /q");
		} else {
			Sys.command("rm -rf bin");
		}
	}

    static function await() {
        while(Sys.command("haxe",["ipc.hxml","--macro","Macros.wait()"])!=0){}
    }

	static function wait() {
		while (true) {
			try {
                SocketServer.fromURI("tcp://localhost:12345").close();
                return;
			} catch (e) {}
		}
    }
    
    static function python(path:String){
        if(Sys.command("python3",[path])!=0){
            if(Sys.command("python",[path])!=0){
                throw "python test fail";
            }
        }   
    }

    static function cs(path:String) {
        if(Sys.command("mono",[path])!=0){
            path=~/\//g.replace(path,"\\");
            if(Sys.command(path)!=0){
                throw "cs test fail";
            }
        }
    }

    static function mingw() {
        if(Sys.systemName()!="Windows"){
            return;
        }
        Compiler.define("toolchain","mingw");
    }
}
