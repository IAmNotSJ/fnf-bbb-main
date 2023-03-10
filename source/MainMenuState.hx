package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC
	public static var bbbUpdateVersion:String = '2.5'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = ['story', 'freeplay', 'gallery', 'options', 'credits', 'discord'];

	private var bgColors:Array<String> = ['#FF0156', '#4D00FF', '#00DEFF', '#EFFF00'];
	private var cleftColors:Array<String> = ['#9BC40D', '#67E703', '#4AAD55', '#088033'];
	private var daColors:Array<String>;
	private var colorRotation:Int = 1;

	var camFollow:FlxObject;
	var debugKeys:Array<FlxKey>;

	var bg:FlxSprite;
	var border:FlxSprite;
	var bat:FlxSprite;
	var bts:FlxSprite;
	var mon:FlxSprite;
	var bgchance:Int;
	var vinyl:FlxSprite;
	var achievementItem:FlxSprite;
	var menugraphic:FlxSprite;
	var backdrop:FlxBackdrop;

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		if (ClientPrefs.cleftKey)
			daColors = cleftColors;
		else
			daColors = bgColors;

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		FlxG.mouse.visible = true;

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBG/menubgswirl'));
		bg.scrollFactor.set();
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = FlxG.save.data.antialising;
		add(bg);

		if (!ClientPrefs.cleftKey)
			backdrop = new FlxBackdrop(Paths.image('menuBG/circles'));
		else
			backdrop = new FlxBackdrop(Paths.image('menuBG/circles-cleft'));
		backdrop.velocity.set(40, -50);
		backdrop.screenCenter();
		backdrop.antialiasing = FlxG.save.data.antialising;
		add(backdrop);

		border = new FlxSprite(-80).loadGraphic(Paths.image('menuBG/bordershit'));
		border.scrollFactor.set();
		border.setGraphicSize(Std.int(border.width * 1.1));
		border.screenCenter();
		border.antialiasing = true;
		add(border);

		menugraphic = new FlxSprite(700);
		var iconsTex = Paths.getSparrowAtlas('menuBG/Graphics');
		menugraphic.frames = iconsTex;
		for (i in 0...optionShit.length)
		{
			menugraphic.animation.addByPrefix(optionShit[i], optionShit[i] + " graphic", 24, false);
		}
		menugraphic.animation.addByPrefix('cleft', "cleft graphic", 24, false);
		menugraphic.animation.play('story');
		menugraphic.updateHitbox();
		menugraphic.scrollFactor.set();
		add(menugraphic);
		menugraphic.antialiasing = FlxG.save.data.antialiasing;

		
		FlxTween.color(bg, 2, bg.color, FlxColor.fromString(daColors[colorRotation]));
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxTween.color(bg, 2, bg.color, FlxColor.fromString(daColors[colorRotation]));
			if (colorRotation < (daColors.length - 1))
				colorRotation++;
			else
				colorRotation = 0;
		}, 0);

		FlxTween.color(backdrop, 2, backdrop.color, FlxColor.fromString(daColors[colorRotation]));
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxTween.color(backdrop, 2, backdrop.color, FlxColor.fromString(daColors[colorRotation]));
		}, 0);


		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(-1050, 50 + (i * 100));
			menuItem.frames = Paths.getSparrowAtlas('menuBG/FNF_main_menu_assets');
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.8));
			menuItem.animation.addByPrefix('basic', optionShit[i] + " normal", 24);
			menuItem.animation.play('basic');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;

			switch (i)
			{
				case 0:
					menuItem.x = -1050;
				case 1:
					menuItem.x = -1050 + 75;
				case 2:
					menuItem.x = -1050 + 150;
				case 3:
					menuItem.x = -1050 + 150;
				case 4:
					menuItem.x = -1050 + 75;
				case 5:
					menuItem.x = -1050;
			}
		}

		achievementItem = new FlxSprite(1080, 540).loadGraphic(Paths.image('menuBG/achievements button'));
		achievementItem.updateHitbox();
		achievementItem.scrollFactor.set();
		add(achievementItem);

		vinyl = new FlxSprite(-300, 25).loadGraphic(Paths.image('menuBG/vinyl'));
		vinyl.setGraphicSize(Std.int(vinyl.width * 1));
		vinyl.scrollFactor.set();
		vinyl.updateHitbox();
		vinyl.scale.set(0.90, 0.90);
		vinyl.antialiasing = true;
		add(vinyl);

		bat = new FlxSprite(vinyl.x, vinyl.y).loadGraphic(Paths.image('menuBG/Record Bat'));
		bat.scrollFactor.set();
		bat.updateHitbox();
		bat.antialiasing = true;
		bat.scale.set(0.90, 0.90);
		if (FlxG.save.data.BatteryBeaten)
			bat.visible = true;
		else
			bat.visible = false;
		add(bat);

		bts = new FlxSprite(vinyl.x, vinyl.y).loadGraphic(Paths.image('menuBG/Record BTS'));
		bts.scrollFactor.set();
		bts.updateHitbox();
		bts.antialiasing = true;
		bts.scale.set(0.90, 0.90);
		if (FlxG.save.data.BTSBeaten)
			bts.visible = true;
		else
			bts.visible = false;
		add(bts);

		mon = new FlxSprite(vinyl.x, vinyl.y).loadGraphic(Paths.image('menuBG/Record Monika'));
		mon.scrollFactor.set();
		mon.updateHitbox();
		mon.antialiasing = true;
		mon.scale.set(0.90, 0.90);
		if (FlxG.save.data.MonikaBeaten)
			mon.visible = true
		else
			mon.visible = false;
		add(mon);

		FlxTween.angle(vinyl, vinyl.angle, 360, 3, {type: FlxTweenType.LOOPING});
		FlxTween.angle(bat, vinyl.angle, 360, 3, {type: FlxTweenType.LOOPING});
		FlxTween.angle(bts, vinyl.angle, 360, 3, {type: FlxTweenType.LOOPING});
		FlxTween.angle(mon, vinyl.angle, 360, 3, {type: FlxTweenType.LOOPING});

		FlxG.camera.follow(camFollow, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 4, 0, "BBB v" + bbbUpdateVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}

		
		if (FlxG.keys.justPressed.ONE && FlxG.keys.justPressed.CONTROL) giveAchievement();
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	var usingMouse:Bool = false;
	var canClick:Bool = true;

	override function update(elapsed:Float)
	{

		if(usingMouse)
		{
			if(!FlxG.mouse.overlaps(achievementItem))
				achievementItem.scale.set(1, 1);
			achievementItem.color = 0x00FFFFFF;
		}

		if (FlxG.mouse.overlaps(achievementItem))
		{
			if(canClick)
			{
				usingMouse = true;
				achievementItem.scale.set(0.95, 0.95);
				achievementItem.color = 0xFFbb9e00;
			}
				
			if(FlxG.mouse.pressed && canClick)
			{	
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					FlxG.switchState(new AchievementsMenuState());
				});
			}
		}
			
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (FlxG.keys.justPressed.F1)
			{
				if (!ClientPrefs.cleftKey)
					FlxG.switchState(new ShopState());
				if (ClientPrefs.cleftKey)
					 FlxG.switchState(new CleftShop());	
			}


			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'discord')
				{
					CoolUtil.browserLoad("https://discord.gg/HBzyx2D5rr");
				}
				else if (optionShit[curSelected] == 'gallery')
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
				}
				else
				{
					selectedSomethin = true;
					FlxG.mouse.visible = false;
					FlxG.sound.play(Paths.sound('confirmMenu'));


					FlxTween.tween(menugraphic, {x: menugraphic.x + 80}, 0.65, {
						ease: FlxEase.quadIn,
						onComplete: function(twn:FlxTween)
						{
							FlxTween.tween(menugraphic, {x: menugraphic.x + 2200}, 0.6, {ease: FlxEase.quadIn});
						}
					});

					FlxTween.tween(vinyl, {y: 105}, 0.65, {
						ease: FlxEase.quadIn,
						onComplete: function(twn:FlxTween)
						{
							FlxTween.tween(vinyl, {y: 1325}, 0.6, {ease: FlxEase.quadIn});
						}
					});
					FlxTween.tween(bat, {y: 105}, 0.65, {
						ease: FlxEase.quadIn,
						onComplete: function(twn:FlxTween)
						{
							FlxTween.tween(bat, {y: 1325}, 0.6, {ease: FlxEase.quadIn});
						}
					});
					FlxTween.tween(bts, {y: 105}, 0.65, {
						ease: FlxEase.quadIn,
						onComplete: function(twn:FlxTween)
						{
							FlxTween.tween(bts, {y: 1325}, 0.6, {ease: FlxEase.quadIn});
						}
					});
					FlxTween.tween(mon, {y: 105}, 0.65, {
						ease: FlxEase.quadIn,
						onComplete: function(twn:FlxTween)
						{
							FlxTween.tween(mon, {y: 1325}, 0.6, {ease: FlxEase.quadIn});
						}
					});
					FlxTween.tween(border.scale, {x: 3, y: 3});
					FlxTween.tween(backdrop, {alpha: 0}, 1.5);


					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {x: spr.x - 200}, 0.8, {
								ease: FlxEase.quadIn,
								onComplete: function(twn:FlxTween)
								{
									FlxTween.tween(spr, {x:spr.x - 500}, 0.4);
								}
							});
						}
						else
						{
							FlxTween.tween(spr, {x: spr.x + 800}, 0.4, {ease: FlxEase.quadIn});
							var daChoice:String = optionShit[curSelected];

							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								switch (daChoice)
								{
									case 'story':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menugraphic.scale.set(1.05, 1.05);
		FlxTween.tween(menugraphic.scale, {x:1, y:1}, .1);

		menuItems.forEach(function(spr:FlxSprite)
		{

			if (spr.ID == curSelected)
			{
				if(ClientPrefs.cleftKey)
				{
					menugraphic.animation.play('cleft');
					
					menugraphic.x = 557;
					menugraphic.y = 167;
				}
				else
				{
					menugraphic.animation.play(optionShit[spr.ID]);

					switch (spr.ID)
					{
						case 0:
							menugraphic.x = 575;
							menugraphic.y = 25;
						case 1:
							menugraphic.x = 720;
							menugraphic.y = -40;
						case 2:
							menugraphic.x = 580;
							menugraphic.y = 0;
						case 3:
							menugraphic.x = 620;
							menugraphic.y = 6;
						case 4:
							menugraphic.x = 560;
							menugraphic.y = 15;
						case 5:
							menugraphic.x = 660;
							menugraphic.y = 95;
					}
				}
				FlxTween.tween(spr, {x: spr.x + 200}, 0.1, {ease: FlxEase.quadIn});


			}
			else
			{
				switch (spr.ID)
				{
					case 0:
						spr.x = -1050;
					case 1:
						spr.x = -1050 + 30;
					case 2:
						spr.x = -1050 + 60;
					case 3:
						spr.x = -1050 + 60;
					case 4:
						spr.x = -1050 + 30;
					case 5:
						spr.x = -1050;
				}
			}

			spr.updateHitbox();
		});
	}
}
