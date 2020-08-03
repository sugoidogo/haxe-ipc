import haxe.zip.Writer;
import sys.io.File;
import haxe.io.Path;
import haxe.zip.Entry;
import sys.FileSystem;

class Install {
	static function run() {
        FileSystem.deleteFile("ipc.zip");
		final paths = FileSystem.readDirectory(".");
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
        var out=File.write("ipc.zip");
        new Writer(out).write(entries);
        out.flush();
        out.close();
	}
}
