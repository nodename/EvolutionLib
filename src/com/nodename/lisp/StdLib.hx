package com.nodename.lisp;

import com.nodename.lisp.Cons;

#if flash
import flash.display.BitmapData;
#else
import nme.display.BitmapData;
#end

/**
 * ...
 * @author Alan Shaw
 */

using com.nodename.lisp.Cons;
class StdLib
{
	public inline static function random(n:Dynamic):Dynamic
	{
		if (Std.is(n, Int))
		{
			return Math.floor(Math.random() * n);
		}
		else if (Std.is(n, Float))
		{
			return Math.random() * (n - 1);
		}
		else if (Std.is(n, IntRange))
		{
			n = cast(n, IntRange);
			return Math.floor(n.first + Math.random() * (n.lastPlusOne - n.first));
		}
		else if (Std.is(n, FloatRange))
		{
			n = cast(n, FloatRange);
			return n.first + Math.random() * (n.last - n.first);
		}
		else
		{
			throw "random requires a number arg";
		}
	}
	
	public inline static function nth(n:Int, list:Cons):Dynamic
	{
		var result = list;
		while (n-- > 0)
		{
			result = result.cdr();
		}
		return result.car();
	}
	
	public static inline function oneOf(list:Cons):Dynamic
	{
		return StdLib.nth(StdLib.random(list.length()), list);
	}
}

class IntRange
{
	public var first(default, null):Int;
	public var lastPlusOne(default, null):Int;
	
	public function new(first:Int, lastPlusOne:Int)
	{
		this.first = first;
		this.lastPlusOne = lastPlusOne;
	}
}

class FloatRange
{
	public var first(default, null):Float;
	public var last(default, null):Float;
	
	public function new(first:Float, last:Float)
	{
		this.first = first;
		this.last = last;
	}
}