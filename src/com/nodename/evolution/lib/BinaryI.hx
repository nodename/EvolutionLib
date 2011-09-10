package com.nodename.evolution.lib;

/**
 * ...
 * @author Alan Shaw
 */

import de.polygonal.ds.Hashable;
import de.polygonal.ds.HashKey;
import de.polygonal.gl.color.RGB;
#if flash
import flash.Lib;
import flash.Memory;
import flash.display.BitmapData;
#else
import nme.Lib;
import nme.Memory;
import nme.display.BitmapData;
#end
 
class BinaryI extends BitmapData, implements Hashable
{
	public static inline var WIDTH:Int = Evolution.WIDTH;
	public static inline var HEIGHT:Int = Evolution.HEIGHT;
	private static inline var PIXELS:Int = Evolution.PIXELS;
	
	public var key:Int;
	
	public function new(fn:Int -> Int -> Int, a:BitmapData, b:BitmapData) 
	{
		super(WIDTH, HEIGHT);
		key = HashKey.next();
		
		construct(fn, a, b);
	}
	
	// TODO the Memory implementation gives wrong results but the similar one in BinaryF is fine. ???
	#if false
	
	private inline function construct(fn:Int -> Int -> Int, a:BitmapData, b:BitmapData)
	{
		ImageMemory.loadMemory0From(a);
		ImageMemory.loadMemory1From(b);
		transformPixels(fn);
		ImageMemory.loadFromMemory(this);
	}
	
	private inline function transformPixels(fn:Int -> Int ->Int):Void
	{
		ImageMemory.domainMemory.position = 0;
		for (i in 0...PIXELS)
		{
			var rgbColorA:Int = Memory.getI32(i * 4);
			var redA:Int = RGB.getR(rgbColorA);
			var greenA:Int = RGB.getG(rgbColorA);
			var blueA:Int = RGB.getB(rgbColorA);
			
			var rgbColorB:Int = Memory.getI32(ImageMemory.MEMORY_FOR_ONE_IMAGE + i * 4);
			var redB:Int = RGB.getR(rgbColorB);
			var greenB:Int = RGB.getG(rgbColorB);
			var blueB:Int = RGB.getB(rgbColorB);
			
			var rgbColor:Int = RGB.setRGBi(fn(redA, redB), fn(greenA, greenB), fn(blueA, blueB));
			var color = 0xff000000 | rgbColor;
			Memory.setI32(i * 4, color);
		}
	}	
	
	#else
				
	private inline function construct(fn:Int -> Int -> Int, a:BitmapData, b:BitmapData):Void
	{
		for (y in 0...HEIGHT)
		{
			for (x in 0...WIDTH)
			{
				var rgbColorA:Int = a.getPixel(x, y);
				var redA:Int = RGB.getR(rgbColorA);
				var greenA:Int = RGB.getG(rgbColorA);
				var blueA:Int = RGB.getB(rgbColorA);
				
				var rgbColorB:Int = b.getPixel(x, y);
				var redB:Int = RGB.getR(rgbColorB);
				var greenB:Int = RGB.getG(rgbColorB);
				var blueB:Int = RGB.getB(rgbColorB);
				
				var rgbColor:Int = RGB.setRGBi(fn(redA, redB), fn(greenA, greenB), fn(blueA, blueB));
				
				var color = #if neko { rgb:rgbColor, a:0xff } #else 0xff000000 | rgbColor #end;
				setPixel32(x, y, color);
			}
		}	
	}
	
	#end
	
}