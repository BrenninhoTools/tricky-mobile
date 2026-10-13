#!/usr/bin/env bash
set -e

haxelib install format --quiet
haxelib install hxp 1.2.2 --quiet

LIME=$(haxelib libpath lime)
sed -i 's/if (hasARMV7 || (!hasARMV5 \&\& !hasX86)) architectures.push(Architecture.ARMV7);/if (hasARMV7 || (!hasARMV5 \&\& !hasARM64 \&\& !hasX86)) architectures.push(Architecture.ARMV7);/' "$LIME/tools/platforms/AndroidPlatform.hx"
grep -q "!hasARM64 && !hasX86" "$LIME/tools/platforms/AndroidPlatform.hx"

cd "$LIME/tools"
haxe tools.hxml
