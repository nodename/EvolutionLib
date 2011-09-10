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
import flash.filters.BlurFilter;
import flash.geom.Point;
#else
import nme.Lib;
import nme.display.BitmapData;
import nme.filters.BlurFilter;
import nme.geom.Point;
#end

class Blur extends BitmapData, implements Hashable
{
	public static inline var WIDTH:Int = Evolution.WIDTH;
	public static inline var HEIGHT:Int = Evolution.HEIGHT;
	
	public var key:Int;
	
	public function new(blurX:Float=4.0, blurY:Float=4.0, quality:Int=1, source:BitmapData) 
	{
		super(WIDTH, HEIGHT);
		key = HashKey.next();
		
		var filter:BlurFilter = new BlurFilter(blurX, blurY, quality);
		this.applyFilter(source, source.rect, new Point(0, 0), filter);
	}
	
}