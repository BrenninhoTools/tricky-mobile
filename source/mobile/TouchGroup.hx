package mobile;

import flixel.group.FlxSpriteGroup;

class TouchGroup extends FlxSpriteGroup implements TouchKeySource
{
	public var buttons(default, null):Array<TouchButton> = [];
	public var blockers:Array<TouchButton> = [];

	var lastFrame:Int = -1;

	public function new()
	{
		super();
		scrollFactor.set();
		TouchKeyBridge.register(this);
	}

	public function addButton(button:TouchButton):TouchButton
	{
		buttons.push(button);
		add(button);
		return button;
	}

	public function anyPressed():Bool
	{
		for (button in buttons)
			if (button.pressed)
				return true;
		return false;
	}

	public function collectKeys(into:Array<Int>):Void
	{
		if (!exists || !alive || !visible || !active || lastFrame != TouchKeyBridge.frame)
			return;

		for (blocker in blockers)
			if (blocker != null && blocker.exists && blocker.pressed)
				return;

		for (button in buttons)
			button.collectKeys(into);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		lastFrame = TouchKeyBridge.frame;
	}

	override function destroy()
	{
		TouchKeyBridge.unregister(this);
		buttons = [];
		blockers = [];
		super.destroy();
	}
}
