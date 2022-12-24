package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.system.FlxSound;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var cwafJr:FlxSprite;
	var monika:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var textSpeed:Float = 0.04;
	var curAnim:String = '';
	var curPref:String = '';
	
	//me when i am a dumbass
	var tweenUnfocusJr:FlxTween;
	var tweenFocusJr:FlxTween;
	var tweenUnfocusMonika:FlxTween;
	var tweenFocusMonika:FlxTween;
	public var diaMusic:FlxSound;

	//me when i am still a dumbass
	var daMute:Bool = false;

	//ty b3 ily <3 
	var inAutotext:Bool = false;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(48.75, 350.65);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'test':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('dialogue/monikaBox');
				box.animation.addByPrefix('normalOpen', 'monikaBoxAppear', 24, false);
				box.animation.addByIndices('normal', 'monikaBoxAppear', [4], "", 24);
			default:
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('dialogue/speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'speech bubble normal', 24, false);
				box.animation.addByPrefix('normalOpen', 'speech bubble normal', 24, true);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		cwafJr = new FlxSprite(528.7, 100.4);
		cwafJr.frames = Paths.getSparrowAtlas('dialogue/jrPortraits');
		cwafJr.animation.addByPrefix('fuck', 'jrFUCK');
		cwafJr.animation.addByPrefix('happy', 'jrHappy');
		cwafJr.animation.addByPrefix('default', 'jrDefault');
		cwafJr.animation.addByPrefix('awkward', 'jrAwkward0');
		cwafJr.animation.addByPrefix('surprised', 'jrSurprised');
		cwafJr.animation.addByPrefix('sad', 'jrSad');
		cwafJr.animation.addByPrefix('question', 'jrQuestion');
		cwafJr.animation.addByPrefix('denial', 'jrDenial');
		cwafJr.animation.addByPrefix('confused', 'jrConfusedTalk');
		cwafJr.animation.addByPrefix('awkwardTalk', 'jrAwkwardTalk');
		cwafJr.animation.addByPrefix('sweat', 'jrSweat');
		cwafJr.animation.addByPrefix('confusedTalk', 'jrConfusedTalk');
		cwafJr.animation.addByPrefix('introduce', 'jrIntroduce');
		cwafJr.animation.addByPrefix('shocked', 'jrShocked');
		cwafJr.animation.play('default');
		cwafJr.updateHitbox();
		cwafJr.scrollFactor.set();
		add(cwafJr);
		cwafJr.visible = false;
		cwafJr.alpha = 0;

		monika = new FlxSprite(86, 15.7);
		monika.frames = Paths.getSparrowAtlas('dialogue/monikaPortraits');
		monika.animation.addByPrefix('fuck', 'monikaFUCK');
		monika.animation.addByPrefix('happy', 'monikaHappy');
		monika.animation.addByPrefix('default', 'monikaDefault');
		monika.animation.addByPrefix('sad', 'monikaSad0');
		monika.animation.addByPrefix('introduce', 'monikaIntroduce');
		monika.animation.addByPrefix('think', 'monikaThink');
		monika.animation.addByPrefix('sadTalk', 'monikaSadTalk');
		monika.animation.addByPrefix('evilTalk', 'monikaEvilTalk');
		monika.animation.addByPrefix('mic', 'monikaMic');
		monika.animation.addByPrefix('dream', 'monikaDream');
		monika.animation.addByPrefix('point', 'monikaPoint0');
		monika.animation.addByPrefix('nudge', 'monikaNudge');
		monika.animation.addByPrefix('quote', 'monikaAirQuote');
		monika.animation.addByPrefix('jazz', 'monikaJazz');
		monika.animation.addByPrefix('woe', 'monikaWoe');
		monika.animation.addByPrefix('shock', 'monikaShock');
		monika.animation.addByPrefix('point2', 'monikaPointTwo');

		monika.animation.play('default');
		monika.updateHitbox();
		monika.scrollFactor.set();
		add(monika);
		monika.visible = false;
		
		box.animation.play('normalOpen');
		box.updateHitbox();
		add(box);

		box.screenCenter(X);

		handSelect = new FlxSprite(1125.8, 626.7).loadGraphic(Paths.image('dialogue/glove'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(109.7, 473.65, 1048, "", 42);
		dropText.font = 'CookieRun Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(111.7, 471.65, 1048, "", 42);
		swagDialogue.font = 'CookieRun Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
				
		//me when i am a dumbass again
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
			// HARD CODING CUZ IM STUPDI

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			if (PlayState.isStoryMode)
				{
					switch (PlayState.SONG.song.toLowerCase())
					{
						case 'test':
							diaMusic = new FlxSound().loadEmbedded(Paths.music('MopeMope'));
						default:
							diaMusic = new FlxSound().loadEmbedded(Paths.music('MopeMope'));
					}

						diaMusic.play();
						diaMusic.volume = 0.8;
						diaMusic.looped = true;
				}
				
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true && !inAutotext)
		{
			nextText();
		}
		
		super.update(elapsed);
	}

	function nextText()
		{			
			if (!daMute)
				diaMusic.volume = 0.8;

			handSelect.scale.set(1.1, 1.1);
			FlxTween.tween(handSelect.scale, {x:1, y:1}, .1);

			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'test')
						diaMusic.fadeOut(2,0);

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						box.alpha -= .05;
						bgFade.alpha -= .05 * 0.7;
						cwafJr.alpha -= .05;
						monika.alpha -= .05;
						swagDialogue.alpha -= .05;
						dropText.alpha = swagDialogue.alpha;
					}, 20);

					new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		var skipDialogue = false;

		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;

		switch (curCharacter)
		{
			case 'jr':

				cwafJr.visible = true;

				switch (curAnim)
				{
					
					case 'default':
						cwafJr.animation.play('default');
					case 'defaultSkip':
						skipDialogue = true;
						cwafJr.animation.play('default');
					case 'happy':
						cwafJr.animation.play('happy');
					case 'fuck':
						cwafJr.animation.play('fuck');
					case 'awkward':
						cwafJr.animation.play('awkward');
					case 'awkwardSkip':
						cwafJr.animation.play('awkward');
						skipDialogue = true;
					case 'surprised':
						cwafJr.animation.play('surprised');
					case 'sad':
						cwafJr.animation.play('sad');
					case 'question':
						cwafJr.animation.play('question');
					case 'denial':
						cwafJr.animation.play('denial');
					case 'confused':
						cwafJr.animation.play('confused');
					case 'awkwardTalk':
						cwafJr.animation.play('awkwardTalk');
					case 'sweat':
						cwafJr.animation.play('sweat');
					case 'sweatIntroduce':
						cwafJr.animation.play('sweat');
						FlxTween.tween(cwafJr, {x: 558.7}, .1);
						FlxTween.tween(cwafJr, {alpha: 1}, .1);
					case 'confusedTalk':
						cwafJr.animation.play('confusedTalk');
					case 'introduce':
						cwafJr.animation.play('introduce');
					case 'shocked':
						cwafJr.animation.play('shocked');
					case 'visible':
						skipDialogue = true;
						cwafJr.visible = true;
					case 'nonvisible':
						skipDialogue = true;
						cwafJr.visible = false;
					case 'unfocus':
						if (tweenFocusJr != null)
							tweenFocusJr.cancel();
						skipDialogue = true;
						tweenUnfocusJr = FlxTween.tween(cwafJr.scale, {x: 0.75, y: 0.75}, .1);
						tweenUnfocusJr = FlxTween.color(cwafJr, 0.1, cwafJr.color, FlxColor.fromString("0xFF4A4B58"));
						tweenUnfocusJr = FlxTween.tween(cwafJr, {y: cwafJr.y + 30}, .1);
					case 'focus':
						if (tweenUnfocusJr != null)
							tweenUnfocusJr.cancel();
						skipDialogue = true;
						tweenFocusJr = FlxTween.tween(cwafJr.scale, {x: 1, y: 1}, .1);
						cwafJr.color = 0x00FFFFFF;
						tweenFocusJr = FlxTween.tween(cwafJr, {y: cwafJr.y - 30}, .1);
					default:
						cwafJr.animation.play('default');
				}
			case 'monika':
				monika.visible = true;
				switch (curAnim)
				{
					case 'default':
						monika.animation.play('default');
					case 'happy':
						monika.animation.play('happy');
					case 'happyIntroduce':
						monika.animation.play('happy');
						FlxTween.tween(monika, {x: 116.7}, .1);
						FlxTween.tween(monika, {alpha: 1}, .1);
					case 'fuck':
						monika.animation.play('fuck');
					case 'sad':
						monika.animation.play('sad');
					case 'introduce':
						monika.animation.play('introduce');
					case 'think':
						monika.animation.play('think');
					case 'sadTalk':
						monika.animation.play('sadTalk');
					case 'evilTalk':
						monika.animation.play('evilTalk');
					case 'mic':
						monika.animation.play('mic');
					case 'point':
						monika.animation.play('point');
					case 'dream':
						monika.animation.play('dream');
					case 'visible':
						skipDialogue = true;
						monika.visible = true;
					case 'nonvisible':
						skipDialogue = true;
						monika.visible = false;
					case 'nudge':
						monika.animation.play('nudge');
					case 'quote':
						monika.animation.play('quote');
					case 'jazz':
						monika.animation.play('jazz');
					case 'woe':
						monika.animation.play('woe');
					case 'shock':
						monika.animation.play('shock');
					case 'point2':
						monika.animation.play('point2');
					case 'unfocus':
						if (tweenFocusMonika != null)
							tweenFocusMonika.cancel();
						skipDialogue = true;

						tweenUnfocusMonika = FlxTween.tween(monika.scale, {x: 0.75, y: 0.75}, .1);
						tweenUnfocusMonika = FlxTween.color(monika, 0.1, monika.color, FlxColor.fromString("0xFF4A4B58"));
						tweenUnfocusMonika = FlxTween.tween(monika, {y: monika.y + 30}, .1);
					case 'focus':
						if (tweenUnfocusMonika != null)
							tweenUnfocusMonika.cancel();
						skipDialogue = true;

						tweenFocusMonika = FlxTween.tween(monika.scale, {x: 1, y: 1}, .1);
						monika.color = 0x00FFFFFF;
						tweenFocusMonika = FlxTween.tween(monika, {y: monika.y - 30}, .1);
					default:
						monika.animation.play('default');
				}

			case 'text':
				skipDialogue = true;

				switch (curAnim)
				{
					case 'speed':
						textSpeed = Std.parseFloat(dialogueList[0]);
					case 'autoSkip':
						inAutotext = true;
						new FlxTimer().start(Std.parseFloat(dialogueList[0]), function(e:FlxTimer){
							nextText();
							inAutotext = false;
						});
				}
			case 'sound':
				skipDialogue = true;
	
				switch (curAnim)
				{
					case 'voice':
						swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/' + dialogueList[0]), 0.6)];
					case 'musicStop':
						diaMusic.volume = 0;
						daMute = true;
					case 'musicPlay':
						diaMusic.volume = 0.8;
						daMute = false;

				}
			default:
				//just so i can put spaces in between the lines of dialogue
				skipDialogue = true;
			
		}

		swagDialogue.resetText(dialogueList[0]);
		if (!skipDialogue)
			swagDialogue.start(textSpeed, true);

		if(!skipDialogue){

			swagDialogue.delay = textSpeed;
			swagDialogue.resetText(dialogueList[0]);

			swagDialogue.start(textSpeed, true);
		}
		else{

			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		curAnim = splitName[2];
		curPref = splitName[3];

		dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[2].length + 3).trim();
	}
}
