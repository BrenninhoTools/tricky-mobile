package;

import haxe.CallStack;
import lime.app.Application;
import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class CrashHandler
{
	static var handled:Bool = false;

	public static function init():Void
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
		#if cpp
		untyped __global__.__hxcpp_set_critical_error_handler(onCriticalError);
		#end
	}

	static function onUncaughtError(event:UncaughtErrorEvent):Void
	{
		event.preventDefault();
		report(Std.string(event.error));
	}

	static function onCriticalError(message:Dynamic):Void
	{
		report(Std.string(message));
	}

	static function report(message:String):Void
	{
		if (handled)
			return;
		handled = true;

		var log:String = message + "\n" + CallStack.toString(CallStack.exceptionStack(true));

		#if sys
		try
		{
			var directory:String = #if mobile lime.system.System.applicationStorageDirectory #else "./" #end + "crash/";
			if (!FileSystem.exists(directory))
				FileSystem.createDirectory(directory);
			File.saveContent(directory + "VsTricky_" + DateTools.format(Date.now(), "%Y-%m-%d_%H-%M-%S") + ".txt", log);
		}
		catch (e:Dynamic) {}
		#end

		Application.current.window.alert(log, "Vs. Tricky crashed");
		lime.system.System.exit(1);
	}
}
