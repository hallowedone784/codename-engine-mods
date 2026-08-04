// all code written by @orgablorg
// strums and all that
public var isabellaStrums = strumLines.members[0];
public var isabella = isabellaStrums.characters[0];
public var phineasStrums = strumLines.members[1];
public var phineas = phineasStrums.characters[0];
public var corruptedPhineas = phineasStrums.characters[1];
public var ferbStrums = strumLines.members[2];
public var ferb = ferbStrums.characters[0];

var iconP3:HealthIcon;
// simple darkening effects
public var backgroundDim:FlxSprite;
public var darkScreen:FlxSprite;
// why is everything above here public
// NOTE: static seems to do the same thing as public, use that for future reference since public doesn't do much here

// shaders
var vignette:CustomShader = new CustomShader("vignette");
var glitchShader:CustomShader = new CustomShader("pibbyNotes");

// PauseSubState.script = 'data/scripts/pause'; // invokes custom pause menu

function create() {
    // preload the splash
    var splashPath = Paths.image("game/splashes/test1_splash");
    FlxG.bitmap.add(splashPath);

    // other stuff
    ferb.alpha = 0;
    ferbStrums.visible = false;

    backgroundDim = new FlxSprite(-500, 0).makeSolid(FlxG.width*4, FlxG.height*5, FlxColor.BLACK);
    backgroundDim.alpha = 0;
    backgroundDim.cameras = [camGame];
    insert(members.indexOf(isabella), backgroundDim);

    darkScreen = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
    darkScreen.alpha = 1;
    darkScreen.cameras = [camHUD];
    add(darkScreen);

    // shader stuff
    vignette.intensity = 0;
    vignette.vignetteColor = [0, 0, 0];
    camGame.addShader(vignette);
}

function onCountdown(event) {
    event.cancelled = true;
}
function postCreate() {
    playerStrums.forEach(function(arrow:FlxSprite) {FlxTween.globalManager.cancelTweensOf(arrow);});
    playerStrums.forEach(function(arrow:FlxSprite) {arrow.alpha = 0;});
    
    healthBar.alpha = 0;
    healthBarBG.alpha = 0;
    iconP1.alpha = 0;
    iconP2.alpha = 0;

    iconP3 = new HealthIcon("ferb", false);
    iconP3.cameras = [camHUD];
    iconP3.alpha = 0;
    iconP3.y = iconP1.y - 100;
    iconP3.scale.set(1, 1);
    insert(members.indexOf(iconP2) - 1, iconP3);

}

function postUpdate(elapsed:Float) {
    // ferb position logic before phineas dies
    if (curBeat < 496) {
        iconP3.x = iconP1.x + 50;
    }
    // endgame health logic
    if (curMeasure >= 191) {
        iconP1.setPosition(FlxG.width - iconP1.width - 20, FlxG.height - iconP1.height - 20);
        iconP2.setPosition(20, FlxG.height - iconP2.height - 20);
        if (iconP3 != null) {
            iconP3.setPosition(iconP2.x + 75, FlxG.height - iconP3.height - 30);
        }
    }

    // icon lerp logic
    // redo this later, to be the same as the CNE lerp logic
    var lerpVal:Float = 0;
    for (i in [inst, vocals]) {
        lerpVal = Math.max(lerpVal, FlxMath.bound((elapsed * 9 * i.pitch), 0, 1));
    }
    if (iconP3 != null && iconP3.alpha > 0) {
        iconP3.scale.set(lerp(iconP3.scale.x, 0.8, lerpVal), lerp(iconP3.scale.y, 0.8, lerpVal));
    }

    
}

