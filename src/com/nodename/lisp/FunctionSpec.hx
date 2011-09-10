package com.nodename.lisp;

/**
 * ...
 * @author Alan Shaw
 */

class FunctionSpec 
{
	public var fn:Dynamic; // We trust you'll put a function here
	public var inputImageCount:Int;
	public var parameterSpec:Array<Dynamic>;
	
	public function new(fn:Dynamic, inputImageCount:Int, parameterSpec:Array<Dynamic>=null) 
	{
		this.fn = fn;
		this.inputImageCount = inputImageCount;
		this.parameterSpec = parameterSpec;
	}
	
}