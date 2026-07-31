import flixel.addons.effects.FlxTrail;
import flixel.util.FlxTimer;

private var screenDark:FlxSprite;
public var elmo = strumLines.members[0].characters[0];
var bigElmo = strumLines.members[0].characters[1];
var bird = strumLines.members[1].characters[0];
var sid = strumLines.members[2].characters[0];
var oscar = strumLines.members[3].characters[0];
var snuffy = strumLines.members[4].characters[0];
var bert = strumLines.members[5].characters[0];
var ernie = strumLines.members[6].characters[0];

// trails
var elmoTrail:FlxTrail;
var birdTrail:FlxTrail;
var trailTimer:FlxTimer;

// custom countdown code
var allowCountdown:Bool = false;
function onCountdown(event) {
    if (!allowCountdown) {
        event.cancelled = true;
    }
}


function create() {
    // Character positioning code
    elmo.x = 1000;
    elmo.y = 1450;
    elmo.alpha = 0;

    bigElmo.x = elmo.x - 100;
    bigElmo.y = elmo.y - 250;
    bigElmo.alpha = 0;
    remove(bigElmo);
    insert(members.indexOf(elmo), bigElmo);

    bird.y = 1500;
    bird.alpha = 0;

    sid.x = 250;
    sid.y = 1500;
    sid.alpha = 0;

    oscar.x = 750;
    oscar.y = 1260;
    oscar.alpha = 0;
    remove(oscar);
    insert(members.indexOf(elmo) - 1, oscar);
    
    snuffy.x = 1200;
    snuffy.y = 1500;
    remove(snuffy);
    insert(members.indexOf(elmo) - 1, snuffy);

    bert.x = 2500;
    bert.y = 750;
    remove(bert);
    insert(members.indexOf(bird) - 1, bert);
    bert.scale.set(0.3, 0.3);
    bert.updateHitbox();

    ernie.x = 2500;
    ernie.y = 1450;
    remove(ernie);
    insert(members.indexOf(bird) + 1, ernie);
    ernie.scale.set(0.45, 0.45);
    ernie.updateHitbox();


    ernie.alpha = 0;
    bert.alpha = 0;

    // Make NPC notes disappear
    // cookie monster
    strumLines.members[2].visible = false;
    strumLines.members[2].forEach(function(i) {i.alpha = 0;});

    // oscar
    strumLines.members[3].visible = false;
    strumLines.members[3].forEach(function(i) {i.alpha = 0;});

    // snuffy
    /*
    strumLines.members[4].visible = false;
    strumLines.members[4].forEach(function(i) {i.alpha = 0;});
    */
    

    // bert & ernie
    strumLines.members[5].visible = false;
    strumLines.members[5].forEach(function(i) {i.alpha = 0;});

    strumLines.members[6].visible = false;
    strumLines.members[6].forEach(function(i) {i.alpha = 0;});

    // intro segment thing
    screenDark = new FlxSprite(0, 0).makeGraphic(FlxG.width*4, FlxG.height*5, FlxColor.BLACK);
    screenDark.alpha = 1;
    screenDark.cameras = [camGame];
    insert(members.indexOf(elmo) - 1, screenDark);
}


