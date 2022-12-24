package;

import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.animation.FlxBaseAnimation;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import animateatlas.AtlasFrameMaker;


using StringTools;

class BileSplat extends FlxSprite
{
    public function new(x:Int, y:Int)
        {
            frames = Paths.getSparrowAtlas('characters/battery');
            animation.addByPrefix('bilesplat1', 'battery hey', 24, false);
            animation.play('bilesplat1');

            super(x, y);
        }
}