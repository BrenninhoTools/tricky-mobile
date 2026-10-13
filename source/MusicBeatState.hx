package;

import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.Lib;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
#if mobile
import flixel.FlxCamera;
import mobile.MobileControls;
import mobile.TouchGestures;
import mobile.TouchGroup;
#end

class MusicBeatState extends FlxUIState
{
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
	public var mobileControls:TouchGroup;
	public var pauseButton:TouchGroup;

	var touchCamera:FlxCamera;

	public function getTouchCamera():FlxCamera
	{
		if (touchCamera == null || !FlxG.cameras.list.contains(touchCamera))
		{
			touchCamera = new FlxCamera();
			touchCamera.bgColor = FlxColor.TRANSPARENT;
			FlxG.cameras.add(touchCamera, false);
		}
		return touchCamera;
	}

	public function addTouchControls(withBack:Bool = true, withGestures:Bool = true):Void
	{
		removeTouchControls();

		if (withBack)
		{
			backButton = MobileControls.createBackButton();
			backButton.cameras = [getTouchCamera()];
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

	public function addMobileControls(withPause:Bool = true):Void
	{
		removeMobileControls();

		mobileControls = MobileControls.createGameplay();
		mobileControls.cameras = [getTouchCamera()];
		add(mobileControls);

		if (withPause)
		{
			pauseButton = MobileControls.createPauseButton();
			pauseButton.cameras = [getTouchCamera()];
			add(pauseButton);
			mobileControls.blockers = pauseButton.buttons;
		}
	}

	public function removeMobileControls():Void
	{
		if (mobileControls != null)
		{
			remove(mobileControls, true);
			mobileControls.destroy();
			mobileControls = null;
		}

		if (pauseButton != null)
		{
			remove(pauseButton, true);
			pauseButton.destroy();
			pauseButton = null;
		}
	}
	#end

	override function create()
	{
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();
	}


	var array:Array<FlxColor> = [
		FlxColor.fromRGB(148, 0, 211),
		FlxColor.fromRGB(75, 0, 130),
		FlxColor.fromRGB(0, 0, 255),
		FlxColor.fromRGB(0, 255, 0),
		FlxColor.fromRGB(255, 255, 0),
		FlxColor.fromRGB(255, 127, 0),
		FlxColor.fromRGB(255, 0 , 0)
	];

	var skippedFrames = 0;

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		if (FlxG.save.data.fpsRain && skippedFrames >= 6)
			{
				if (currentColor >= array.length)
					currentColor = 0;
				(cast (Lib.current.getChildAt(0), Main)).changeFPSColor(array[currentColor]);
				currentColor++;
				skippedFrames = 0;
			}
			else
				skippedFrames++;

		if ((cast (Lib.current.getChildAt(0), Main)).getFPSCap != FlxG.save.data.fpsCap && FlxG.save.data.fpsCap <= 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		super.update(elapsed);

		#if mobile
		FlxG.mouse.visible = false;
		#end
	}

	private function updateBeat():Void
	{
		lastBeat = curStep;
		curBeat = Math.floor(curStep / 4);
	}

	public static var currentColor = 0;

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
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