function beatHit(curBeat:Int) {
    switch (curBeat) {
        case 0:
            elmo.color = FlxColor.RED;
            elmo.colorTransform.redOffset = 255;
            FlxTween.tween(elmo, {alpha: 1}, 5, {ease: FlxEase.cubeOut});

        case 16:
            bird.color = FlxColor.YELLOW;
            bird.colorTransform.redOffset = 255;
            bird.colorTransform.greenOffset = 255;
            FlxTween.tween(bird, {alpha: 1}, 5, {ease: FlxEase.cubeOut});
        
        case 28:
            allowCountdown = true;
            startCountdown(); // this works

        case 32:
            screenDark.alpha = 0;
            // Reset elmo and bird
            resetColor(elmo);
            resetColor(bird);

            // Slide in CM and fade him in
            FlxTween.tween(sid, {alpha: 1}, 2, {ease: FlxEase.cubeOut});
            FlxTween.tween(sid, {x: 650}, 2, {ease: FlxEase.cubeOut});

            // Setup CM notes
            var sidStrums = strumLines.members[2];
            moveStrums(sidStrums, sid, 550, 25);

        case 40:
            FlxTween.tween(oscar, {alpha: 1}, 2, {ease: FlxEase.cubeOut});
            FlxTween.tween(oscar, {x: 1150}, 2, {ease: FlxEase.cubeOut});

            var oscarStrums = strumLines.members[3];
            moveStrums(oscarStrums, oscar, 1000, 150);

        case 272:
            insert(members.indexOf(elmo) - 1, screenDark);
            remove(sid);
            insert(members.indexOf(oscar), sid);
            FlxTween.tween(screenDark, {alpha: 0.75}, 1.5, {ease: FlxEase.cubeOut});
            FlxTween.tween(oscar, {x: 1050}, 1.5, {ease: FlxEase.cubeOut});
            FlxTween.tween(sid, {x: 550}, 1.5, {ease: FlxEase.cubeOut});
            FlxTween.tween(elmo, {x: 1150}, 1.5, {ease: FlxEase.cubeOut});

        case 336:
            screenDark.alpha = 0;

        // end of cm section
        case 398:
            insert(members.indexOf(elmo) + 1, screenDark);
            FlxTween.tween(elmo, {alpha: 0}, 0.5, {ease: FlxEase.cubeOut});
            FlxTween.tween(bird, {alpha: 0}, 0.5, {ease: FlxEase.cubeOut});
            FlxTween.tween(screenDark, {alpha: 1}, 0.5, {ease: FlxEase.cubeOut});

        case 400:
            elmo.alpha = 1;
            bird.alpha = 1;
            screenDark.alpha = 0;

        /*
        section where snuffy dies
        i'm so glad that i know how to clean up code more and more each time i do it because this
        this is a lot of code
        */

        case 528:
            insert(members.indexOf(elmo) - 1, screenDark);
            FlxTween.tween(screenDark, {alpha: 0.75}, 1.5, {ease: FlxEase.cubeOut});
            strumLines.members[2].forEach(function(i) {i.alpha = 0;});
            strumLines.members[3].forEach(function(i) {i.alpha = 0;});

        case 530:
            FlxTween.tween(oscar, {x: oscar.x - 1000}, 3, {ease: FlxEase.cubeIn});
            FlxTween.tween(sid, {x: sid.x - 1000}, 3, {ease: FlxEase.cubeIn});
            
        case 534:
            FlxTween.tween(elmo, {x: elmo.x + 500}, 2.5, {ease: FlxEase.cubeOut});

        case 560:
            // cm positioning
            sid.scale.x = -sid.scale.x;
            sid.y = snuffy.y - 400;
            sid.x = bird.x + 500;
            FlxTween.tween(sid, {x: snuffy.x + 1500}, 2.5, {ease: FlxEase.cubeOut});
            sid.updateHitbox();

        case 564:
            // oscar positioning
            oscar.y = snuffy.y - 400;
            FlxTween.tween(oscar, {x: snuffy.x - 200}, 2.5, {ease: FlxEase.cubeOut});

        case 568:
            FlxTween.tween(sid, {x: snuffy.x + 1000}, 2.5, {ease: FlxEase.cubeOut});
        case 572:
            FlxTween.tween(oscar, {x: snuffy.x + 50}, 2.5, {ease: FlxEase.cubeOut});

        case 590:
            FlxTween.tween(sid, {x: snuffy.x + 450}, 1.5, {ease: FlxEase.backIn});
            FlxTween.tween(oscar, {x: snuffy.x + 450}, 1.5, {ease: FlxEase.backIn});

        case 592:
            remove(screenDark);
            insert(members.indexOf(bird) + 1, screenDark);
            FlxTween.tween(screenDark, {alpha: 1}, 1.5, {ease: FlxEase.cubeOut});


        case 596:
            elmo.alpha = 0;
            bird.alpha = 0;
            remove(screenDark);
            insert(members.indexOf(elmo) - 1, screenDark);
            // tween in big bird, all yellow like at the beginning
            bird.color = FlxColor.YELLOW;
            bird.colorTransform.redOffset = 255;
            bird.colorTransform.greenOffset = 255;
            FlxTween.tween(bird, {alpha: 1}, 5, {ease: FlxEase.cubeOut});

            // since the logic down there is kinda iffy
            strumLines.members[1].forEach(function(receptor) {receptor.alpha = 1;}); 
            strumLines.members[4].forEach(function(receptor) {receptor.alpha = 1;});

            // also move over snuffy's notes
            strumLines.members[4].forEach(function(spr:FlxSprite) {
                var noteSpacing:Float = 90;
                var targetX:Float = (FlxG.width/2) - (noteSpacing * 2) + (spr.ID * noteSpacing);
                FlxTween.tween(spr, {x: targetX}, 1.5, {ease: FlxEase.quadInOut});
            });
            strumLines.members[4].cpu = true;
        
        case 608:
            // tween in snuffy, white
            snuffy.alpha = 0;
            remove(snuffy);
            insert(members.indexOf(screenDark) + 1, snuffy);
            FlxTween.tween(snuffy, {alpha: 1}, 1.5, {ease: FlxEase.cubeOut});
            snuffy.color = FlxColor.WHITE;
            snuffy.colorTransform.redOffset = 255;
            snuffy.colorTransform.greenOffset = 255;
            snuffy.colorTransform.blueOffset = 255;


        // after he killed snuffy
        case 616:
            // fix trio
            elmo.x = 1100;
            sid.x = 650;
            sid.y = 1500;
            sid.scale.x = -sid.scale.x;
            sid.updateHitbox();
            oscar.x = 1150;
            oscar.y = 1260; 


            // tween in elmo, red, and afterwards bigElmo, also red
            elmo.color = FlxColor.RED;
            elmo.colorTransform.redOffset = 255;
            FlxTween.tween(elmo, {alpha: 1}, 1.5, {
                ease: FlxEase.sineIn,
                onComplete: function(twn:FlxTween) {
                    bigElmo.color = FlxColor.RED;
                    bigElmo.colorTransform.redOffset = 255;
                    FlxTween.tween(bigElmo, {alpha: 0.25}, 1.5, {ease: FlxEase.sineIn});
                }});

        case 620:
            FlxTween.tween(snuffy, {alpha: 0}, 1.5, {ease: FlxEase.cubeOut});
        case 624:
            strumLines.members[2].forEach(function(i) {i.alpha = 1;});
            strumLines.members[3].forEach(function(i) {i.alpha = 1;});

            resetColor(bird);
            resetColor(elmo);
            bigElmo.colorTransform.redOffset = 0;
            remove(screenDark); // since screenDark isn't needed anymore
            bigElmo.alpha = 0.3;
            bigElmo.color = FlxColor.RED;
            strumLines.members[4].visible = false;
            player.cpu = false;

        case 635:
            FlxTween.tween(elmo, {x: bird.x - 750}, 2, {ease: FlxEase.cubeIn});

        case 639:
            // Setup Bert notes
            var bertStrums = strumLines.members[5];
            moveStrums(bertStrums, bert, 1650, -bert.y + 200);
            FlxTween.tween(bert, {alpha: 1}, 1.5, {ease: FlxEase.cubeOut});
            FlxTween.tween(bert, {x: 1600}, 1, {ease: FlxEase.cubeOut, onComplete: function(twn:FlxTween) {
            FlxTween.tween(bird, {x: bird.x + 100}, 1, {ease: FlxEase.cubeOut});
            }});
            

        case 640:
            FlxTween.tween(elmo, {x: 1000}, 1, {ease: FlxEase.cubeOut});
            FlxTween.tween(bigElmo, {alpha: 0}, 2, {ease: FlxEase.backOut});

        case 647:
            var ernieStrums = strumLines.members[6];
            moveStrums(ernieStrums, ernie, 1650, -800);
            FlxTween.tween(ernie, {alpha: 1}, 1.5, {ease: FlxEase.cubeOut});
            FlxTween.tween(ernie, {x: 1850}, 1, {ease: FlxEase.cubeOut});

        case 658:
            FlxTween.tween(elmo, {x: bird.x - 1600}, 0.5, {ease: FlxEase.cubeOut});
        case 659:
            FlxTween.tween(elmo, {x: bird.x - 1200}, 0.5, {ease: FlxEase.cubeOut});

        case 660:
            FlxTween.tween(elmo, {x: 1000}, 1, {ease: FlxEase.circOut});

        case 720:
            remove(screenDark);
            screenDark.cameras = [camHUD];
            add(screenDark);
            screenDark.alpha = 1;
            

    }
}

