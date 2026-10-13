package mobile;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;

class TouchGestures extends FlxBasic implements TouchKeySource
{
	public var swipeDistance:Float = 70;
	public var tapDistance:Float = 30;
	public var tapDuration:Float = 0.4;
	public var tapKeys:Array<FlxKey> = [FlxKey.ENTER];
	public var horizontal:Bool = true;
	public var vertical:Bool = true;
	public var ignored:Array<FlxObject> = [];

	var pulse:Array<Int> = [];
	var lastFrame:Int = -1;

	public function new()
	{
		super();
		TouchKeyBridge.register(this);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		pulse = [];
		lastFrame = TouchKeyBridge.frame;

		for (swipe in FlxG.swipes)
		{
			if (swipe.ID < 0 || isIgnored(swipe.startPosition))
				continue;

			var dx:Float = swipe.endPosition.x - swipe.startPosition.x;
			var dy:Float = swipe.endPosition.y - swipe.startPosition.y;

			if (swipe.distance >= swipeDistance)
			{
				if (Math.abs(dx) >= Math.abs(dy))
				{
					if (horizontal)
						push(dx > 0 ? FlxKey.RIGHT : FlxKey.LEFT);
				}
				else if (vertical)
					push(dy > 0 ? FlxKey.DOWN : FlxKey.UP);
			}
			else if (swipe.distance <= tapDistance && swipe.duration <= tapDuration)
			{
				for (key in tapKeys)
					push(key);
			}
		}
	}

	function push(key:FlxKey):Void
	{
		if (!pulse.contains(key))
			pulse.push(key);
	}

	function isIgnored(point:FlxPoint):Bool
	{
		for (object in ignored)
			if (object != null && object.exists && object.visible && object.overlapsPoint(point, true, object.camera))
				return true;
		return false;
	}

	public function collectKeys(into:Array<Int>):Void
	{
		if (!exists || !alive || !active || lastFrame != TouchKeyBridge.frame)
			return;

		for (key in pulse)
			if (!into.contains(key))
				into.push(key);
	}

	override function destroy()
	{
		TouchKeyBridge.unregister(this);
		ignored = [];
		pulse = [];
		super.destroy();
	}
}
