package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class CleftShop extends MusicBeatState
{
    var fatNuts:Array<String> = ['', '', '', '', '', '', ''];

    var shopItems:FlxTypedGroup<FlxSprite>;

    override function create()
        {
            var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('cleft key/shopBg'));
            add(bg);
            var car:FlxSprite = new FlxSprite(396, 88).loadGraphic(Paths.image('cleft key/car'));
            add(car);
            var border:FlxSprite = new FlxSprite(0, 609).loadGraphic(Paths.image('cleft key/border'));
            add(border);

            shopItems = new FlxTypedGroup<FlxSprite>();
            add(shopItems);

            super.create();
        }

    override function update(elapsed:Float)
        {
            if (FlxG.keys.justPressed.ESCAPE)
                FlxG.switchState(new MainMenuState());
            super.update(elapsed);
        }
}