function beatHit(curBeat:Int) {
    if (iconP3 != null && iconP3.alpha > 0) {
        iconP3.scale.set(1.2, 1.2); // used for icon lerp logic
    }

    switch (curBeat) {
        // angelic section
        case 256:
             remove(darkScreen);
             insert(2, darkScreen);
             FlxTween.tween(darkScreen, {alpha: 1}, Conductor.crochet/1000, {ease: FlxEase.cubeOut});
        case 258:
            darkScreen.alpha = 0;
            vignette.vignetteColor = [1, 0.07, 0.57];
            FlxTween.num(1.5, 0, 1, {ease: FlxEase.cubeOut}, function(v:Float) {
                vignette.data.intensity.value = [v];
            });
        case 262: 
            FlxTween.tween(darkScreen, {alpha: 1}, Conductor.crochet/1000, {ease: FlxEase.cubeOut});
        case 266: 
            darkScreen.alpha = 0;
            vignette.vignetteColor = [1, 0.27, 0.0];
            FlxTween.num(1.5, 0, 1, {ease: FlxEase.cubeOut}, function(v:Float) {
                vignette.data.intensity.value = [v];
            });
        case 270: FlxTween.tween(darkScreen, {alpha: 1}, Conductor.crochet/1000, {ease: FlxEase.cubeOut});
        case 274: 
            darkScreen.alpha = 0;
            vignette.intensity = 0;


        // phineas shows up
        case 426:
            FlxTween.tween(iconP3, {alpha: 1, y: iconP1.y}, (Conductor.crochet/1000)*3, {ease: FlxEase.cubeOut}); // im a filthy cubeOut abuser


        // phineas dies
        case 490:
            FlxTween.tween(darkScreen, {alpha: 1}, (Conductor.crochet/1000)*6, {ease: FlxEase.cubeOut, onComplete:
            function(twn:FlxTween) {
                ferb.alpha = 0;
                ferb.color = FlxColor.GREEN;
                ferb.colorTransform.greenOffset = 255;

                isabella.alpha = 0;
                isabella.color = FlxColor.PINK;
                isabella.colorTransform.redOffset = 255;
                isabella.colorTransform.greenOffset = 0;
                isabella.colorTransform.blueOffset = 255;
            }});
        case 500:
            // make isabella's notes invisible
            darkScreen.alpha = 0;
            backgroundDim.alpha = 1;
        case 516:
            FlxTween.tween(isabella, {alpha: 1}, (Conductor.crochet/1000)*20, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween) {
                FlxTween.tween(ferb, {alpha: 1}, (Conductor.crochet/1000)*13, {ease: FlxEase.cubeOut});
            }});
        case 532: 
            backgroundDim.alpha = 0;
            resetColor(isabella);
            resetColor(ferb);
    }
}

