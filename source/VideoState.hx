package;

import flixel.FlxState;
import flixel.FlxG;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.sound.FlxSound;
import openfl.utils.Assets;
import openfl.utils.AssetType;

import openfl.Lib;

#if mobile
import hxvlc.openfl.Video;
#end

using StringTools;

class VideoState extends MusicBeatState
{
	public var leSource:String = "";
	public var transClass:FlxState;
	public var txt:FlxText;
	public var fuckingVolume:Float = 1;
	public var notDone:Bool = true;
	public var vidSound:FlxSound;
	public var useSound:Bool = false;
	public var soundMultiplier:Float = 1;
	public var prevSoundMultiplier:Float = 1;
	public var videoFrames:Int = 0;
	public var defaultText:String = "";
	public var doShit:Bool = false;
	public var pauseText:String = "Press P To Pause/Unpause";

	public function new(source:String, toTrans:FlxState)
	{
		super();
		
		leSource = source;
		transClass = toTrans;
	}
	
	override function create()
	{
		super.create();

		#if mobile
		startMobileVideo();
		return;
		#end

		FlxG.autoPause = false;
		doShit = false;
		
		if (GlobalVideo.isWebm)
		{
		videoFrames = Std.parseInt(Assets.getText(leSource.replace(".webm", ".txt")));
		}
		
		fuckingVolume = FlxG.sound.music.volume;
		FlxG.sound.music.volume = 0;
		var isHTML:Bool = false;
		#if web
		isHTML = true;
		#end
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		txt = new FlxText(0, 0, FlxG.width,
			defaultText,
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);

		if (GlobalVideo.isWebm)
		{
			if (Assets.exists(leSource.replace(".webm", ".ogg"), MUSIC) || Assets.exists(leSource.replace(".webm", ".ogg"), SOUND))
			{
				useSound = true;
				vidSound = FlxG.sound.play(leSource.replace(".webm", ".ogg"));
			}
		}

		GlobalVideo.get().source(leSource);
		GlobalVideo.get().clearPause();
		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().updatePlayer();
		}
		GlobalVideo.get().show();
		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().restart();
		} else {
			GlobalVideo.get().play();
		}
		
		/*if (useSound)
		{*/
			//vidSound = FlxG.sound.play(leSource.replace(".webm", ".ogg"));
		
			/*new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{*/
				vidSound.time = vidSound.length * soundMultiplier;
				/*new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					if (useSound)
					{
						vidSound.time = vidSound.length * soundMultiplier;
					}
				}, 0);*/
				doShit = true;
			//}, 1);
		//}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if mobile
		updateMobileVideo();
		return;
		#end
		
		if (useSound)
		{
			var wasFuckingHit = GlobalVideo.get().webm.wasHitOnce;
			soundMultiplier = GlobalVideo.get().webm.renderedCount / videoFrames;
			
			if (soundMultiplier > 1)
			{
				soundMultiplier = 1;
			}
			if (soundMultiplier < 0)
			{
				soundMultiplier = 0;
			}
			if (doShit)
			{
				var compareShit:Float = 50;
				if (vidSound.time >= (vidSound.length * soundMultiplier) + compareShit || vidSound.time <= (vidSound.length * soundMultiplier) - compareShit)
					vidSound.time = vidSound.length * soundMultiplier;
			}
			if (wasFuckingHit)
			{
			if (soundMultiplier == 0)
			{
				if (prevSoundMultiplier != 0)
				{
					vidSound.pause();
					vidSound.time = 0;
				}
			} else {
				if (prevSoundMultiplier == 0)
				{
					vidSound.resume();
					vidSound.time = vidSound.length * soundMultiplier;
				}
			}
			prevSoundMultiplier = soundMultiplier;
			}
		}
		
		if (notDone)
		{
			FlxG.sound.music.volume = 0;
		}
		GlobalVideo.get().update(elapsed);

		if (controls.RESET)
		{
			GlobalVideo.get().restart();
		}
		
		if (FlxG.keys.justPressed.P)
		{
			txt.text = pauseText;
			trace("PRESSED PAUSE");
			GlobalVideo.get().togglePause();
			if (GlobalVideo.get().paused)
			{
				GlobalVideo.get().alpha();
			} else {
				GlobalVideo.get().unalpha();
				txt.text = defaultText;
			}
		}
		
		if (controls.ACCEPT || GlobalVideo.get().ended || GlobalVideo.get().stopped)
		{
			txt.visible = false;
			GlobalVideo.get().hide();
			GlobalVideo.get().stop();
		}
		
		if (controls.ACCEPT || GlobalVideo.get().ended)
		{
			notDone = false;
			FlxG.sound.music.volume = fuckingVolume;
			txt.text = pauseText;
			FlxG.autoPause = true;
			FlxG.switchState(transClass);
		}
		
		if (GlobalVideo.get().played || GlobalVideo.get().restarted)
		{
			GlobalVideo.get().show();
		}
		
		GlobalVideo.get().restarted = false;
		GlobalVideo.get().played = false;
		GlobalVideo.get().stopped = false;
		GlobalVideo.get().ended = false;
	}

	#if mobile
	var video:Video;
	var videoFinished:Bool = false;

	function startMobileVideo():Void
	{
		if (FlxG.sound.music != null)
		{
			fuckingVolume = FlxG.sound.music.volume;
			FlxG.sound.music.volume = 0;
		}

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		add(bg);

		video = new Video();
		video.onFormatSetup.add(fitVideo);
		video.onEndReached.add(finishMobileVideo);
		video.onEncounteredError.add(function(message:String)
		{
			finishMobileVideo();
		});
		FlxG.addChildBelowMouse(video);

		if (video.load(leSource))
			new FlxTimer().start(0.001, function(tmr:FlxTimer)
			{
				if (video != null)
					video.play();
			});
		else
			finishMobileVideo();
	}

	function fitVideo():Void
	{
		if (video == null || video.bitmapData == null)
			return;

		var areaWidth:Float = FlxG.scaleMode.gameSize.x;
		var areaHeight:Float = FlxG.scaleMode.gameSize.y;
		var scale:Float = Math.min(areaWidth / video.bitmapData.width, areaHeight / video.bitmapData.height);

		video.width = video.bitmapData.width * scale;
		video.height = video.bitmapData.height * scale;
		video.x = (areaWidth - video.width) / 2;
		video.y = (areaHeight - video.height) / 2;
	}

	function updateMobileVideo():Void
	{
		if (videoFinished)
			return;

		if (FlxG.sound.music != null)
			FlxG.sound.music.volume = 0;

		var skipped:Bool = controls.ACCEPT;
		for (touch in FlxG.touches.list)
			if (touch.justPressed)
				skipped = true;

		if (skipped)
			finishMobileVideo();
	}

	function finishMobileVideo():Void
	{
		if (videoFinished)
			return;

		videoFinished = true;
		disposeVideo();

		if (FlxG.sound.music != null)
			FlxG.sound.music.volume = fuckingVolume;

		FlxG.switchState(transClass);
	}

	function disposeVideo():Void
	{
		if (video == null)
			return;

		video.stop();
		FlxG.removeChild(video);
		video.dispose();
		video = null;
	}

	override function destroy()
	{
		disposeVideo();
		super.destroy();
	}
	#end
}
