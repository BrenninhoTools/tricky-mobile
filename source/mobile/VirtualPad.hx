package mobile;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.input.keyboard.FlxKey;

enum DPadMode
{
	NONE;
	UP_DOWN;
	LEFT_RIGHT;
	UP_LEFT_RIGHT;
	FULL;
}

enum ActionMode
{
	NONE;
	A;
	B;
	A_B;
	A_B_C;
	A_C;
}

class VirtualPad extends TouchGroup
{
	public static inline var SIZE:Int = 132;
	public static inline var MARGIN:Int = 16;

	public var buttonUp:TouchButton;
	public var buttonDown:TouchButton;
	public var buttonLeft:TouchButton;
	public var buttonRight:TouchButton;
	public var buttonA:TouchButton;
	public var buttonB:TouchButton;
	public var buttonC:TouchButton;

	var atlas:FlxAtlasFrames;
	var backAtlas:FlxAtlasFrames;

	public function new(dpad:DPadMode, action:ActionMode)
	{
		super();

		atlas = Paths.getSparrowAtlas('mobile/virtualpad', 'shared');

		var bottom:Float = FlxG.height - SIZE - MARGIN;
		var left:Float = MARGIN;
		var right:Float = FlxG.width - SIZE - MARGIN;

		switch (dpad)
		{
			case UP_DOWN:
				buttonUp = makeButton(left, bottom - SIZE, 'up', [FlxKey.UP]);
				buttonDown = makeButton(left, bottom, 'down', [FlxKey.DOWN]);
			case LEFT_RIGHT:
				buttonLeft = makeButton(left, bottom, 'left', [FlxKey.LEFT]);
				buttonRight = makeButton(left + SIZE, bottom, 'right', [FlxKey.RIGHT]);
			case UP_LEFT_RIGHT:
				buttonUp = makeButton(left + SIZE / 2, bottom - SIZE, 'up', [FlxKey.UP]);
				buttonLeft = makeButton(left, bottom, 'left', [FlxKey.LEFT]);
				buttonRight = makeButton(left + SIZE, bottom, 'right', [FlxKey.RIGHT]);
			case FULL:
				buttonUp = makeButton(left + SIZE, bottom - SIZE * 2, 'up', [FlxKey.UP]);
				buttonLeft = makeButton(left, bottom - SIZE, 'left', [FlxKey.LEFT]);
				buttonRight = makeButton(left + SIZE * 2, bottom - SIZE, 'right', [FlxKey.RIGHT]);
				buttonDown = makeButton(left + SIZE, bottom, 'down', [FlxKey.DOWN]);
			case NONE:
		}

		switch (action)
		{
			case A:
				buttonA = makeButton(right, bottom, 'a', [FlxKey.ENTER]);
			case B:
				buttonB = makeBackButton(right, bottom);
			case A_B:
				buttonA = makeButton(right, bottom, 'a', [FlxKey.ENTER]);
				buttonB = makeBackButton(right - SIZE, bottom);
			case A_B_C:
				buttonA = makeButton(right, bottom, 'a', [FlxKey.ENTER]);
				buttonB = makeBackButton(right - SIZE, bottom);
				buttonC = makeButton(right - SIZE * 2, bottom, 'c', [FlxKey.SHIFT]);
			case A_C:
				buttonA = makeButton(right, bottom, 'a', [FlxKey.ENTER]);
				buttonC = makeButton(right - SIZE, bottom, 'c', [FlxKey.SHIFT]);
			case NONE:
		}
	}

	function makeButton(x:Float, y:Float, name:String, keys:Array<FlxKey>):TouchButton
	{
		var button = new TouchButton(x, y, keys);
		button.loadTile(atlas, name, SIZE, SIZE);
		return addButton(button);
	}

	function makeBackButton(x:Float, y:Float):TouchButton
	{
		if (backAtlas == null)
			backAtlas = Paths.getSparrowAtlas('mobile/backButton', 'shared');

		var button = new TouchButton(x, y, [FlxKey.ESCAPE, FlxKey.BACKSPACE]);
		button.loadAnimated(backAtlas, 'back', SIZE);
		button.x = x + (SIZE - button.width) / 2;
		return addButton(button);
	}

	override function destroy()
	{
		buttonUp = buttonDown = buttonLeft = buttonRight = null;
		buttonA = buttonB = buttonC = null;
		atlas = backAtlas = null;
		super.destroy();
	}
}
