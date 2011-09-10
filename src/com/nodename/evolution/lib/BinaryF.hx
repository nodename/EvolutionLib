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
 
class BinaryF extends BitmapData, implements Hashable
{
	public static inline var WIDTH:Int = Evolution.WIDTH;
	public static inline var HEIGHT:Int = Evolution.HEIGHT;
	private static inline var PIXELS:Int = Evolution.PIXELS;
	
	public var key:Int;
	
	public function new(fn:Float -> Float -> Float, a:BitmapData, b:BitmapData) 
	{
		super(WIDTH, HEIGHT);
		key = HashKey.next();
		
		construct(fn, a, b);
	}
	
	#if flash
	
	private inline function construct(fn:Float -> Float -> Float, a:BitmapData, b:BitmapData)
	{
		ImageMemory.loadMemory0From(a);
		ImageMemory.loadMemory1From(b);
		transformPixels(fn);
		ImageMemory.loadFromMemory(this);
	}
	
	private inline function transformPixels(fn:Float -> Float ->Float):Void
	{
		ImageMemory.domainMemory.position = 0;
		for (i in 0...PIXELS)
		{
			var rgbColor:Int = Memory.getI32(i * 4);
			var redA:Float = RGB.getRf(rgbColor);
			var greenA:Float = RGB.getGf(rgbColor);
			var blueA:Float = RGB.getBf(rgbColor);
			
			rgbColor = Memory.getI32(ImageMemory.MEMORY_FOR_ONE_IMAGE + i * 4);
			var redB:Float = RGB.getRf(rgbColor);
			var greenB:Float = RGB.getGf(rgbColor);
			var blueB:Float = RGB.getBf(rgbColor);
			
			rgbColor = RGB.setRGBf(fn(redA, redB), fn(greenA, greenB), fn(blueA, blueB));
			var color = 0xff000000 | rgbColor;
			Memory.setI32(i * 4, color);
		}
	}	
	
	#else
		
	private inline function construct(fn:Float -> Float -> Float, a:BitmapData, b:BitmapData)
	{
		for (y in 0...HEIGHT)
		{
			for (x in 0...WIDTH)
			{
				var rgbColorA:Int = a.getPixel(x, y);
				var redA:Float = RGB.getRf(rgbColorA);
				var greenA:Float = RGB.getGf(rgbColorA);
				var blueA:Float = RGB.getBf(rgbColorA);
				
				var rgbColorB:Int = b.getPixel(x, y);
				var redB:Float = RGB.getRf(rgbColorB);
				var greenB:Float = RGB.getGf(rgbColorB);
				var blueB:Float = RGB.getBf(rgbColorB);
				
				var rgbColor:Int = RGB.setRGBf(fn(redA, redB), fn(greenA, greenB), fn(blueA, blueB));
				
				var color = #if neko { rgb:rgbColor, a:0xff } #else 0xff000000 | rgbColor #end;
				setPixel32(x, y, color);
			}
		}	
	}
	
	#end
	
}