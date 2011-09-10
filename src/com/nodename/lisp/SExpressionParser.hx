package com.nodename.lisp;


/**
 * ...
 * @author Alan Shaw
 * 
 * based on:
 * http://thingsaaronmade.com/blog/writing-an-s-expression-parser-in-ruby.html
 * for perhaps better way see:
 * http://www.rubyflow.com/items/4657
 */

private typedef StringAndLiterals = { var string:String; var literals:Array<String>; }

class SExpressionParser 
{
	private static var STRING_REPLACEMENT_TOKEN:String = "___+++STRING_LITERAL+++___";
	
	private static var converter = new Converter();
	
	public function new() 
	{
		// nothing
	}
	
	public inline static function parse(string:String):Cons
	{
		var stringAndLiterals:StringAndLiterals = extractStringLiterals(string);
		var stringTokens:Array<String> = tokenize(stringAndLiterals.string);
		stringTokens = restoreStringLiterals(stringTokens, stringAndLiterals.literals);
		return converter.convertTokens(stringTokens);
	}
	
	private static function extractStringLiterals(string:String):StringAndLiterals
	{
		var stringLiterals:Array<String> = new Array<String>();
		
		function replaceAndSave(regex:EReg):String
		{
			stringLiterals.push(regex.matched(0));
			return STRING_REPLACEMENT_TOKEN;
		}
		
		var stringLiteralPattern:EReg = ~/"([^"\\]|\\.)*"/;

		return { string: stringLiteralPattern.customReplace(string, replaceAndSave), literals: stringLiterals };
	}
	
	private inline static function tokenize(string:String):Array<String>
	{
		var newlinesPattern:EReg = ~/\n/mg;
		string = newlinesPattern.replace(string, "");
		var openParensPattern:EReg = ~/\(/g;
		string = openParensPattern.replace(string, " ( ");
		var closeParensPattern:EReg = ~/\)/g;
		string = closeParensPattern.replace(string, " ) ");
		var splitPattern:EReg = ~/[ \t\n\r]+/mg;
		var tokens:Array<String> = splitPattern.split(string);
		while (true)
		{
			if (tokens.remove("") == false)
			{
				break;
			}
		}
		return tokens;
	}
	
	private inline static function restoreStringLiterals(tokens:Array<String>, stringLiterals:Array<String>):Array<String>
	{
		var newTokens:Array<String> = new Array<String>();
		for (token in tokens)
		{
			if (token == STRING_REPLACEMENT_TOKEN)
			{
				newTokens.push(stringLiterals[0]);
				stringLiterals.shift();
			}
			else
			{
				newTokens.push(token);
			}
		}
		return newTokens;
	}
	
}

import com.nodename.lisp.Cons;
using com.nodename.lisp.Cons;
private class Converter
{
	private var tokensToConvert:Array<String>;
	private var tokenIndex:Int;
	
	public function new()
	{
		// nothing
	}
	
	public inline function convertTokens(tokens:Array<String>):Cons
	{
		var firstToken:String = tokens[0];
		var lastToken:String = tokens[tokens.length - 1];
		if (firstToken != "(" || lastToken != ")")
		{
			throw "Lisp expression must be enclosed in parens";
		}
		tokensToConvert = tokens;
		removeOuterParens();
		tokenIndex = 0;
		return doParseTree();
	}
	
	private inline function removeOuterParens():Void
	{
		tokensToConvert.pop();
		tokensToConvert.shift();
	}
	
	inline function isMatch(string:String, pattern:EReg):Bool
	{
		return pattern.match(string) && (pattern.matched(0).length == string.length);
	}
	
	inline function isSymbol(string:String):Bool
	{
		// Anything other than parentheses, single or double quote and commas
		return isMatch(string, ~/[^"',\(\)]+/);
	}
	
	inline function isIntegerLiteral(string:String):Bool
	{
		// Any number of numerals optionally preceded by a plus or minus sign
		return isMatch(string, ~/[\-\+]?[0-9]+/);
	}
	
	inline function isFloatLiteral(string:String):Bool
	{
		return isMatch(string, ~/[\-\+]?([0-9]+(e[0-9]+)|([0-9]*\.[0-9]+(e[0-9]+)?))/);
	}
	
	inline function isStringLiteral(string:String):Bool
	{
		// Any characters except double quotes (except if preceded by a backslash), surrounded by quotes
		return isMatch(string, ~/"([^"\\]|\\.)*"/);
	}
	
	inline function fetchToken():String
	{
		var token:String = tokensToConvert[tokenIndex];
		tokenIndex++;
		return token;
	}

	private function doParseTree():Cons
	{
		var tree:Cons = new Cons(null, null);
		while (true)
		{
			var token = fetchToken();
			if (token == null)
			{
				break;
			}
			if (token == "(")
			{
				tree.append(doParseTree());
			}
			else if (token == ")")
			{
				break;
			}
			else if (isFloatLiteral(token))
			{
				tree.append(Std.parseFloat(token));
			}
			else if (isIntegerLiteral(token))
			{
				tree.append(Std.parseInt(token));
			}
			else if (isStringLiteral(token))
			{
				tree.append(eval(token));
			}
			else if (isSymbol(token))
			{
				tree.append(token);
			}
			else if (token == "'")
			{
				tree.append("quote");
				token = fetchToken();
				if (token == "(")
				{
					tree.append(doParseTree());
				}
				else
				{
					tree.append(token);
				}
			}
			else
			{
				throw "Invalid character near " + token;
			}
		}
		return tree.cdr();
	}	
	
	// not complete
	private inline function eval(string:String):String
	{
		return string;
	}
}