package com.nodename.lisp;

/**
 * ...
 * @author Alan Shaw
 */


import com.nodename.lisp.Cons;
//using com.nodename.lisp.Cons;

class LispEnvironment
{
	private var _envArray:Hash<Dynamic>;

	public function new() 
	{
		_envArray = new Hash<Dynamic>();
	}
	
	public inline function addFunction(name:String, fn:String):LispEnvironment
	{
		var functionTree:Cons = SExpressionParser.parse(fn);
		return addAtom(name, functionTree);
	}
	
	public inline function addAtom(name:String, value:Dynamic):LispEnvironment
	{
		_envArray.set(name, value);
		return this;
	}
	
	public function env():Hash<Dynamic>
	{
		return _envArray;
	}
	
}