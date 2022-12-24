package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;

class CharacterSetting
{
	public var x(default, null):Float;
	public var y(default, null):Float;
	public var scale(default, null):Float;
	public var flipped(default, null):Bool;

	public function new(x:Float = 0, y:Float = 0, scale:Float = 1.0, flipped:Bool = false)
	{
		this.x = x;
		this.y = y;
		this.scale = scale;
		this.flipped = flipped;
	}
}

class MenuCharacter extends FlxSprite
{
	private static var settings:Map<String, CharacterSetting> = [
		'bf' => new CharacterSetting(0, -20, 1, true),
		'jr' => new CharacterSetting(-8.3, -367.1, 1, false),
		'monika' => new CharacterSetting(-309.1, -75.6, 1, false)
	];

	private var flipped:Bool = false;
	//questionable variable name lmfao
	private var goesLeftNRight:Bool = false;
	private var danceLeft:Bool = false;
	private var character:String = '';

	public function new(x:Float, y:Float, scale:Float, flipped:Bool)
	{
		super(x, y);
		this.flipped = flipped;

		antialiasing = ClientPrefs.globalAntialiasing;

		frames = Paths.getSparrowAtlas('campaign_menu_UI_characters');

		animation.addByPrefix('bf', "BF idle dance white", 24, false);
		animation.addByPrefix('bfConfirm', 'BF HEY!!', 24, false);
		animation.addByPrefix('jr', 'jr bop', 24, false);
		animation.addByPrefix('jrConfirm', 'jr hey', 24, false);
		animation.addByPrefix('monika', 'monika bop', 24, false);
		animation.addByPrefix('monikaConfirm', 'monika hey', 24, false);

		setGraphicSize(Std.int(width * scale));
		updateHitbox();
	}

	public function setCharacter(character:String):Void
	{
		var sameCharacter:Bool = character == this.character;
		this.character = character;
		if (character == '')
		{
			visible = false;
			return;
		}
		else
		{
			visible = true;
		}

		if (!sameCharacter) {
			bopHead(true);
		}

		var setting:CharacterSetting = settings[character];
		offset.set(setting.x, setting.y);
		setGraphicSize(Std.int(width * setting.scale));
		flipX = setting.flipped != flipped;
	}

	public function bopHead(LastFrame:Bool = false):Void
	{
		if (character == 'gf' || character == 'spooky') {
			danceLeft = !danceLeft;

			if (danceLeft)
				animation.play(character + "-left", true);
			else
				animation.play(character + "-right", true);
		} else {
			//no spooky nor girlfriend so we do da normal animation
			if (animation.name == "bfConfirm" || animation.name == "jrConfirm" || animation.name == "monikaConfirm")
				return;
			animation.play(character, true);
		}
		if (LastFrame) {
			animation.finish();
		}
	}
}
