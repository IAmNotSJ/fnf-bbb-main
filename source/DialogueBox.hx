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
	var battery:FlxSprite;
	var third:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var textSpeed:Float = 0.04;
	var curAnim:String = '';
	var curPref:String = '';

	var canContinue:Bool = true;
	var inCard:Bool = false;

	var card:FlxSprite;
	
	//me when i am a dumbass
	var tweenUnfocusJr:FlxTween;
	var tweenFocusJr:FlxTween;
	var tweenUnfocusOpponent:FlxTween;
	var tweenFocusOpponent:FlxTween;
	var tweenUnfocusThird:FlxTween;
	var tweenFocusThird:FlxTween;
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
			case '8 bit' | 'flying battery zone' | 'lore keeper':
				hasDialog = true;
				box.y += 22;
				box.frames = Paths.getSparrowAtlas('dialogue/batteryBox');
				box.animation.addByPrefix('normalOpen', 'batteryBoxAppear', 24, false);
				box.animation.addByIndices('normal', 'batteryBoxAppear', [6], "", 24);
			default:
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('dialogue/speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'speech bubble normal', 24, false);
				box.animation.addByPrefix('normalOpen', 'speech bubble normal', 24, true);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		third = new FlxSprite(377, 71);
		third.frames = Paths.getSparrowAtlas('dialogue/portraitsThird');
		third.animation.addByPrefix('cool', 'coolcardSwag');
		third.animation.addByPrefix('coolRom', 'coolcardRomance');
		third.animation.addByPrefix('cringers', 'cringersCheer');
		third.animation.play('cool');
		third.updateHitbox();
		third.alpha = 0;
		add(third);
		third.visible = false;

		cwafJr = new FlxSprite(750, 100.4);
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
		cwafJr.animation.addByPrefix('boast', 'jrBoastful0');
		cwafJr.animation.addByPrefix('boastTalk', 'jrBoastfulTalk');
		cwafJr.animation.addByPrefix('sympathetic', 'jrSympathetic');
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
		monika.alpha = 0;
		monika.scrollFactor.set();
		add(monika);
		monika.visible = false;

		battery = new FlxSprite(50, 90);
		battery.frames = Paths.getSparrowAtlas('dialogue/batteryPortraits');
		battery.animation.addByPrefix('fuck', 'batteryFUCK');
		battery.animation.addByPrefix('default', 'batteryDefault');
		battery.animation.addByPrefix('confused', 'batteryConfused0');
		battery.animation.addByPrefix('confusedTalk', 'batteryConfusedTalking');
		battery.animation.addByPrefix('nervous', 'batterySympathetic0');
		battery.animation.addByPrefix('nervousTalk', 'batterySympatheticTalk');
		battery.animation.addByPrefix('blush', 'batteryBlush0');
		battery.animation.addByPrefix('blushTalk', 'batteryBlushTalk');
		battery.animation.addByPrefix('look', 'batteryLook0');
		battery.animation.addByPrefix('lookTalk', 'batteryLookTalk');
		battery.animation.addByPrefix('annoyed', 'batteryAnnoyed0');
		battery.animation.addByPrefix('annoyedTalk', 'batteryAnnoyedTalk');
		battery.animation.addByPrefix('angry', 'batteryAngry');
		battery.animation.addByPrefix('reallyAngry', 'batteryReallyAngry');
		battery.animation.addByPrefix('tired', 'batteryTired');
		battery.animation.play('default');
		battery.updateHitbox();
		battery.scale.set(0.85, 0.85);
		add(battery);
		battery.alpha = 0;
		battery.visible = false;
		
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
							diaMusic = new FlxSound().loadEmbedded(Paths.music('MopeMope'), true, true);
						default:
							diaMusic = new FlxSound().loadEmbedded(Paths.music('MopeMope'), true, true);
					}

						diaMusic.play();
						FlxG.sound.list.add(diaMusic);
				}
				
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true && !inAutotext && canContinue)
		{
			nextText();
		}
		
		super.update(elapsed);
	}

	function nextText()
		{			

			if (!inCard)
				{
					handSelect.scale.set(1.1, 1.1);
					FlxTween.tween(handSelect.scale, {x:1, y:1}, .1);
					
				}
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			remove(dialogue);
				

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;
					
					diaMusic.fadeOut(2,0);

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						box.alpha -= .05;
						bgFade.alpha -= .05 * 0.7;
						cwafJr.alpha -= .05;
						monika.alpha -= .05;
						battery.alpha -= .05;
						third.alpha -= .05;
						swagDialogue.alpha -= .05;
						dropText.alpha = swagDialogue.alpha;
					}, 20);

					new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						if (!inCard)
							{
								diaMusic.kill();

								finishThing();
								kill();
							}
						else
							{
								box.kill();
								bgFade.kill();
								cwafJr.kill();
								monika.kill();
								battery.kill();
								third.kill();
								swagDialogue.kill();
								dropText.kill();
								handSelect.kill();
								new FlxTimer().start(0.1, function(tmr:FlxTimer)
									{
										card.alpha -= 0.05;
									}, 20);
								new FlxTimer().start(2, function(tmr:FlxTimer)
									{
										diaMusic.kill();

										finishThing();
										kill();
									}, 20);
							}

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
					case 'confusedTalk':
						cwafJr.animation.play('confusedTalk');
					case 'introduce':
						cwafJr.animation.play('introduce');
					case 'shocked':
						cwafJr.animation.play('shocked');
					case 'boast':
						cwafJr.animation.play('boast');
					case 'boastTalk':
						cwafJr.animation.play('boastTalk');
					case 'sympathetic':
						cwafJr.animation.play('sympathetic');
					case 'visible':
						skipDialogue = true;
						cwafJr.visible = true;
					case 'nonvisible':
						skipDialogue = true;
						cwafJr.visible = false;
					case 'intoScene':
						skipDialogue = true;
						FlxTween.tween(cwafJr, {x: 720}, .1);
						FlxTween.tween(cwafJr, {alpha: 1}, .1);
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
					case 'intoScene':
						skipDialogue = true;
						FlxTween.tween(monika, {x: 116.7}, .1);
						FlxTween.tween(monika, {alpha: 1}, .1);
					case 'unfocus':
						if (tweenFocusOpponent != null)
							tweenFocusOpponent.cancel();
						skipDialogue = true;

						tweenUnfocusOpponent = FlxTween.tween(monika.scale, {x: 0.75, y: 0.75}, .1);
						tweenUnfocusOpponent = FlxTween.color(monika, 0.1, monika.color, FlxColor.fromString("0xFF4A4B58"));
						tweenUnfocusOpponent = FlxTween.tween(monika, {y: monika.y + 30}, .1);
					case 'focus':
						if (tweenUnfocusOpponent != null)
							tweenUnfocusOpponent.cancel();
						skipDialogue = true;

						tweenFocusOpponent = FlxTween.tween(monika.scale, {x: 1, y: 1}, .1);
						monika.color = 0x00FFFFFF;
						tweenFocusOpponent = FlxTween.tween(monika, {y: monika.y - 30}, .1);
					default:
						monika.animation.play('default');
				}
			case 'battery':
				battery.visible = true;
				switch (curAnim)
					{
						case 'default':
							battery.animation.play('default');
						case 'confused':
							battery.animation.play('confused');
						case 'confusedTalk':
							battery.animation.play('confusedTalk');
						case 'nervous':
							battery.animation.play('nervous');
						case 'nervousTalk':
							battery.animation.play('nervousTalk');
						case 'blush':
							battery.animation.play('blush');
						case 'blushTalk':
							battery.animation.play('blushTalk');
						case 'look':
							battery.animation.play('look');
						case 'lookTalk':
							battery.animation.play('lookTalk');
						case 'annoyed':
							battery.animation.play('annoyed');
						case 'annoyedTalk':
							battery.animation.play('annoyedTalk');
						case 'angry':
							battery.animation.play('angry');
						case 'reallyAngry':
							battery.animation.play('reallyAngry');
						case 'tired':
							battery.animation.play('tired');
						case 'visible':
							skipDialogue = true;
							battery.visible = true;
						case 'nonvisible':
							skipDialogue = true;
							battery.visible = false;
						case 'intoScene':
							skipDialogue = true;
							FlxTween.tween(battery, {x: 20}, .1);
							FlxTween.tween(battery, {alpha: 1}, .1);
						case 'unfocus':
							if (tweenFocusOpponent != null)
								tweenFocusOpponent.cancel();
							skipDialogue = true;

							tweenUnfocusOpponent = FlxTween.tween(battery.scale, {x: 0.6, y: 0.6}, .1);
							tweenUnfocusOpponent = FlxTween.color(battery, 0.1, battery.color, FlxColor.fromString("0xFF4A4B58"));
							tweenUnfocusOpponent = FlxTween.tween(battery, {y: battery.y + 50}, .1);
						case 'focus':
							if (tweenUnfocusOpponent != null)
								tweenUnfocusOpponent.cancel();
							skipDialogue = true;

							tweenFocusOpponent = FlxTween.tween(battery.scale, {x: 0.85, y: 0.85}, .1);
							battery.color = 0x00FFFFFF;
							tweenFocusOpponent = FlxTween.tween(battery, {y: battery.y - 50}, .1);
						default:
							battery.animation.play('default');
					}
				case 'third':
					third.visible = true;
					switch (curAnim)
						{
							case 'cool':
								third.animation.play('cool');
							case 'coolRom':
								third.animation.play('coolRom');
							case 'cringers':
								third.animation.play('cringers');
							case 'visible':
								skipDialogue = true;
								third.visible = true;
							case 'nonvisible':
								skipDialogue = true;
								third.visible = false;
							case 'reset':
								skipDialogue = true;
								third.y = 71;
								third.alpha = 0;
							case 'intoScene':
								skipDialogue = true;
								FlxTween.tween(third, {y: third.y - 50}, .1);
								FlxTween.tween(third, {alpha: 1}, .1);
							case 'outScene':
								skipDialogue = true;
								FlxTween.tween(third, {y: third.y + 50}, .1);
								FlxTween.tween(third, {alpha: 0}, .1);
							case 'unfocus':
								third.alpha = 1;
								if (tweenFocusOpponent != null)
									tweenFocusOpponent.cancel();
								skipDialogue = true;
	
								tweenUnfocusOpponent = FlxTween.tween(third.scale, {x: 0.85, y: 0.85}, .1);
								tweenUnfocusOpponent = FlxTween.color(third, 0.1, third.color, FlxColor.fromString("0xFF4A4B58"));
								tweenUnfocusOpponent = FlxTween.tween(third, {y: third.y + 30}, .1);
								//for some reason the last tween in this list isnt working!! idk why!! have a nothing tween!!!
								tweenUnfocusOpponent = FlxTween.tween(third, {x: third.x}, .1);
							case 'focus':
								third.alpha = 1;
								if (tweenUnfocusOpponent != null)
									tweenUnfocusOpponent.cancel();
								skipDialogue = true;
	
								tweenFocusOpponent = FlxTween.tween(third.scale, {x: 1, y: 1}, .1);
								third.color = 0x00FFFFFF;
								tweenFocusOpponent = FlxTween.tween(third, {y: third.y - 50}, .1);
							default:
								third.animation.play('cool');
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
			case 'card':
				switch (curAnim)
				{
					case 'batteryWarn':
						triggerWarn(curAnim);
					default:
						skipDialogue = true;
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

	function triggerWarn(curCard:String):Void
		{
			canContinue = false;
			inCard = true;

			card = new FlxSprite().loadGraphic(Paths.image('dialogue/cards/' + curCard));
			card.screenCenter();
			

			var continueTxt:FlxText = new FlxText(700, 645, FlxG.width, 'Press any button to continue', 36);
			continueTxt.alpha = 0;
			continueTxt.setFormat(Paths.font("CookieRun Bold.ttf"), 36, FlxColor.fromRGB(178, 255, 255), LEFT);
			

			
			var black:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			black.screenCenter();
			black.alpha = 1;
			add(card);
			add(continueTxt);
			add(black);

			new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					new FlxTimer().start(0.01, function(tmr:FlxTimer)
						{
							black.alpha -= 0.02;
				
							if (black.alpha > 0)
							{
								tmr.reset(0.01);
							}
							else
							{
								remove(black);
		
								new FlxTimer().start(1, function(tmr:FlxTimer)
									{
										canContinue = true;
										FlxTween.tween(continueTxt, {alpha:1}, 2);
									});
							}
						});
				});

		}
}
