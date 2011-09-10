package com.nodename.evolution;

#if flash
import flash.Memory;
import flash.Vector;
import flash.display.BitmapData;
import flash.utils.ByteArray;
import flash.utils.Endian;
#else
import nme.Memory;
import nme.Vector;
import nme.display.BitmapData;
import nme.utils.ByteArray;
import nme.utils.Endian;
#end

/**
 * ...
 * @author Alan Shaw
 */

class ImageMemory 
{
	private static inline var PIXELS:Int = Evolution.PIXELS;
	public static inline var MEMORY_FOR_ONE_IMAGE:Int = PIXELS * 4;
	
	public static var domainMemory:ByteArray;
	
	public static inline function createStorage():Void
	{
		var storage:ByteArray = new ByteArray();
		storage.endian = Endian.LITTLE_ENDIAN;
		domainMemory = storage;
		restoreDomainMemoryLength();
		Memory.select(storage);
	}
	
	public static inline function restoreDomainMemoryLength():Void
	{
		#if flash
		domainMemory.length = 2 * MEMORY_FOR_ONE_IMAGE;
		#else
		domainMemory.setLength(2 * MEMORY_FOR_ONE_IMAGE);
		#end
	}

	public static inline function loadMemory0From(image:BitmapData):Void
	{
		loadMemoryFrom(image, 0);
	}

	public static inline function loadMemory1From(image:BitmapData):Void
	{
		loadMemoryFrom(image, MEMORY_FOR_ONE_IMAGE);
	}	
	
	private static inline function loadMemoryFrom(image:BitmapData, position:Int):Void
	{
		domainMemory.position = position;
		// ref: http://webr3.org/experiments/perlin-particles/light-cloud/PerlinParticleEffects.hx
        // get all pixels and store them in a Vector (faster than ByteArray)
		#if flash var b:Vector<UInt> #else var b:Vector<Int> #end = image.getVector(image.rect);
        // pre-initialize vector before looping - makes it MUCH faster
        b.length;
        // store all pixels in fast memory for even faster translation
        for (i in 0...PIXELS) 
		{
            Memory.setI32(i * 4, b[i]);
        }
	}	
	
	public static inline function loadFromMemory(image:BitmapData):Void
	{
		domainMemory.position = 0;
		image.setPixels(image.rect, domainMemory);
	}	
	
	public function new() 
	{
		
	}
	
}