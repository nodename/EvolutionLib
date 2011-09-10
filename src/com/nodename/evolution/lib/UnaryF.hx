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
import flash.Vector;
import flash.display.BitmapData;
import flash.Memory;
import flash.utils.ByteArray;
import flash.utils.Endian;
#else
import nme.Lib;
import nme.Vector;
import nme.display.BitmapData;
import nme.Memory;
import nme.utils.ByteArray;
import nme.utils.Endian;
#end

class UnaryF extends BitmapData, implements Hashable
{
	public static inline var WIDTH:Int = Evolution.WIDTH;
	public static inline var HEIGHT:Int = Evolution.HEIGHT;
	private static inline var PIXELS:Int = WIDTH * HEIGHT;

	public var key:Int;
	
	public function new(fn:Float -> Float, original:BitmapData) 
	{
		super(WIDTH, HEIGHT);
		key = HashKey.next();
		
		construct(fn, original);
	}

#if flash
	private function construct(fn:Float -> Float, original:BitmapData)
	{
		ImageMemory.loadMemory0From(original);
		transformPixels(fn);
		ImageMemory.loadFromMemory(this);
	}
	
	private inline function transformPixels(fn:Float -> Float):Void
	{
		ImageMemory.domainMemory.position = 0;
		for (i in 0...PIXELS)
		{
			var rgbColor:Int = Memory.getI32(i * 4);
			var red:Float = RGB.getRf(rgbColor);
			var green:Float = RGB.getGf(rgbColor);
			var blue:Float = RGB.getBf(rgbColor);
			rgbColor = RGB.setRGBf(fn(red), fn(green), fn(blue));
			var color = 0xff000000 | rgbColor;
			Memory.setI32(i * 4, color);
		}
	}
	
#else

	private inline function construct(fn:Float -> Float, original:BitmapData)
	{
		for (y in 0...HEIGHT)
		{
			for (x in 0...WIDTH)
			{
				var rgbColor:Int = original.getPixel(x, y);
				var red:Float = RGB.getRf(rgbColor);
				var green:Float = RGB.getGf(rgbColor);
				var blue:Float = RGB.getBf(rgbColor);
				rgbColor = RGB.setRGBf(fn(red), fn(green), fn(blue));
				
				var color = #if neko { rgb:rgbColor, a:0xff } #else 0xff000000 | rgbColor #end;
				setPixel32(x, y, color);
			}
		}		
	}
#end

}