function resetColor(char)  {
    char.color = FlxColor.WHITE;
    char.colorTransform.redOffset = 0;
    char.colorTransform.blueOffset = 0;
    char.colorTransform.greenOffset = 0;
}


function moveStrums(charStrums, char, xOffset, yOffset) {
    charStrums.visible = true;
    charStrums.cameras = [camGame];

    for (i in charStrums) {
        i.scrollFactor.set(1,1);
        i.x = i.x + xOffset;
        i.y = char.y - yOffset;
        i.alpha = 1;
    }

}

// Make NPC notes invisible
function postUpdate(Elapsed:Float) {
    strumLines.members[2].notes.forEach(function(note) {note.alpha = 0;});
    strumLines.members[3].notes.forEach(function(note) {note.alpha = 0;});
    strumLines.members[5].notes.forEach(function(note) {note.alpha = 0;});
    strumLines.members[6].notes.forEach(function(note) {note.alpha = 0;});
}

// trail stuff
function postCreate() {
    elmoTrail = new FlxTrail(elmo, null, 4, 12, 0.6, 0.05);
    elmoTrail.visible = false;
    elmoTrail.color = FlxColor.RED;
    elmoTrail.blend = 1;
    insert(members.indexOf(elmo) - 1, elmoTrail);

    birdTrail = new FlxTrail(bird, null, 4, 24, 0.6, 0.05);
    birdTrail.visible = false;
    birdTrail.color = FlxColor.YELLOW;
    birdTrail.blend = 1;
    insert(members.indexOf(bird) - 1, birdTrail);
}

