package com.nodename.evolution.lib;

/**
 * ...
 * @author Alan Shaw
 */

 
import com.nodename.evolution.lib.noise.OptimizedPerlin;
import de.polygonal.ds.Hashable;
import de.polygonal.ds.HashKey;

#if flash
import flash.display.BitmapData;
#else
import nme.display.BitmapData;
#end

class BWNoise extends BitmapData, implements Hashable
{
	public static inline var WIDTH:Int = Evolution.WIDTH;
	public static inline var HEIGHT:Int = Evolution.HEIGHT;
	
	public var key:Int;
	
	public function new(?seed:Int, ?octaves:Int, ?falloff:Float) 
	{
		super(WIDTH, HEIGHT);
		key = HashKey.next();
		
		(new OptimizedPerlin(seed, octaves, falloff)).fill(this, 0, 0, 0);
	}
	
}