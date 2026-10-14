package mobile;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.input.keyboard.FlxKey;
import mobile.TouchInput.TouchPoint;

class TouchButton extends FlxSprite
{
	public var keys:Array<FlxKey>;
	public var idleAlpha:Float = 0.7;
	public var pressedAlpha:Float = 1;
	public var padding:Float = 18;
	public var pressed(default, null):Bool = false;

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

	public function loadAnimated(atlas:FlxAtlasFrames, prefix:String, targetHeight:Int):TouchButton
	{
		frames = atlas;
		animation.add("normal", [0]);
		animation.addByPrefix("pressed", prefix, 24, false);
		animation.play("normal");
		setGraphicSize(0, targetHeight);
		updateHitbox();
		alpha = idleAlpha;
		return this;
	}

	public function startsInside(point:TouchPoint):Bool
	{
		return TouchInput.overlaps(this, point.startX, point.startY, padding);
	}

	public function setPressed(value:Bool):Void
	{
		if (value && !pressed && animation.exists("pressed"))
			animation.play("pressed", true);
		pressed = value;
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
		if (!pressed && animation.name == "pressed" && animation.finished)
			animation.play("normal");
	}
}
