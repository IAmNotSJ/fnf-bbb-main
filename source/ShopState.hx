package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class ShopState extends MusicBeatState
{
    var fatNuts:Array<String> = ['cloth', 'folder', 'potion', 'shine', 'doki', 'fish', ''];

    var shopItems:FlxTypedGroup<FlxSprite>;

    override function create()
        {
            var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG'));
            bg.screenCenter();
            add(bg);

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
