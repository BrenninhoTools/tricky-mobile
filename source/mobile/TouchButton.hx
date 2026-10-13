package mobile;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxTileFrames;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;

class TouchButton extends FlxButton
{
	public var keys:Array<FlxKey>;
	public var idleAlpha:Float = 0.7;
	public var pressedAlpha:Float = 1;

	public function new(x:Float, y:Float, keys:Array<FlxKey>)
	{
		super(x, y);
		this.keys = keys;
		solid = false;
		immovable = true;
		moves = false;
		antialiasing = true;
		scrollFactor.set();
	}

	public function loadTile(atlas:FlxAtlasFrames, name:String, tileWidth:Int, tileHeight:Int):TouchButton
	{
		var point = FlxPoint.get(tileWidth, tileHeight);
		frames = FlxTileFrames.fromFrame(atlas.getByName(name), point);
		point.put();
		resetSizeFromFrame();
		updateHitbox();
		alpha = idleAlpha;
		return this;
	}

	public function loadAnimated(atlas:FlxAtlasFrames, prefix:String, targetHeight:Int):TouchButton
	{
		frames = atlas;
		animation.add("normal", [0]);
		animation.add("highlight", [0]);
		animation.addByPrefix("pressed", prefix, 24, false);
		animation.play("normal");
		setGraphicSize(0, targetHeight);
		updateHitbox();
		alpha = idleAlpha;
		return this;
	}

	public function resize(width:Float, height:Float):TouchButton
	{
		setGraphicSize(Std.int(width), Std.int(height));
		updateHitbox();
		return this;
	}

	public function collectKeys(into:Array<Int>):Void
	{
		if (!exists || !alive || !visible || !pressed)
			return;

		for (key in keys)
			if (!into.contains(key))
				into.push(key);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		alpha = pressed ? pressedAlpha : idleAlpha;
	}
}
