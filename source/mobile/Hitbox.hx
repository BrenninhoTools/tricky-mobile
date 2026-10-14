package mobile;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import mobile.TouchInput.TouchPoint;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

class Hitbox extends FlxSpriteGroup implements TouchKeySource
{
	static final KEYS:Array<FlxKey> = [FlxKey.LEFT, FlxKey.DOWN, FlxKey.UP, FlxKey.RIGHT];
	static final COLORS:Array<FlxColor> = [0xFFC24B99, 0xFF00FFFF, 0xFF12FA05, 0xFFF9393F];
	static final ARROW_NAMES:Array<String> = ['left', 'down', 'up', 'right'];
	static final ARROW_CENTERS:Array<Float> = [140, 350, 930, 1140];
	static inline var BORDER:Int = 5;
	static inline var FADE_TIME:Float = 0.12;
	static inline var ARROW_SIZE:Int = 170;
	static inline var ARROW_REACH:Float = 150;
	static inline var ARROW_IDLE_ALPHA:Float = 0.6;

	public var lanes(default, null):Array<FlxSprite> = [];
	public var blockers:Array<FlxSprite> = [];
	public var invisible:Bool;
	public var arrowMode(default, null):Bool;

	var down:Array<Bool> = [false, false, false, false];
	var excluded:Array<Int> = [];
	var laneWidth:Float;
	var createdFrame:Int;
	var lastFrame:Int = -1;

	public function new()
	{
		super();
		scrollFactor.set();

		invisible = FlxG.save.data.invisibleHitbox == true;
		arrowMode = MobileControls.hitboxMode == MobileControls.ARROWS;
		laneWidth = FlxG.width / KEYS.length;

		if (arrowMode)
			createArrows();
		else
			createLanes();

		createdFrame = TouchKeyBridge.frame;
		TouchKeyBridge.register(this);
	}

	function createLanes():Void
	{
		for (i in 0...KEYS.length)
		{
			var lane:FlxSprite = new FlxSprite(Math.round(laneWidth * i), 0);
			lane.loadGraphic(createLane(Math.round(laneWidth), FlxG.height, COLORS[i]), false, 0, 0, true, 'hitbox-lane-$i');
			lane.antialiasing = true;
			lane.alpha = 0;
			lanes.push(lane);
			add(lane);
		}
	}

	function createArrows():Void
	{
		var atlas = Paths.getSparrowAtlas('mobile/arrows', 'shared');
		for (i in 0...KEYS.length)
		{
			var arrow:FlxSprite = new FlxSprite();
			arrow.frames = atlas;
			arrow.animation.addByPrefix('idle', ARROW_NAMES[i], 0, false);
			arrow.animation.play('idle');
			arrow.setGraphicSize(ARROW_SIZE, ARROW_SIZE);
			arrow.updateHitbox();
			arrow.setPosition(ARROW_CENTERS[i] - arrow.width / 2, FlxG.height - arrow.height - 24);
			arrow.antialiasing = true;
			arrow.alpha = invisible ? 0 : ARROW_IDLE_ALPHA;
			lanes.push(arrow);
			add(arrow);
		}
	}

	static function createLane(width:Int, height:Int, color:FlxColor):BitmapData
	{
		var top:FlxColor = color;
		top.alphaFloat = 0;
		var middle:FlxColor = color;
		middle.alphaFloat = 0.12;
		var bottom:FlxColor = color;
		bottom.alphaFloat = 0.5;

		var bitmap:BitmapData = FlxGradient.createGradientBitmapData(width, height, [top, middle, bottom], 1, 90);

		var edge:FlxColor = color;
		edge.alphaFloat = 0.9;
		bitmap.fillRect(new Rectangle(0, 0, BORDER, height), edge);
		bitmap.fillRect(new Rectangle(width - BORDER, 0, BORDER, height), edge);
		bitmap.fillRect(new Rectangle(0, height - BORDER * 2, width, BORDER * 2), edge);

		var shine:FlxColor = FlxColor.WHITE;
		shine.alphaFloat = 0.35;
		bitmap.fillRect(new Rectangle(BORDER, height - BORDER * 3, width - BORDER * 2, BORDER), shine);
		return bitmap;
	}

	public function isDown(lane:Int):Bool
	{
		return down[lane];
	}

	function laneAt(x:Float, y:Float):Int
	{
		if (arrowMode)
			return arrowAt(x, y);

		var lane:Int = Math.floor(x / laneWidth);
		return lane < 0 ? 0 : (lane >= KEYS.length ? KEYS.length - 1 : lane);
	}

	function arrowAt(x:Float, y:Float):Int
	{
		var best:Int = -1;
		var bestDistance:Float = ARROW_REACH;
		for (i in 0...lanes.length)
		{
			var arrow:FlxSprite = lanes[i];
			var dx:Float = x - (arrow.x + arrow.width / 2);
			var dy:Float = y - (arrow.y + arrow.height / 2);
			var distance:Float = Math.sqrt(dx * dx + dy * dy);
			if (distance <= bestDistance)
			{
				bestDistance = distance;
				best = i;
			}
		}
		return best;
	}

	function startsOnBlocker(point:TouchPoint):Bool
	{
		for (blocker in blockers)
			if (blocker != null && blocker.visible && TouchInput.overlaps(blocker, point.startX, point.startY, 20))
				return true;
		return false;
	}

	public function collectKeys(into:Array<Int>):Void
	{
		for (i in 0...down.length)
			down[i] = false;

		if (!exists || !alive || !active || !TouchKeyBridge.isActive(lastFrame))
		{
			excluded = [];
			return;
		}

		var present:Array<Int> = [];
		for (point in TouchInput.points)
		{
			if (point.startFrame < createdFrame)
				continue;

			present.push(point.id);

			if (!point.seen && startsOnBlocker(point) && !excluded.contains(point.id))
				excluded.push(point.id);

			if (excluded.contains(point.id) || !point.down)
				continue;

			var lane:Int = laneAt(point.x, point.y);
			if (lane != -1)
				down[lane] = true;
		}

		var i:Int = excluded.length;
		while (i-- > 0)
			if (!present.contains(excluded[i]))
				excluded.splice(i, 1);

		for (lane in 0...KEYS.length)
			if (down[lane] && !into.contains(KEYS[lane]))
				into.push(KEYS[lane]);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		lastFrame = TouchKeyBridge.frame;

		if (arrowMode)
		{
			for (i in 0...lanes.length)
			{
				var target:Float = invisible ? 0 : (down[i] ? 1 : ARROW_IDLE_ALPHA);
				lanes[i].alpha = target;
				var scale:Float = (down[i] ? 0.9 : 1) * ARROW_SIZE / lanes[i].frameWidth;
				lanes[i].scale.set(scale, scale);
			}
			return;
		}

		for (i in 0...lanes.length)
		{
			if (down[i] && !invisible)
				lanes[i].alpha = 1;
			else if (lanes[i].alpha > 0)
				lanes[i].alpha = Math.max(0, lanes[i].alpha - elapsed / FADE_TIME);
		}
	}

	override function destroy()
	{
		TouchKeyBridge.unregister(this);
		lanes = [];
		blockers = [];
		super.destroy();
	}
}
