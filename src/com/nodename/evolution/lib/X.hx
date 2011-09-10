package com.nodename.evolution.lib;

/**
 * ...
 * @author Alan Shaw
 */

import de.polygonal.ds.Hashable;
import de.polygonal.ds.HashKey;

#if flash
import flash.Vector;
import flash.Lib;
import flash.display.BitmapData;
import flash.geom.Rectangle;
#else
import nme.Lib;
import nme.display.BitmapData;
import nme.geom.Rectangle;
#end
 
class X extends BitmapData, implements Hashable
{
	public static inline var WIDTH:Int = Evolution.WIDTH;
	public static inline var HEIGHT:Int = Evolution.HEIGHT;
	
	public var key:Int;
	
	public function new() 
	{
		super(WIDTH, HEIGHT);
		key = HashKey.next();
		
		var factor:Float = 255.0 / WIDTH;

		for (x in 0...WIDTH)
		{
			var grayColor:Int = Std.int(Math.round(x * factor));
			var rgbColor:Int = (grayColor << 16) | (grayColor << 8) | grayColor;
			var color = #if neko { rgb:rgbColor, a:0xff } #else 0xff000000 | rgbColor #end;
			fillRect(new Rectangle(x, 0, 1, HEIGHT), color);
		}
	}
	
}