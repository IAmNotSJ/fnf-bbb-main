package;

import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

import haxe.io.Path;

class LoadingScreen extends MusicBeatState
{
	var target:FlxState;

	var funkay:FlxSprite;
	var song:String = PlayState.SONG.song;

	var characterMap:Map<String, Character> = new Map();
	override function create()
	{
		Paths.clearStoredMemory();
		
		/*var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xffcaff4d);
		add(bg);
		funkay = new FlxSprite(0, 0).loadGraphic(Paths.getPath('images/funkay.png', IMAGE));
		funkay.setGraphicSize(0, FlxG.height);
		funkay.updateHitbox();
		funkay.antialiasing = ClientPrefs.globalAntialiasing;
		add(funkay);
		funkay.scrollFactor.set();
		funkay.screenCenter();*/

		function loadCharacter(newCharacter:String)
			{
				if(!characterMap.exists(newCharacter)) {
					var newGuy:Character = new Character(0, 0, newCharacter);
					characterMap.set(newCharacter, newGuy);
					add(newGuy);
					newGuy.alpha = 1;
				}
			}

		function loadStage(leSong:String)
			{
				switch (leSong)
				{
					case 'test':
						var bg:FlxSprite = new FlxSprite(-1175, -915).makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), FlxColor.WHITE);
						bg.scrollFactor.set(0.8, 0.8);
						bg.antialiasing = FlxG.save.data.antialiasing;
						bg.updateHitbox();
						add(bg);
	
						var floor:FlxSprite = new FlxSprite(-400, 720).makeGraphic(Std.int(FlxG.width * 3), 400);
						floor.color = 0xFFd3dbdb;
						floor.scrollFactor.set(0.8, 0.8);
						floor.updateHitbox();
						add(floor);
	
						var monSign:BGSprite = new BGSprite('Monika', 133, 121, 0.8, 0.8);
						monSign.scrollFactor.set(0.8, 0.8);
						add(monSign);

						loadCharacter('monika');
						loadCharacter('jr');
						loadCharacter('speaker');
				}
			}

			loadStage('test');

			new FlxTimer().start(1, function(tmr:FlxTimer)
			LoadingState.loadAndSwitchState(new PlayState()));
	}
}