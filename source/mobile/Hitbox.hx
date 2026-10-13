package mobile;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.input.keyboard.FlxKey;

class Hitbox extends TouchGroup
{
	public var buttonLeft:TouchButton;
	public var buttonDown:TouchButton;
	public var buttonUp:TouchButton;
	public var buttonRight:TouchButton;

	public function new()
	{
		super();

		var atlas = Paths.getSparrowAtlas('mobile/hitbox', 'shared');
		var laneWidth:Float = FlxG.width / 4;

		buttonLeft = makeLane(atlas, 0, laneWidth, 'left', FlxKey.LEFT);
		buttonDown = makeLane(atlas, 1, laneWidth, 'down', FlxKey.DOWN);
		buttonUp = makeLane(atlas, 2, laneWidth, 'up', FlxKey.UP);
		buttonRight = makeLane(atlas, 3, laneWidth, 'right', FlxKey.RIGHT);
	}

	function makeLane(atlas:FlxAtlasFrames, index:Int, laneWidth:Float, name:String, key:FlxKey):TouchButton
	{
		var button = new TouchButton(0, 0, [key]);
		button.idleAlpha = 0;
		button.pressedAlpha = FlxG.save.data.invisibleHitbox == true ? 0 : 1;
		button.loadTile(atlas, name, 160, 360);
		button.resize(Math.ceil(laneWidth), FlxG.height);
		button.setPosition(laneWidth * index, 0);
		return addButton(button);
	}

	override function destroy()
	{
		buttonLeft = buttonDown = buttonUp = buttonRight = null;
		super.destroy();
	}
}
