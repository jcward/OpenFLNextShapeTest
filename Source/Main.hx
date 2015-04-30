package;


import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;

import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.*;

class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
    var cont:Sprite = new Sprite();
    addChild(cont);
    cont.x = stage.stageWidth*.3;
    cont.y = stage.stageHeight*.3;

    // 1) Linestyle with alpha = 0.5 is the wrong color in Next,
    //    both the red rectangle and the green circle
    var shape1:Shape = new Shape();
		shape1.graphics.lineStyle(5, 0x00ff00, 0.5);
		shape1.graphics.beginFill(0xffff00);
		shape1.graphics.drawCircle(0,0,20);
		shape1.graphics.endFill();
		shape1.graphics.lineStyle(7, 0xff0000, 0.5);
		shape1.graphics.beginFill(0x0000ff, 0.4);
    shape1.graphics.drawRoundRect(-40,-40,80,80,13);
    cont.addChild(shape1);

    var r = shape1.getBounds(shape1);

    // 2) Gradient fill is missing in Next
    var shape2:Shape = new Shape();
		shape2.graphics.lineStyle(1, 0x000000, 1);
		begin_gradient(shape2.graphics, 80, 80, 0xff0000, 0x0000ff);
    shape2.graphics.drawRoundRect(0,0,80,80,13);
    shape2.x = r.x + r.width;
    shape2.y = r.y;
    shape2.rotation = 15;
    cont.addChild(shape2);

    r = cont.getBounds(cont);
    var bd = new BitmapData(Std.int(r.width), Std.int(r.height), true, 0x0);
    var b = new Bitmap(bd);
    var m = new Matrix();
    m.translate(-r.x, -r.y);
    b.bitmapData.draw(cont, m);
    b.alpha = 0.25;
    addChild(b);

		var scrollx = 10;
		var scrolly = 20;
		b.x = cont.x + r.x + scrollx;
		b.y = cont.y + r.y + scrolly;

    // 3) ScrollRect doesn't work in Next
		cont.scrollRect = new flash.geom.Rectangle(-scrollx,-scrolly,100,40);

    var b2 = new Bitmap(bd);
    addChild(b2);
    b2.x = b.x;
    b2.y = b.y + b.height;

    var info = "";
#if neko
    info = "neko+";
#elseif cpp
    info = "cpp+";
#elseif flash
    info = "flash+";
#elseif html5
    info = "html5+";
#else
    info = "other+";
#end

#if openfl_legacy
    info += "legacy";
#else
    info += "next";
#end

    var t = make_label("Hello Next World!\n"+info, 25, 0x0);
    addChild(t);

    t.x = b.x;
    t.y = b.y - t.height;

    // 4) t.getBounds(this) returns top-left (instead of proper
    //    text .x and .y position) in Next
    r = t.getBounds(this);
    this.graphics.lineStyle(1,0xff0000);
    this.graphics.drawRect(r.x, r.y, r.width, r.height);
	}
	
  // Gradient helper
  private static var GRADIENT_M:flash.geom.Matrix = new flash.geom.Matrix();
  public static function begin_gradient(g:openfl.display.Graphics,
                                        w:Float,
                                        h:Float,
                                        c1:UInt=0x444444,
                                        c2:UInt=0x535353,
                                        angle:Float=-1.5757963):Void
  {
    GRADIENT_M.identity();
    GRADIENT_M.createGradientBox(w, h, angle);
    g.beginGradientFill(openfl.display.GradientType.LINEAR,
                        [c1,c2],
                        [1,1],
                        [0,255],
                        GRADIENT_M);
  }

  // Font helper
  private static var fonts:haxe.ds.StringMap<Font> = new haxe.ds.StringMap<Font>();
  public static function make_label(text:String,
                                    size:Int=11,
                                    color:Int=0xaaaaaa,
                                    width:Int=-1,
                                    font_file:String="DroidSans.ttf")
  {
    if (!fonts.exists(font_file)) fonts.set(font_file, Assets.getFont("assets/"+font_file));

    var format = new TextFormat(fonts.get(font_file).fontName, size, color);
    var textField = new TextField();

    textField.defaultTextFormat = format;
    textField.embedFonts = true;
    textField.selectable = false;

    textField.text = text;
    textField.width = (width >= 0) ? width : textField.textWidth+4;
    textField.height = textField.textHeight+4;

    return textField;
  }

}