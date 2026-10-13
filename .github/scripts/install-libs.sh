#!/usr/bin/env bash
set -e

haxelib setup "$HOME/haxelib"

haxelib install hxcpp 4.3.2 --quiet
haxelib install lime 8.0.1 --quiet
haxelib install openfl 9.2.1 --quiet
haxelib install flixel 4.11.0 --quiet
haxelib install flixel-addons 2.11.0 --quiet
haxelib install flixel-ui 2.4.0 --quiet
haxelib install hscript 2.5.0 --quiet
haxelib install actuate 1.9.0 --quiet
haxelib install newgrounds 1.1.0 --quiet
haxelib git hxvlc https://github.com/MAJigsaw77/hxvlc 6f78d992b6f311717514f51343ae4dfd0d694bd2 --quiet

haxelib list
