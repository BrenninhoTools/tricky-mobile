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

## Mobile (Android / iOS)

Every push to `master` builds an Android APK and an unsigned iOS IPA through GitHub Actions (`Actions` tab → `Mobile Build` → artifacts).

To build locally, use Haxe 4.2.5 and these libraries:

```
haxelib install hxcpp 4.3.2
haxelib install lime 8.0.1
haxelib install openfl 9.2.1
haxelib install flixel 4.11.0
haxelib install flixel-addons 2.11.0
haxelib install flixel-ui 2.4.0
haxelib install hscript 2.5.0
haxelib install actuate 1.9.0
haxelib install newgrounds 1.1.0
```

Then run `lime build android -final` (Android SDK, JDK 11 and NDK r21e configured through `lime setup android`) or `lime build ios -nosign -final` on macOS with Xcode.

Mobile notes:

- Gameplay uses a 4-lane hitbox by default; switch to the virtual pad in `Options → Gameplay → Controls`.
- The pause button sits at the top center of the screen, and the Android back button acts as Escape.
- Menus get a virtual pad; `A` confirms, the back button returns and `C` works as Shift in the options menu.
- Story cutscene videos are skipped on mobile, since `extension-webm` is desktop-only.
