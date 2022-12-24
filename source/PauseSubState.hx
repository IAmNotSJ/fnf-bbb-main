package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<FlxSprite>;

	var menuItems:Array<String> = ['resume', 'restart', 'exit'];
	var difficultyChoices = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	var skipTimeText:FlxText;
	var skipTimeTracker:Alphabet;
	var curTime:Float = Math.max(0, Conductor.songPosition);
	//var botplayText:FlxText;

	var shitTween:FlxTween;

	var leftSide:FlxSprite;
	var portrait:FlxSprite;
	var pink:FlxSprite;
	var blue:FlxSprite;
	var titlecard:FlxSprite;
	var title:FlxSprite;
	var text:FlxText;

	var random:Int = FlxG.random.int(1,3);

	public static var songName:String = '';

	public function new(x:Float, y:Float)
	{
		super();

		for (i in 0...CoolUtil.difficulties.length) {
			var diff:String = '' + CoolUtil.difficulties[i];
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');


		pauseMusic = new FlxSound();
		if(songName != null) {
			pauseMusic.loadEmbedded(Paths.music(songName), true, true);
		} else if (songName != 'None') {
			pauseMusic.loadEmbedded(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)), true, true);
		}
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		leftSide = new FlxSprite(FlxG.width - 50).loadGraphic(Paths.image('pause/left'));
		leftSide.scrollFactor.set();
		add(leftSide);

		portrait = new FlxSprite(397, 648).loadGraphic(Paths.image('pause/portraits/cleft'));
		portrait.scrollFactor.set();
		add(portrait);

		pink = new FlxSprite(1400, -215).loadGraphic(Paths.image('pause/pink'));
		pink.scrollFactor.set();
		add(pink);

		blue = new FlxSprite(0, 728).loadGraphic(Paths.image('pause/blue'));
		blue.scrollFactor.set();
		add(blue);

		titlecard = new FlxSprite(-859, 5).loadGraphic(Paths.image('pause/titleback'));
		titlecard.scrollFactor.set();
		add(titlecard);

		title = new FlxSprite(-1038, -51);
		title.scrollFactor.set();
		add(title);

		text = new FlxText(-970, 205, 610, "", 32);
		text.setFormat(Paths.font("barlow.ttf"), 32, 0xFF02022F, CENTER);
		add(text);

		switch(random)
		{
			case 1:
				switch (PlayState.SONG.song)
				{
					case 'Test':
						title.loadGraphic(Paths.image('pause/titles/title jr'));
						portrait.loadGraphic(Paths.image('pause/portraits/jr'));
						if (!ClientPrefs.cleftKey)
							text.text = 'A carefree kid joining Battery and Cool Card on\ntheir quest for the Staff of Creation. What\nhe wants with the staff is unknown to any\nof the crew.';
						else
							text.text = "He-he-here we go! So he's finally here, performing for you. If you know the words, you can join in too! Put your hands together, if you want to clap, as he takes you through this autism rap! Huh! C.K. Cleft Key! He's the leader of the bunch, you know him well, he's finally back to kick some tail. His magnum 44 can fire in spurts, if he shoots ya, it's gonna hurt! He's british, british, and british too! He's the first member of the CK Crew! Huh!";
					case 'Almost Naked Animals':
						title.loadGraphic(Paths.image('pause/titles/title cleft'));
						portrait.loadGraphic(Paths.image('pause/portraits/cleft'));
						text.text = 'Ew you must be from reddit! Stinky stinky! I can\nsmell the redditors from here! Ew, get away\nfrom me you stinky disgusting redditors.\nJesus, you are a disgrace.';
					case '8 Bit' | 'Flying Battery Zone':
						title.loadGraphic(Paths.image('pause/titles/title jr'));
						portrait.loadGraphic(Paths.image('pause/portraits/jr'));
						text.text = 'CWAF Jr. has his mic and is ready to put on a performance! In order to get rid of the barrier that is protecting the staff of creation, he must sing! He seems a bit too excited, though..';
				}
			case 2:
				switch (PlayState.SONG.song)
				{
					case 'Test':
						title.loadGraphic(Paths.image('pause/titles/title monika'));
						portrait.loadGraphic(Paths.image('pause/portraits/monika'));
						text.y -= 10;
						text.text = 'When an odd flower bed pulls CWAF Jr. into the\nground, this is who awaits him on the other side!\nThough kind of creepy, this character only wants\ntwo things, to sing and dance!';
					case 'Almost Naked Animals':
						title.loadGraphic(Paths.image('pause/titles/title monika'));
						portrait.loadGraphic(Paths.image('pause/portraits/monikaMini'));
						text.y -= 35;
						text.text = "Hey - what's up Brian? Erm... I have a name and it's - This is going great so far - I want to play a game , obama. The fuck? No! More like - a competition ... object .... show. So areyou going to start asking me who I am or where I came from? Oh no. I can't do that Like... Physically So are you in , or? Oh yeah- I have this NFT... Oh, it's like 5 dollars. So you gonna hop on? Not really... Welcome to... What? It doesn't stand for anything. I think. Ha Ha Ha ! I don't get it... Teams? What? There's like 7 of you... I'm going to start the first challenge now. You see this? It's your challenge. Hold it for 20 seconds total to win. Go!! Wow , that was really wrong - this sound effects machine is busted. Whatever. Cost you won the challenge. You'll be immune from the elimination.";
						text.size = 18;
					case '8 Bit' | 'Flying Battery Zone':
						title.loadGraphic(Paths.image('pause/titles/title battery'));
						portrait.loadGraphic(Paths.image('pause/portraits/battery'));
						text.size = 30;
						text.y -= 15;
						text.text = 'After leading a long expedition to find the staff of creation with his boyfriend, Cool Card, Battery has finally gotten to his final destination! But whats this? One of his explorers, CWAF Jr, wants a rap battle!';
				}
			case 3:
				switch (PlayState.SONG.song)
				{
					case 'Test':
						title.loadGraphic(Paths.image('pause/titles/title staff'));
						portrait.loadGraphic(Paths.image('pause/portraits/staff'));
						text.y -= 23;
						text.text = 'Once made as a tool for protection, this artifact\nwas used to bring the Earth to its knees. After it\nwiped out all of mankind, the staff was sealed\naway in a large collection of identical towers,\nuntouched for eons.';
					case 'Almost Naked Animals':
						title.loadGraphic(Paths.image('pause/titles/title b3'));
						portrait.loadGraphic(Paths.image('pause/portraits/mini'));
						text.y -= 30;
						text.text = 'So, imagine if you took 9 mentally unsound\nindividuals and put them all together in a\nshow. This is an object show by Cleft Key,\nwith each character representing a different\nmember of the real BBB server!';
				}
		}



		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("CookieRun Bold.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font("CookieRun Bold.ttf"), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);


		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(leftSide, {x:745}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(portrait, {y:-34}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(pink, {x:1070.1, y:0}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(blue, {y:403}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(titlecard, {x: 0}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(title, {x: -58}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(text, {x: 30}, 0.4, {ease: FlxEase.quartInOut});

		grpMenuShit = new FlxTypedGroup<FlxSprite>();
		add(grpMenuShit);

		regenMenu();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float)
	{
		cantUnpause -= elapsed;
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);
		updateSkipTextStuff();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		var daSelected:String = menuItems[curSelected];
		switch (daSelected)
		{
			case 'Skip Time':
				if (controls.UI_LEFT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					curTime -= 1000;
					holdTime = 0;
				}
				if (controls.UI_RIGHT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					curTime += 1000;
					holdTime = 0;
				}

				if(controls.UI_LEFT || controls.UI_RIGHT)
				{
					holdTime += elapsed;
					if(holdTime > 0.5)
					{
						curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);
					}

					if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
					else if(curTime < 0) curTime += FlxG.sound.music.length;
					updateSkipTimeText();
				}
		}

		if (accepted && (cantUnpause <= 0 || !ClientPrefs.controllerMode))
		{
			if (menuItems == difficultyChoices)
			{
				if(menuItems.length - 1 != curSelected && difficultyChoices.contains(daSelected)) {
					var name:String = PlayState.SONG.song;
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = curSelected;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					PlayState.changedDifficulty = true;
					PlayState.chartingMode = false;
					return;
				}
				regenMenu();
			}

			switch (daSelected)
			{
				case "resume":
					close();
				case "restart":
					restartSong();
				case "exit":
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;

					WeekData.loadTheFirstEnabledMod();
					if(PlayState.isStoryMode) {
						MusicBeatState.switchState(new StoryMenuState());
					} else {
						MusicBeatState.switchState(new FreeplayState());
					}
					PlayState.cancelMusicFadeTween();
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;
			}
		}
	}

	function deleteSkipTimeText()
	{
		if(skipTimeText != null)
		{
			skipTimeText.kill();
			remove(skipTimeText);
			skipTimeText.destroy();
		}
		skipTimeText = null;
		skipTimeTracker = null;
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			bullShit++;
		}

		grpMenuShit.forEach(function(spr:FlxSprite)
			{
				if (spr.ID == curSelected)
					shitTween = FlxTween.tween(spr, {x: 0}, 0.1, {
						onComplete: function(twn:FlxTween) {
							shitTween = null;
						}
					});
				else 
					spr.x = -50;
			});
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		var tex = Paths.getSparrowAtlas('pause/buttons');
		for (i in 0...menuItems.length)
		{
			var item:FlxSprite = new FlxSprite(-556, 436 + (i * 81));
			item.frames = tex;
			item.animation.addByPrefix('basic', menuItems[i], 24);
			item.animation.play('basic');
			item.ID = i;
			grpMenuShit.add(item);
			item.scrollFactor.set();
			item.antialiasing = true;
		}

		curSelected = 0;
		changeSelection();
	}
	
	function updateSkipTextStuff()
	{
		if(skipTimeText == null || skipTimeTracker == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText()
	{
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}


}
