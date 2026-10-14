# Vs. Tricky (trickster, what ever)

ok ok so heres the build instructions.

first, default kade engine build obv. [here if you don't know](https://kadedev.github.io/Kade-Engine/building)

next, we gotta do some video shit or what ever.

just do these things in the cmd window:

```
haxelib install actuate
haxelib git extension-webm https://github.com/KadeDev/extension-webm
lime rebuild extension-webm windows
```
you can change windows to mac or linux

alright you got everything you need to build now.

just do like

```
lime test windows -release
```

or what ever platform, be it linux or mac or smth lol!


btw special thanks to [GWebDev](https://github.com/GrowtopiaFli) for obviously video support, chad man.

## Android

Every push to `master` builds an Android APK (arm64) through GitHub Actions (`Actions` tab → `Android Build` → artifacts).

To build locally, use Haxe 4.3.7 and these libraries:

```
haxelib install hxcpp-4.3.175.zip
haxelib install lime 8.3.2
haxelib install openfl 9.5.2
haxelib install flixel 6.2.0
haxelib install flixel-addons 4.0.1
haxelib git flixel-ui https://github.com/HaxeFlixel/flixel-ui ff2f30148cb1a7c9b10373aa89cf1e0d7aafb648
haxelib install hscript
haxelib install actuate 1.9.0
haxelib git hxvlc https://github.com/MAJigsaw77/hxvlc 6f78d992b6f311717514f51343ae4dfd0d694bd2
```

`hxcpp-4.3.175.zip` comes from the [hxcpp releases](https://github.com/HaxeFoundation/hxcpp/releases/tag/v4.3.175).

Then run `lime build android -final` with the Android SDK, JDK 17 and NDK r28c.

Mobile controls are touch only:

- Gameplay uses a hitbox chosen in `Options → Mobile Options → Hitbox Mode`: Four Lanes (the screen split in four lanes that light up while touched) or Arrows (your strumline moves to the bottom, spread across the screen, the opponent's strumline is hidden and you tap the strums themselves). Invisible Hitbox hides the Four Lanes glow. The pause button sits in the top right corner.
- In menus, tap an option to select it and tap it again to confirm; dragging steps through options and values.
- The back button in the top left corner (or the Android back button) goes back.
- Story cutscenes play through hxvlc (libVLC) using the same `.webm` files; tap to skip.
