package com.nodename.evolution.lib;

/**
 * ...
 * @author Alan Shaw
 */

import de.polygonal.ds.Hashable;
import de.polygonal.ds.HashKey;
#if flash
import flash.Lib;
import flash.display.BitmapData;
import flash.geom.Rectangle;
#else
import nme.Lib;
import nme.display.BitmapData;
import nme.geom.Rectangle;
#end
 
class Y extends BitmapData, implements Hashable
{
	public static inline var WIDTH:Int = Evolution.WIDTH;
	public static inline var HEIGHT:Int = Evolution.HEIGHT;
	
	public var key:Int;
	
	public function new() 
	{
		super(WIDTH, HEIGHT);
		key = HashKey.next();
		
		var factor:Float = 255.0 / HEIGHT;

		for (y in 0...HEIGHT)
		{
			var grayColor:Int = Std.int(Math.round(y * factor));
			var rgbColor:Int = (grayColor << 16) | (grayColor << 8) | grayColor;
			var color = #if neko { rgb:rgbColor, a:0xff } #else 0xff000000 | rgbColor #end;
			fillRect(new Rectangle(0, y, WIDTH, 1), color);
		}
	}
	
}