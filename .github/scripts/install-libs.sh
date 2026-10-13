#!/usr/bin/env bash
set -e

HXCPP_VERSION=4.3.175

haxelib setup "$HOME/haxelib"

curl -sSL -o "${RUNNER_TEMP:-/tmp}/hxcpp.zip" "https://github.com/HaxeFoundation/hxcpp/releases/download/v$HXCPP_VERSION/hxcpp-$HXCPP_VERSION.zip"
haxelib install "${RUNNER_TEMP:-/tmp}/hxcpp.zip" --quiet

haxelib install lime 8.3.2 --quiet
haxelib install openfl 9.5.2 --quiet
haxelib install flixel 6.2.0 --quiet
haxelib install flixel-addons 4.0.1 --quiet
haxelib git flixel-ui https://github.com/HaxeFlixel/flixel-ui ff2f30148cb1a7c9b10373aa89cf1e0d7aafb648 --quiet
haxelib install hscript --quiet
haxelib install actuate 1.9.0 --quiet
haxelib git hxvlc https://github.com/MAJigsaw77/hxvlc 6f78d992b6f311717514f51343ae4dfd0d694bd2 --quiet

haxelib list
