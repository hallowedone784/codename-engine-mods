// code for corrupted phineas mechanic
// also code for lil' thing during textOnScreen section
var lastX:Int = null;
var curArrow:FlxSprite;
var startArrowY:Int;

function create() {
	curArrow = new FlxSprite();
    curArrow.frames = Paths.getSparrowAtlas("game/notes/test1");

    curArrow.animation.addByPrefix("left", "arrowLEFT", 0, false);
    curArrow.animation.addByPrefix("down", "arrowDOWN", 0, false);
    curArrow.animation.addByPrefix("up", "arrowUP", 0, false);
    curArrow.animation.addByPrefix("right", "arrowRIGHT", 0, false);

	curArrow.scale.set(0.75, 0.75);
	curArrow.updateHitbox();

    curArrow.antialiasing = false;
    curArrow.color = FlxColor.WHITE;
    curArrow.alpha = 0;
    add(curArrow);
}

function onDadHit(event) {
    if (health > 0.01) health -= 0.01; 
    if (event.noteType == "glitch") {
        event.shader = evilpibby;
        // add code so isabella misses the note and it fades away, but she hits the pose anyhow
    }

    // credits for this event to ksi terror
	if (curMeasure >= 190 && curMeasure < 207) {
		// camera shake & note shake
		FlxG.camera.shake(0.007, 0.05);
		if (!event.note.isSustainNote) {
			for (e in ferbStrums.members) {
				if (lastX == null)
					lastX = FlxG.random.float(50, FlxG.height - 200);
				else
					lastX += FlxG.random.int(60, 150);
				FlxTween.tween(e, {x: lastX}, 0.1, {ease: FlxEase.circInOut});
				/* don't enable this if you want your chart to be fair
				this is such a goofy ass mechanic lmfao
				dave and bambi ass chart
				FlxTween.tween(e, {angle: FlxG.random.int(-45, 45)}, 0.1, {ease: FlxEase.circInOut});
				*/
			}
			lastX = null;
			
			// theoretically this should be working but it just isnt
			// literally only because the angles are off. i need to fix the angle logic somehow
			// can i somehow make it so that the notes always come up from directly under the receptor regardless of its angle
		}

		curArrow.alpha = 0.5;
		curArrow.x = corruptedPhineas.x + 10;
		curArrow.y = corruptedPhineas.y + 100;
		switch (event.note.noteData) {
			case 0:
				curArrow.animation.play("right", true);
				curArrow.color = 0xFFFF7CFF;
			case 1:
				curArrow.animation.play("down", true);
				curArrow.color = 0xFF00FFFF;
			case 2:
				curArrow.animation.play("up", true);
				curArrow.color = 0xFF78FF78;
			case 3:
				curArrow.animation.play("left", true);
				curArrow.color = 0xFFFF6464;            
		}

		FlxTween.cancelTweensOf(curArrow);
		FlxTween.tween(curArrow, {alpha: 0}, 1, {ease: FlxEase.cubeOut});
	}	
}

function stepHit(curStep:Int) {
	switch (curStep) {
		// when text section starts up
		case 2384:
			ferbStrums.forEach(function(spr:FlxSprite) {
				startArrowY = spr.y;
				FlxTween.tween(spr, {alpha: 0}, (Conductor.crochet/1000)*1.5, {
					ease: FlxEase.cubeOut});
		});
		
		case 2392:
			// ferbStrums.cpu = true;
			FlxTween.tween(ferbStrums.members[2], {alpha: 1}, (Conductor.crochet/1000)*2, {ease: FlxEase.cubeOut});
		case 2394:
			FlxTween.tween(ferbStrums.members[3], {alpha: 1}, (Conductor.crochet/1000)*2, {ease: FlxEase.cubeOut});
		case 2397:
			FlxTween.tween(ferbStrums.members[1], {alpha: 1}, (Conductor.crochet/1000)*2, {ease: FlxEase.cubeOut});
		case 2400:
			FlxTween.tween(ferbStrums.members[0], {alpha: 1}, (Conductor.crochet/1000)*2, {ease: FlxEase.cubeOut});
			// ferbStrums.cpu = false;

		// redo this later so instead of just disappearing, they fall off screen like earlier along with the icons
		// in other words, PLACEHOLDER
		case 3568:
			FlxTween.tween(ferbStrums.members[1], {alpha: 0}, (Conductor.crochet/1000)*2, {ease: FlxEase.cubeOut});
		case 3571:
			FlxTween.tween(ferbStrums.members[0], {alpha: 0}, (Conductor.crochet/1000)*2, {ease: FlxEase.cubeOut});
		case 3574:
			FlxTween.tween(ferbStrums.members[2], {alpha: 0}, (Conductor.crochet/1000)*2, {ease: FlxEase.cubeOut});
		case 3576:
			FlxTween.tween(ferbStrums.members[3], {alpha: 0}, (Conductor.crochet/1000)*7.5, {ease: FlxEase.cubeOut});
	}
}