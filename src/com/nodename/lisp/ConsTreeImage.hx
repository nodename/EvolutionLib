package com.nodename.lisp;

#if flash
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
#else
import nme.display.Sprite;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;
#end

/**
 * ...
 * @author Alan Shaw
 */

using com.nodename.lisp.Cons; 
class ConsTreeImage extends Sprite
{
	private static inline var RADIUS:Float = 3;
	private static inline var YSTEP:Float = 60;
	private static inline var PAD:Float = 40;
	private static inline var COLOR:Int = 0; // xffffff;
	private static inline var FONTSIZE:Float = 18;
	
	public var treewidth(default, null):Float;
	
	private var _tf:TextField;
	private var _carImage:ConsTreeImage;
	private var _cdrImage:ConsTreeImage;
	
	public function dispose():Void
	{
		if (_tf != null)
		{
			removeChild(_tf);
			_tf = null;
		}
		if (_carImage != null)
		{
			_carImage.dispose();
			removeChild(_carImage);
			_carImage = null;
		}
		if (_cdrImage != null)
		{
			_cdrImage.dispose();
			removeChild(_cdrImage);
			_cdrImage = null;
		}
	}
	
	public function new(e:Dynamic) 
	{
		super();
		_tf = null;
		_carImage = _cdrImage = null;
		graphics.lineStyle(1, COLOR, 1);
		treewidth = draw(e, 0, 0);
	}
	
	private inline function draw(e:Dynamic, x:Float, y:Float):Float
	{
		var treewidth:Float;
		if (e == null)
		{
			drawDot(x, y);
			treewidth = PAD;
		}
		else if (e.isAtom())
		{
			_tf = drawText(x, y, e);
			addChild(_tf);
			treewidth = _tf.textWidth + PAD;
		}
		else
		{
			var cons = cast(e, Cons);
			drawDot(x, y);
			
			_carImage = new ConsTreeImage(cons.car());
			_cdrImage = new ConsTreeImage(cons.cdr());
			
			graphics.moveTo(x, y);
			var carXOffset = (_carImage._cdrImage == null ? _carImage.treewidth : _carImage._cdrImage.treewidth)/2;
			var carX = x - carXOffset;
			var carY = y + YSTEP;
			graphics.lineTo(carX, carY);
			_carImage.x = carX;
			_carImage.y = carY;
			addChild(_carImage);
			
			graphics.moveTo(x, y);
			var cdrXOffset = (_cdrImage._carImage == null ? _cdrImage.treewidth : _cdrImage._carImage.treewidth)/2;
			var cdrX = x + cdrXOffset;
			var cdrY = y + YSTEP;
			graphics.lineTo(cdrX, cdrY);
			_cdrImage.x = cdrX;
			_cdrImage.y = cdrY;
			addChild(_cdrImage);
			treewidth = _carImage.treewidth + _cdrImage.treewidth + PAD;
		}
		return treewidth;
	}
	
	private inline function drawDot(x:Float, y:Float):Void
	{
		graphics.beginFill(COLOR);
		graphics.drawCircle(x, y, RADIUS);
		graphics.endFill();
	}
	
	private inline function drawText(x:Float, y:Float, e:Dynamic):TextField
	{
		var tf = new TextField();
		tf.embedFonts = true;
		var tformat = new TextFormat("Courier New Bold", FONTSIZE, COLOR);
		tf.defaultTextFormat = tformat;
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.text = Std.string(e);
		tf.x = x - tf.textWidth/2;
		tf.y = y;
		
		return tf;
	}
	
}