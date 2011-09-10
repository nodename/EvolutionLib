package com.nodename.evolution;

import format.png.Data;
import format.png.Reader;
import format.png.Tools;
import haxe.io.Bytes;

#if flash
import flash.Vector;
import flash.display.BitmapData;
import flash.utils.ByteArray;
#elseif nme
import nme.Vector;
import nme.display.BitmapData;
import nme.utils.ByteArray;
import neko.io.File;
#end

/**
 * ...
 * @author Alan Shaw
 */

class ImageSaver 
{
	public static function savePNG(image:BitmapData, fileName:String, generator:String):Void
	{
		#if flash
		ImageMemory.loadMemory0From(image);
		ImageMemory.domainMemory.position = 0;
		ImageMemory.domainMemory.length = image.height * image.width * 4;
		var data = Tools.build32BE(image.width, image.height, Bytes.ofData(ImageMemory.domainMemory));
		ImageMemory.restoreDomainMemoryLength();
		#elseif nme
		var b:Vector<Int> = image.getVector(image.rect);
		var bytes = new haxe.io.BytesOutput();
		for (i in 0...image.width * image.height)
		{
			bytes.writeInt32(cast(b[i]));
		}
		var data = Tools.build32LE(image.width, image.height, bytes.getBytes());
		#end
		
		data = insertGeneratorChunk(data, generator);
		
		#if flash
		// TODO save the file the Flash way
		#elseif nme
		var fout = File.write(fileName, true);
		new format.png.Writer(fout).write(data);
		fout.close();
		#end
	}
	
	// TODO 
	private static function insertGeneratorChunk(data:Data, generator:String):Data
	{
		var newData = new Data();
		// copy the CHeader:
		newData.add(data.pop());
		// See the following document for requirements for upper- and lower-case letters in the four-letter chunk name:
		// http://en.wikipedia.org/wiki/Portable_Network_Graphics#.22Chunks.22_within_the_file
		newData.add(CUnknown("gnTr", Bytes.ofString(generator)));
		var chunk;
		while ((chunk = data.pop()) != null)
		{
			newData.add(chunk);
		}
		return newData;
	}
	
	public static function loadPNG(imageFilePath:String):Void
	{
		#if flash
		// TODO implement for Flash
		#elseif nme
		var input = File.read(imageFilePath, true);
		var reader = new Reader(input);
		var data = reader.read();

		for (chunk in data)
		{
			switch(chunk)
			{
				case CUnknown(id, generator):
					trace(id);
					trace(generator.toString());
				default:
					
			}

		}
		
		input.close();
		#end
	}
	
}