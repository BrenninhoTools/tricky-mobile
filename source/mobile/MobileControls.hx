package mobile;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import mobile.VirtualPad.ActionMode;
import mobile.VirtualPad.DPadMode;

class MobileControls
{
	public static inline var HITBOX:String = "Hitbox";
	public static inline var PAD:String = "Virtual Pad";

	public static var mode(get, set):String;

	static function get_mode():String
	{
		if (FlxG.save.data.mobileControls != PAD)
			return HITBOX;
		return PAD;
	}

	static function set_mode(value:String):String
	{
		FlxG.save.data.mobileControls = value;
		FlxG.save.flush();
		return value;
	}

	public static function toggleMode():String
	{
		return mode = (mode == HITBOX ? PAD : HITBOX);
	}

	public static function createGameplay():TouchGroup
	{
		if (mode == PAD)
			return new VirtualPad(DPadMode.FULL, ActionMode.NONE);
		return new Hitbox();
	}

	public static function createPauseButton():TouchGroup
	{
		var group = new TouchGroup();
		var size:Int = 96;
		var button = new TouchButton(0, 0, [FlxKey.ENTER]);
		button.loadAnimated(Paths.getSparrowAtlas('mobile/pauseButton', 'shared'), 'pause', size);
		button.setPosition(FlxG.width - button.width - 20, 20);
		group.addButton(button);
		return group;
	}
}
