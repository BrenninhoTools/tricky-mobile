package;

import flixel.util.FlxSignal;

class NGio
{
	public static var isLoggedIn:Bool = false;
	public static var scoreboardsLoaded:Bool = false;

	public static var ngDataLoaded(default, null):FlxSignal = new FlxSignal();
	public static var ngScoresLoaded(default, null):FlxSignal = new FlxSignal();

	public static var GAME_VER:String = "";
	public static var GAME_VER_NUMS:String = '';
	public static var gotOnlineVer:Bool = false;

	public static function noLogin(api:String):Void {}

	public function new(api:String, encKey:String, ?sessionId:String) {}

	inline static public function postScore(score:Int = 0, song:String):Void {}

	inline static public function logEvent(event:String):Void {}

	inline static public function unlockMedal(id:Int):Void {}
}