// for less specific stuff
function measureHit(curMeasure:Int) {
    switch (curMeasure) {
        case 1:
            FlxTween.tween(darkScreen, {alpha: 0}, (Conductor.crochet/1000)*9, {ease: FlxEase.cubeOut});
            corruptedPhineas.visible = false;
        case 8:
            healthFade(1, 0.25);
        case 10:
            loadAsset("arrows");
        case 24:
            FlxTween.tween(darkScreen, {alpha: 1}, (Conductor.crochet/1000)*3.75, {ease: FlxEase.cubeOut});
        case 26:
            darkScreen?.alpha = 0;
        case 106:
            FlxTween.tween(ferb, {alpha: 1}, (Conductor.crochet/1000)*3, {ease: FlxEase.cubeOut});
        case 107:
            ferbStrums.cpu = true;
        case 125:
            ferbStrums.visible = true;
            ferbStrums.cpu = false;
            ferb.y = phineas.y - 350;
            phineasStrums.visible = false;
            phineas.visible = false;

            // replace icon & healthbar
            // i can probably make this a function but i don't think it'll matter for our first build
            // and i can always change my mind later
            iconP1.setIcon("ferb");
            iconP1.flipX = true;
            iconP3.alpha = 0;

            healthBar.createFilledBar(isabella.iconColor, 0xFF63CC6D); // stand in for ferb's icon color 0xFF63CC6D
            healthBar.updateBar();
        case 190:
            // change this later so it just overlays isabella's notes instead
            phineasStrums.forEach(function(spr:FlxSprite) {
                var noteSpacing:Float = 90;
                var targetX:Float = (FlxG.width/2) - (noteSpacing * 2) + (spr.ID * noteSpacing);
                FlxTween.tween(spr, {x: targetX}, (Conductor.crochet/1000)*3, {ease: FlxEase.quadInOut});
            });
            phineasStrums.cpu = true;

            // now have phineas show up on opponent side
            // make it more stylish later (FIX THE CODE? idk if i need to)
            remove(corruptedPhineas);
            insert(99, corruptedPhineas);
            corruptedPhineas.visible = true;
            corruptedPhineas.x = isabella.x - 200;
            corruptedPhineas.scale.x = -phineas.scale.x;
            corruptedPhineas.y = isabella.y + 175;

            // maybe have the health icons tween down offscreen and then up where they'll be staying?
            healthFade(0, 1, true);

            // cool idea i have where strumlines tween to the middle
            ferbStrums.forEach(function(spr:FlxSprite) {
                var noteSpacing:Float = 112;
                var targetX:Float = (FlxG.width/2) - (noteSpacing * 2) + (spr.ID * noteSpacing);
                FlxTween.tween(spr, {x: targetX}, (Conductor.crochet/1000)*2.4, {ease: FlxEase.quadInOut});
            });

        case 191:
            FlxTween.num(2, 1.1, (Conductor.crochet/1000)*4.5, {ease: FlxEase.cubeOut}, function(v:Float) {
                vignette.data.intensity.value = [v];
            });
            vignette.vignetteColor = [1, 0, 0];
            iconP3.setIcon("phineascorrupted");
            iconP3.alpha = 1;

        // post phineas introduction
        case 207:
            vignette.vignetteColor = [0, 0, 0];
            FlxTween.tween(isabella, {alpha: 0.7}, (Conductor.crochet)*1.5, {ease: FlxEase.cubeOut});

            // they tween back
            ferbStrums.forEach(function(spr:FlxSprite) {
                var noteSpacing:Float = 112;
                var targetX:Float = (FlxG.width - 275) - (noteSpacing * 2) + (spr.ID * noteSpacing);
                FlxTween.tween(spr, {x: targetX}, 1, {ease: FlxEase.quadInOut});
            });

        // fix timings below, they don't work with Conductor.crochet
        case 211:
            FlxTween.tween(corruptedPhineas, {alpha: 0.7}, 0.5, {ease: FlxEase.cubeOut});
            FlxTween.tween(isabella, {alpha: 1}, 0.5, {ease: FlxEase.cubeOut});
        case 215:
            FlxTween.tween(isabella, {alpha: 0.7}, 0.5, {ease: FlxEase.cubeOut});
            FlxTween.tween(corruptedPhineas, {alpha: 1}, 0.5, {ease: FlxEase.cubeOut});
        case 219:
            FlxTween.tween(corruptedPhineas, {alpha: 0.7}, 0.5, {ease: FlxEase.cubeOut});
            FlxTween.tween(isabella, {alpha: 1}, 0.5, {ease: FlxEase.cubeOut});
        case 223:
            corruptedPhineas.alpha = 1;
            isabella.alpha = 1;
    // add in a section eventually so that the health icons slide down a little bit after the cinematic bars
    }
    if (curMeasure >= 192 && curMeasure < 207) {
        // Conductor.crochet() doesn't work here either
        FlxTween.num(1.4, 0.9, 0.75, {ease: FlxEase.sineOut}, function(v:Float) {
            vignette.data.intensity.value = [v];
        });
        noteSpazzing = true;
    } else noteSpazzing = false;
}

