package mobile;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.input.keyboard.FlxKey;
import haxe.Timer;
import mobile.TouchInput.TouchPoint;

class TouchButton extends FlxSprite
{
	public var keys:Array<FlxKey>;
	public var idleAlpha:Float = 0.7;
	public var pressedAlpha:Float = 1;
	public var padding:Float = 18;
	public var cooldown:Float = 0.45;
	public var pressed(default, null):Bool = false;

	var handled:Array<Int> = [];
	var readyTime:Float = 0;
	var flashTime:Float = 0;

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

	public function poll(createdFrame:Int, usable:Bool):Void
	{
		var trigger:Bool = false;
		var present:Array<Int> = [];

		for (point in TouchInput.points)
		{
			present.push(point.id);

			if (!usable || point.startFrame < createdFrame || handled.contains(point.id) || !startsInside(point))
				continue;

			handled.push(point.id);
			if (Timer.stamp() >= readyTime)
				trigger = true;
		}

		var i:Int = handled.length;
		while (i-- > 0)
			if (!present.contains(handled[i]))
				handled.splice(i, 1);

		if (trigger)
		{
			readyTime = Timer.stamp() + cooldown;
			flashTime = 0.18;
			if (animation.exists("pressed"))
				animation.play("pressed", true);
		}

		pressed = trigger;
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

		if (flashTime > 0)
			flashTime -= elapsed;

		alpha = flashTime > 0 ? pressedAlpha : idleAlpha;
		if (flashTime <= 0 && animation.name == "pressed" && animation.finished)
			animation.play("normal");
	}
}
