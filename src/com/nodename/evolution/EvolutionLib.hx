package com.nodename.evolution;
import com.nodename.evolution.lib.BinaryI;
import com.nodename.evolution.lib.Blur;
import com.nodename.evolution.lib.BWNoise;
import com.nodename.evolution.lib.UnaryF;
import com.nodename.evolution.lib.X;
import com.nodename.evolution.lib.Y;
import com.nodename.lisp.FunctionSpec;
import com.nodename.lisp.LispEnvironment;
import com.nodename.lisp.StdLib;

#if flash
import flash.display.BitmapData;
#else
import nme.display.BitmapData;
#end

/**
 * ...
 * @author Alan Shaw
 */

class EvolutionLib
{
	public static function functions(?not:Bool, ?arity:Int):Array<String>
	{
		if (not == null)
		{
			not = false;
		}
		var result:Array<String> = new Array<String>();
		for (key in ENV.keys())
		{
			if ((arity == null) || ((ENV.get(key).inputImageCount == arity) == !not))
			{
				result.push(key);
			}
		}
		return result;
	}

	public static inline var ENV = makeEnv();
	private static inline var FUNCTION_NAMES = makeFunctionNames(ENV);
	
	private static function makeEnv():Hash<FunctionSpec>
	{
		var env = new Hash<FunctionSpec>();
		env.set("X", new FunctionSpec(makeX, 0));
		env.set("Y", new FunctionSpec(makeY, 0));
		env.set("bw-noise", new FunctionSpec(makeNoise, 0, [ new IntRange(50, 1000), new IntRange(1, 9), new FloatRange(0.1, 1) ]));
		env.set("abs", new FunctionSpec(abs, 1));
		env.set("sin", new FunctionSpec(sin, 1));
		env.set("cos", new FunctionSpec(cos, 1));
		env.set("log", new FunctionSpec(log, 1));
		env.set("inverse", new FunctionSpec(inverse, 1));
		env.set("blur", new FunctionSpec(blur, 1, [ new FloatRange(1, 4), new FloatRange(1, 4), new IntRange(1, 4) ]));
		env.set("*", new FunctionSpec(multiply, 1, [ new FloatRange(0.25, 2) ]));
		env.set("+", new FunctionSpec(add, 2));
		env.set("-", new FunctionSpec(subtract, 2));
		env.set("and", new FunctionSpec(and, 2));
		env.set("or", new FunctionSpec(or, 2));
		env.set("xor", new FunctionSpec(xor, 2));
		env.set("min", new FunctionSpec(min, 2));
		env.set("max", new FunctionSpec(max, 2));
		env.set("mod", new FunctionSpec(mod, 2));
		return env;
	}
	
	private static function makeFunctionNames(env:Hash<FunctionSpec>):Array<String>
	{
		var functionNames:Array<String> = [];
		for (key in env.keys())
		{
			functionNames.push(key);
		}
		return functionNames;
	}
	
	public inline static function randomFunctionName():String
	{
		return FUNCTION_NAMES[Math.floor(Math.random() * FUNCTION_NAMES.length)];
	}
	
	public inline static function arity(functionName:String):Int
	{
		return ENV.get(functionName).inputImageCount;
	}
	
	public inline static inline function parameterSpec(functionName:String):Array<Dynamic>
	{
		var result = ENV.get(functionName).parameterSpec;
		return result == null ? [] : result;
	}
	
	static inline function makeX():BitmapData
	{
		return new X();
	}
	
	static inline function makeY():BitmapData
	{
		return new Y();
	}
	
	static inline function makeNoise(?seed, ?octaves, ?falloff):BitmapData
	{
		return new BWNoise(seed, octaves, falloff);
	}
	
	static inline function abs(bmp:BitmapData):BitmapData
	{
		return new UnaryF(absF, bmp);
	}
	
	private inline static function absF(color:Float):Float
	{
		return Math.abs(color - 0.5) * 2;
	}
	
	static inline function sin(bmp:BitmapData):BitmapData
	{
		return new UnaryF(sinF, bmp);
	}

	private inline static function sinF(color:Float):Float
	{
		return (Math.sin(2 * Math.PI * color) + 1.0) * 0.5;
	}
	
	static inline function cos(bmp:BitmapData):BitmapData
	{
		return new UnaryF(cosF, bmp);
	}

	private inline static function cosF(color:Float):Float
	{
		return (Math.cos(2 * Math.PI * color) + 1.0) * 0.5;
	}
	
	static inline function log(bmp:BitmapData):BitmapData
	{
		return new UnaryF(logF, bmp);
	}
	
	private inline static function logF(color:Float):Float
	{
		return Math.log(color + 1.0);
	}
	
	static inline function inverse(bmp:BitmapData):BitmapData
	{
		return new UnaryF(inverseF, bmp);
	}
	
	private inline static function inverseF(color:Float):Float
	{
		return 1.0 - color;
	}
	
	static inline function and(a:BitmapData, b:BitmapData):BitmapData
	{
		return new BinaryI(andI, a, b);
	}
	
	private inline static function andI(a:Int, b:Int):Int
	{
		return a & b;
	}
	
	static inline function or(a:BitmapData, b:BitmapData):BitmapData
	{
		return new BinaryI(orI, a, b);
	}

	private inline static function orI(a:Int, b:Int):Int
	{
		return a | b;
	}
	
	static inline function xor(a:BitmapData, b:BitmapData):BitmapData
	{
		return new BinaryI(xorI, a, b);
	}	

	private inline static function xorI(a:Int, b:Int):Int
	{
		return a ^ b;
	}
	
	static inline function add(a:BitmapData, b:BitmapData):BitmapData
	{
		return new BinaryI(addI, a, b);
	}

	private inline static function addI(a:Int, b:Int):Int
	{
		return a + b;
	}
	
	static inline function subtract(a:BitmapData, b:BitmapData):BitmapData
	{
		return new BinaryI(subtractI, a, b);
	}	

	private inline static function subtractI(a:Int, b:Int):Int
	{
		return a - b;
	}

	static inline function min(a:BitmapData, b:BitmapData):BitmapData
	{
		return new BinaryI(minI, a, b);
	}
	
	private inline static function minI(a:Int, b:Int):Int
	{
		return Math.round(Math.min(a, b));
	}	
	
	static inline function max(a:BitmapData, b:BitmapData):BitmapData
	{
		return new BinaryI(maxI, a, b);
	}
	
	private inline static function maxI(a:Int, b:Int):Int
	{
		return Math.round(Math.max(a, b));
	}	
	
	static inline function mod(a:BitmapData, b:BitmapData):BitmapData
	{
		return new BinaryI(modI, a, b);
	}
	
	private inline static function modI(a:Int, b:Int):Int
	{
		return b == 0 ? a : (a % b);
	}
	
	static inline function multiply(factor:Float, bmp:BitmapData):BitmapData
	{
		return new UnaryF(function(value:Float) { return factor * value; } , bmp);
	}
	
	static inline function blur(blurX:Float, blurY:Float, quality:Int, source:BitmapData):BitmapData
	{
		return new Blur(blurX, blurY, quality, source);
	}
	

}