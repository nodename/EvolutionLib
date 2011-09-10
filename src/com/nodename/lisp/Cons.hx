package com.nodename.lisp;


/**
 * ...
 * @author Alan Shaw
 */

class Cons
{
	private var _car:Dynamic;
	private var _cdr:Dynamic;
	
	private var _laste:Cons;

	public function new(head:Dynamic, tail:Dynamic)
	{
		_car = head;
		_cdr = tail;
		_laste = this;
	}

	public inline function equals(other:Dynamic):Bool
	{
		if (isAtom(other))
		{
			return false;
		}
		if (other == this)
		{
			return true;
		}
		return car() == other.car() && cdr() == other.cdr();
	}
	
	public inline static function toString(e:Dynamic):String
	{
		var string:String = lispString(e);
		// eliminate openparen-dot-space from beginning and close-paren from end
		var flattenDottedAtoms:EReg = ~/\(\. ([^\)]+)\)/g;
		string = flattenDottedAtoms.replace(string, "$1");
		return string;
	}

	private static function lispString(e:Dynamic):String
	{
		var result:String = "(";
		while (e != null)
		{
			if (isAtom(e))
			{
				result += ". " + Std.string(e);
				e = null;
			}
			else
			{
				var more:Dynamic = e.car();
				var moreString:String;
				if (isAtom(e))
				{
					moreString = Std.string(more);
				}
				else
				{
					moreString = lispString(more);
				}
				result += moreString;
				e = e.cdr();
				if (e != null)
				{
					result += " ";
				}
			}
		}
		result += ")";
		return result;
	}

	public inline static function length(e:Dynamic):Int
	{
		var result:Int = 0;
		while (e)
		{
			if (isAtom(e))
			{
				result += 1;
				e = null;
			}
			else
			{
				result += 1;
				e = e.cdr();
			}
		}
		return result;
	}
	
  public inline function append(value:Dynamic):Cons
	{
		var e = _laste;
		while (e != null)
		{
			if (! Std.is(e, Cons))
			{
				e = null;
			}
			else
			{
				_laste = e;
				e = e.cdr();
			}
		}
		_laste._cdr = cons(value, null);
		return this;
	}

	public inline static function isAtom(a:Dynamic):Bool
  {
    return ! Std.is(a, Cons);
  }

  public inline function car():Dynamic
  {
    return _car;
  }

  public inline function cdr():Dynamic
  {
    return _cdr;
  }
  
  public inline function caar():Dynamic
  {
	  return car().car();
  }
  
  public inline function cadr():Dynamic
  {
	  return cdr().car();
  }
   
  public inline function caddr():Dynamic
  {
	  return cdr().cdr().car();
  }
  
  public inline function cdar():Dynamic
  {
	  return car().cdr();
  }
  
  public inline function cadar():Dynamic
  {
	  return car().cdr().car();
  }
  
  
  public static function cons(h:Dynamic, t:Dynamic):Cons
  {
    return new Cons(h, t);
  }
}