public function cameraFocus(focus:String, ?time:Float)
{
    if (time == null) time = (Conductor.crochet/1000)*4.5;
    switch (focus) {
        case "isabella":
            FlxTween.tween(backgroundDim, {alpha: 0.75}, time, {ease: FlxEase.circOut});
            FlxTween.tween(isabella, {alpha: 1}, time, {ease: FlxEase.circOut});
            FlxTween.tween(phineas, {alpha: 0.25}, time, {ease: FlxEase.circOut});
            // trace("isabella case triggered.");
        case "phineas":
            FlxTween.tween(backgroundDim, {alpha: 0.75}, time, {ease: FlxEase.circOut});
            FlxTween.tween(isabella, {alpha: 0.25}, time, {ease: FlxEase.circOut});
            FlxTween.tween(phineas, {alpha: 1}, time, {ease: FlxEase.circOut});
            // trace("phineas case triggered.");
        default: // won't run for some reason
            FlxTween.tween(backgroundDim, {alpha: 0}, 0.5, {ease: FlxEase.circOut});
            FlxTween.tween(isabella, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
            FlxTween.tween(phineas, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
            // trace("default case triggered.");
    }
    // trace("cameraFocus triggered.");
}

private function healthFade(fade:Float, ?time:Float, ?end:Bool) {
    if (time == null) time = (Conductor.crochet/1000)*3;
    if (end == null) end = false;
    
    FlxTween.tween(healthBar, {alpha: fade}, time, {ease: FlxEase.cubeOut});
    FlxTween.tween(healthBarBG, {alpha: fade}, time, {ease: FlxEase.cubeOut});
    FlxTween.tween(scoreTxt, {alpha: fade}, time, {ease: FlxEase.cubeOut});
    FlxTween.tween(missesTxt, {alpha: fade}, time, {ease: FlxEase.cubeOut});
    FlxTween.tween(accuracyTxt, {alpha: fade}, time, {ease: FlxEase.cubeOut});
    
    if (!end) {
        FlxTween.tween(iconP1, {alpha: fade}, time, {ease: FlxEase.cubeOut});
        FlxTween.tween(iconP2, {alpha: fade}, time, {ease: FlxEase.cubeOut});
    }
}

private function resetColor(char)  {
    char.color = FlxColor.WHITE;
    char.colorTransform.redOffset = 0;
    char.colorTransform.blueOffset = 0;
    char.colorTransform.greenOffset = 0;
}

// load in stuff
private function loadAsset(asset:String) {
    switch (asset) {
        case "arrows":
            playerStrums.forEach(function(arrow:FlxSprite) {
                // fix timings to use Conductor.crochet() at some point, using it rn breaks them for some reason
                var i:Int = playerStrums.members.indexOf(arrow);
                FlxTween.tween(arrow, {alpha: 1}, 1.5, {ease: FlxEase.linear, startDelay:i*0.2});
                FlxTween.tween(arrow, {y: arrow.y + 100}, 1.5, {ease: FlxEase.cubeOut, startDelay:i*0.2});
            });
        case "healthbar":
            return;
            // add code for healthbar here later  
    }
}
/* 7/1
gonna take a break from coding willow. i don't have any new assets to work off of
plus i want to focus on more personal hobbies like drawing and writing
UPDATED TODO:
- find every single numeric insert command in the code and fix it so it runs off of members.indexOf() instead
- update splitscreen code for this mod so it has a border, more tweening options (just gonna remake the event, probably), an angle option, and a one-sided option
- fix afterimage code so it works properly and afterimages have colors
- redo the icon lerping for iconP3 so it matches iconP1 and iconP2
- get rid of isabella's notes after phineas's little section
- code in more shaders, such as bloom shader, contrast shader, MAYBE chromatic aberration? etc
    > implement glitch shader for isabella's icon (i think?) and glitch notes -> also implement missing mechanic for glitch notes
    > implement shadow shader
    > implement bloom shader

QUICK TODOS:
- add little transitions of notes rotating and falling while they fade to black in that one section, have the rotation be random
- change notes sliding to middle to happen earlier in the song, probably around the part where the camera moves to the middle in the isabella and ferb duet.
- also redo the camera events for that section [WIP as of 7/24]
- make each receptor invisible after their last use for the ending part
*/