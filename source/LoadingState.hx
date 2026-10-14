package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import openfl.utils.Assets;

class LoadingState extends MusicBeatState
{
	static inline var BAR_HEIGHT:Int = 8;
	static inline var MIN_FRAMES:Int = 2;

	var target:FlxState;
	var stopMusic:Bool = false;
	var pending:Array<String> = [];
	var total:Int = 0;
	var shownFrames:Int = 0;
	var shownProgress:Float = 0;
	var finished:Bool = false;
	var bar:FlxSprite;

	function new(target:FlxState, stopMusic:Bool)
	{
		super();
		this.target = target;
		this.stopMusic = stopMusic;
	}

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('loadingButNotDone', 'clown'));
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.antialiasing = true;
		add(bg);

		var barBack:FlxSprite = new FlxSprite(0, FlxG.height - BAR_HEIGHT).makeGraphic(FlxG.width, BAR_HEIGHT, FlxColor.BLACK);
		barBack.alpha = 0.6;
		add(barBack);

		bar = new FlxSprite(0, FlxG.height - BAR_HEIGHT).makeGraphic(FlxG.width, BAR_HEIGHT, FlxColor.RED);
		bar.origin.set(0, 0);
		bar.scale.x = 0;
		add(bar);

		if (Assets.getLibrary("songs") == null)
		{
			pending.push("library:songs");
			total = 1;
			Assets.loadLibrary("songs").onComplete(function(_)
			{
				pending.remove("library:songs");
				loadSounds();
			}).onError(function(_)
			{
				pending.remove("library:songs");
			});
		}
		else
			loadSounds();
	}

	function loadSounds():Void
	{
		for (path in getSoundPaths())
		{
			if (isSoundLoaded(path))
				continue;

			pending.push(path);
			total++;
			Assets.loadSound(path).onComplete(function(_) pending.remove(path)).onError(function(_) pending.remove(path));
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var progress:Float = total == 0 ? 1 : (total - pending.length) / total;
		shownProgress += (progress - shownProgress) * Math.min(1, elapsed * 14);
		bar.scale.x = shownProgress;

		shownFrames++;
		if (!finished && pending.length == 0 && shownFrames > MIN_FRAMES)
		{
			finished = true;
			bar.scale.x = 1;
			onLoad();
		}
	}

	function onLoad():Void
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		FlxG.switchState(target);
	}

	static function getSoundPaths():Array<String>
	{
		var paths:Array<String> = [Paths.inst(PlayState.SONG.song)];
		if (PlayState.SONG.needsVoices)
			paths.push(Paths.voices(PlayState.SONG.song));
		return paths;
	}

	static function isSoundLoaded(path:String):Bool
	{
		return Assets.cache.hasSound(path);
	}

	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		FlxG.switchState(getNextState(target, stopMusic));
	}

	static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
		Paths.setCurrentLevel("week" + PlayState.storyWeek);

		if (PlayState.SONG != null)
			for (path in getSoundPaths())
				if (!isSoundLoaded(path))
					return new LoadingState(target, stopMusic);

		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		return target;
	}

	override function destroy()
	{
		target = null;
		pending = [];
		super.destroy();
	}
}
