package com.nodename.lisp;


/**
 * ...
 * @author Alan Shaw
 * based on
 * # http://onestepback.org/index.cgi/Tech/Ruby/LispInRuby.red
 */

import com.nodename.lisp.Cons;
using com.nodename.lisp.Cons;
 
class LispInterpreter
{
  // Here is the guts of the Lisp interpreter.  Apply and eval work
  // together to interpret the S-expression.  These definitions are taken
  // directly from page 13 of the Lisp 1.5 Programmer's Manual.
    
  public static function eval(e:Dynamic, environment:Hash<Dynamic>):Dynamic
  {
    if (e.isAtom())
	{
		if (Type.getClass(e) == String)
		{
			return assoc(e, environment);
		}
		else
		{
			// it's a literal number
			return e;
		}
	}
	
	var expr:Cons = cast(e, Cons);
	
    if ((expr.car().isAtom()))
	{
      if (expr.car() == "quote")
	  {
        return expr.cadr();
	  }
      else if (expr.car() == "cond")
	  {
        return evaluateCondition(expr.cdr(), environment);
	  }
      else
	  {
        return apply(expr.car(), evaluateList(expr.cdr(), environment), environment);
      }
	}
    else
	{
      return apply(expr.car(), evaluateList(expr.cdr(), environment), environment);
    }
  }
  
  static function apply(fn:Dynamic, x:Cons, environment:Hash<Dynamic>):Dynamic
  {
	if (fn == null)
	{
		throw "apply: function is null!";
	}
    if (fn.isAtom())
	{
		if (Reflect.isFunction(fn))
		{
			return applyNativeFunction(fn, x, environment);
		}
		else
		{
		  switch (fn)
		  {
		  case "car":
			  return x.caar();
		  case "cdr":
			  return x.cdar();
		  case "cons":
			  return new Cons(x.car(), x.cadr());
		  case "atom":
			  return x.car().isAtom();
		  case "eq":
			 return  x.car() == x.cadr();
		  default:
			return apply(eval(fn, environment), x, environment);
		  }
		}
	}
	
	var func:Cons = cast(fn, Cons);
    if (func.car() == "lambda")
	{
      return eval(func.caddr(), pairlis(func.cadr(), x, environment));
	}
    else if (func.car() == "label")
	{
		// should really create a new environment rather than modifying this one:
		environment.set(func.cadr(), func.caddr());
		return apply(func.caddr(), x, environment);
	}
	else
	{
		return null;
	}
  }
  
  private inline static function applyNativeFunction(fn:Dynamic, x:Cons, environment:Hash<Dynamic>):Dynamic
  {
	  var args:Array<Dynamic> = evalArgs(x);
	  return Reflect.callMethod(null, fn, args);
  }
  
  private inline static function evalArgs(x:Cons):Array<Dynamic>
  {
	  var args:Array<Dynamic> = [];
	  var arg:Dynamic;
	  while (x != null)
	  {
		  arg = x.car();
		  if (Reflect.isFunction(arg))
		  {
			  arg = Reflect.callMethod(null, arg, []);
		  }
		  args.push(arg);
		  x = x.cdr();
	  }
	  return args;
  }

  // And now some utility functions used by apply and eval.  These are
  // also given in the Lisp 1.5 Programmer's Manual.

  public static function evaluateCondition(c:Cons, environment:Hash<Dynamic>)
  {
    if (eval(c.caar(), environment))
	{
      return eval(c.cadar(), environment);
	}
    else
	{
      return evaluateCondition(c.cdr(), environment);
    }
  }

  static function evaluateList(m:Cons, environment:Hash<Dynamic>):Cons
  {
    if (m == null)
	{
      return null;
	}
    else
	{
      return new Cons(eval(m.car(), environment), evaluateList(m.cdr(), environment));
    }
  }

  static function assoc(a:Dynamic, environment:Hash<Dynamic>):Dynamic
  {
    if (environment == null || environment.exists(a) == false)
	{
      throw Std.string(a) + " not bound";
	}
	else
	{
		var value = environment.get(a);
		if (Std.is(value, FunctionSpec))
		{
			return cast(value, FunctionSpec).fn;
		}
		return value;
	}

  }
  
  private inline static function equalItems(a:Dynamic, b:Dynamic):Bool
  {
	  if (Reflect.isFunction(a) && Reflect.isFunction(b))
	  {
		  return Reflect.compareMethods(a, b);
	  }
	  else
	  {
		  return a == b;
	  }
  }
  
  static inline function pairlis(vars:Cons, vals:Cons, environment:Hash<Dynamic>):Hash<Dynamic>
  {
    while (vars != null && vals != null)
	{
		// should really return a new environment rather than modifying environment
		environment.set(vars.car(), vals.car());
		vars = vars.cdr();
		vals = vals.cdr();
    }
    return environment;
  }	

}




