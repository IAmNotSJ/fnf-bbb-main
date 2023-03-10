import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class CleftIcon extends FlxSprite
{
    public function new(name:String)
    {
        super(name);
        loadGraphic(Paths.image('cleft key/icon'));
        antialiasing = ClientPrefs.globalAntialiasing;
    }

    public function select()
    {
        scale.set(1.1, 1.1);
    }
}