function onNoteHit(event) {
    switch (event.noteType)
    {
        case "Trail Note":
            elmoTrail.visible = true;
            elmoTrail.resetTrail();

            for (i in 0...elmoTrail.delay) {
                elmoTrail.update(0);
            }

            trailTimer?.cancel();
            trailTimer = new FlxTimer().start(0.8, function(tmr:FlxTimer) {
                elmoTrail.visible = false;
            });

        case "Bullet Note":
            FlxG.sound.play(Paths.sound("playtimesend/gunshot")); // learn how to fix volume on this before release
            trace('bullet fired!');
    }
    
    // bird and snuffy strum logic
    if (curBeat < 596) {
        for (char in event.characters) {
            if (char == bird) {
                strumLines.members[1].forEach(function(receptor) {receptor.alpha = 1;});
                strumLines.members[4].forEach(function(receptor) {receptor.alpha = 0;});
            } else if (char == snuffy) {
                strumLines.members[1].forEach(function(receptor) {receptor.alpha = 0;});
                strumLines.members[4].forEach(function(receptor) {receptor.alpha = 1;});
            }
        }
    } 
}


// stuff to fix:
// 2. Figure out how to make it so you can never see outside of the stage
// 4. Fix camera stuff
// 5. Okay the poses are fixed but later I need to use .flipX and fix them so they're normal instead

// maybe make a camera focus with offset event