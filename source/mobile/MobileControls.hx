package mobile;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class MobileControls
{
	public static inline var FOUR_LANES:String = "Four Lanes";
	public static inline var ARROWS:String = "Arrows";

	public static var hitboxMode(get, set):String;

	static function get_hitboxMode():String
	{
		return FlxG.save.data.hitboxMode == ARROWS ? ARROWS : FOUR_LANES;
	}

	static function set_hitboxMode(value:String):String
	{
		FlxG.save.data.hitboxMode = value;
		FlxG.save.flush();
		return value;
	}

	public static function toggleHitboxMode():String
	{
		return hitboxMode = (hitboxMode == ARROWS ? FOUR_LANES : ARROWS);
	}

	public static function createGameplay():Hitbox
	{
		return new Hitbox();
	}

	public static function createPauseButton():TouchGroup
	{
		var group = new TouchGroup();
		var button = new TouchButton(0, 0, [FlxKey.ENTER]);
		button.loadAnimated(Paths.getSparrowAtlas('mobile/pauseButton', 'shared'), 'pause', 96);
		button.setPosition(FlxG.width - button.width - 20, 20);
		group.addButton(button);
		return group;
	}

	public static function createBackButton():TouchGroup
	{
		var group = new TouchGroup();
		var button = new TouchButton(0, 0, [FlxKey.ESCAPE, FlxKey.BACKSPACE]);
		button.loadAnimated(Paths.getSparrowAtlas('mobile/backButton', 'shared'), 'back', 110);
		button.setPosition(20, 20);
		group.addButton(button);
		return group;
	}
}
