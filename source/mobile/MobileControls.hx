package mobile;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class MobileControls
{
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
