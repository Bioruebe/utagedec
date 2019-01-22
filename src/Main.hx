package;

import haxe.Json;
import haxe.io.Bytes;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author Bioruebe
 */
class Main {
	private static var files:Array<String>;
	
	static function main() {
		Bio.Header("utagedec", "1.0.0", "2017", "A simple decrypter for utage encrypted files (.utage)", "<input_file>|<input_dir> [<output_dir>] [-k <decrytion_key>]");
		Bio.Seperator();
		
		var args = Sys.args();
		if (args.length < 1) Bio.Error("Please specify an input path. This can either be a file or a directory containing .utage files.", 1);
		
		files = readInputFileArgument(args[0]);
		var keyArgPos = args.indexOf("-k");
		var outdir = args.length > 1 && args[1] != "-k"? Bio.PathAppendSeperator(args[1]): null;
		var encryptionKeyString = keyArgPos > 0? args[keyArgPos + 1]: "InputOriginalKey";
		var encryptionKey = Bytes.ofString(encryptionKeyString);
		Bio.Cout("Using decryption key " + encryptionKey.toHex());
		
		for (i in 0...files.length) {
			try {
				if (FileSystem.isDirectory(files[i])) continue;
				
				var fileParts = Bio.FileGetParts(files[i]);
				if (fileParts.extension != "utage"){
					Bio.Cout("Invalid extension '" + fileParts.extension + "' for file " + fileParts.name);
					continue;
				}
				
				var outFile = (outdir == null? fileParts.directory: outdir) + fileParts.name;
				if (FileSystem.exists(outFile) && !Bio.Prompt("The file " + fileParts.name + " already exists. Overwrite?", "OutOverwrite")) {
					Bio.Cout("Skipped file " + fileParts.fullName);
					continue;
				}
				
				var bytes = File.getBytes(files[i]);
				decryptXor(bytes, encryptionKey);
				
				File.saveBytes(outFile, bytes);
				Bio.Cout('${i + 1}/${files.length}\t${fileParts.name}');
			} catch (e:Dynamic) {
				Bio.Cout('${i + 1}/${files.length}\tFailed to read file', Bio.LogSeverity.ERROR);
			}
		}
		
		Bio.Cout("All OK");
	}
	
	private static function readInputFileArgument(file:String){
		if (!FileSystem.exists(file)) {
			Bio.Error("The input file " + file + " does not exist.", 1);
			return null;
		}
		else if (FileSystem.isDirectory(file)) {
			return FileSystem.readDirectory(file).map(function(s:String) {
				return Bio.PathAppendSeperator(file) + s;
			});
		}
		else {
			return [file];
		}
	}
	
	private static function decryptXor(data:Bytes, key:Bytes) {
		if (key == null || key.length <= 0) return;
		var keyLength = key.length;
		for (i in 0...data.length) {
			var k = key.get(i % keyLength);
			var d = data.get(i);
			if (d == 0 || d == k) continue;
			data.set(i, d ^ k);
			//trace('$d ^ $k = ${data.get(i)}');
		}
	}
}