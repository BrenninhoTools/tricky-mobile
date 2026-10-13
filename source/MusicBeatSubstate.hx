package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxSubState;
#if mobile
import flixel.FlxCamera;
import flixel.util.FlxColor;
import mobile.MobileControls;
import mobile.TouchGestures;
import mobile.TouchGroup;
#end

class MusicBeatSubstate extends FlxSubState
{
	public function new()
	{
		super();
	}

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	#if mobile
	public var touchGestures:TouchGestures;
	public var backButton:TouchGroup;

	var touchCamera:FlxCamera;

	public function addTouchControls(withBack:Bool = true, withGestures:Bool = true):Void
	{
		removeTouchControls();

		if (withBack)
		{
			if (touchCamera == null)
			{
				touchCamera = new FlxCamera();
				touchCamera.bgColor = FlxColor.TRANSPARENT;
				FlxG.cameras.add(touchCamera, false);
			}

			backButton = MobileControls.createBackButton();
			backButton.cameras = [touchCamera];
			add(backButton);
		}

		if (withGestures)
		{
			touchGestures = new TouchGestures();
			if (backButton != null)
				for (button in backButton.buttons)
					touchGestures.ignored.push(button);
			add(touchGestures);
		}
	}

	public function removeTouchControls():Void
	{
		if (touchGestures != null)
		{
			remove(touchGestures, true);
			touchGestures.destroy();
			touchGestures = null;
		}

		if (backButton != null)
		{
			remove(backButton, true);
			backButton.destroy();
			backButton = null;
		}
	}

	override function destroy()
	{
		removeTouchControls();

		if (touchCamera != null)
		{
			if (FlxG.cameras.list.contains(touchCamera))
				FlxG.cameras.remove(touchCamera);
			touchCamera = null;
		}

		super.destroy();
	}
	#end

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		curBeat = Math.floor(curStep / 4);

		if (oldStep != curStep && curStep > 0)
			stepHit();


		super.update(elapsed);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition > Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}
