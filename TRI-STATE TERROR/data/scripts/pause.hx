/*
Custom pause menu script for TRI-STATE TERROR
all code written by orgablorg
- custom gradients for every song
- custom art for every song to tween in
- 1/25 chance for art to tween in with invincible edit music
- custom info icon
- flashing pause icon in the top right
*/
static var curChoice:Int = 0;

var pauseArt:FlxSprite;
var buttonGroup:FlxGroup;
var pixelizationBlur:FlxSprite;
var backgroundDim:FlxSprite;
var gradient:FlxSprite;
var confirmed:Bool = false;

var buttonArray:Array<String> = ['info', 'continue', 'restart', 'options', 'exit'];

function create(event) { // something wrong with syntax for this??
    event.cancel(); // cancels normal pause menu

    var pauseCam = new FlxCamera();
    camera = pauseCam;
    pauseCam.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(pauseCam, false);

    // replace backgroundDim with pixelization blur eventually
    backgroundDim = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    backgroundDim.alpha = 0;
    backgroundDim.cameras = [pauseCam];
    add(backgroundDim);

    FlxTween.tween(backgroundDim, {alpha: 0.75}, 1, {ease: FlxEase.quadOut});

    /*
    ask arino for the pause screen overlay (the gradient on the left) and then implement following code
    gradient = new FlxSprite(-1200).loadGraphic(Paths.image("pause/overlay"));
    gradient.camera = camera;
    gradient.scrollFactor.set();
    add(gradient);
    */

    /*
    code to register buttons
    for (i in 0...buttonArray.length) {
        var buttonName = buttonArray.length[i];
        var button = new FlxSprite(-900, -20 + (i * 150)); adjust 150 later?? thats the spacing variable anyway
        button.frames = Paths.getFrames("pause/buttons/button_" + buttonName);
        button.camera = camera;
        button.scale.set = (0.6, 0.6);
        button.animation.addByPrefix("idle", "idle", 24);  
        button.animation.addByPrefix("press", "press", 24);    
        button.animation.addByPrefix("hover", "hover", 24);
        button.animation.play("idle");
        button.updateHitbox();
        buttonGroup.add(button);    
    }
    */

    /*
    code to tween art in and stuff
    FlxTween.tween(pauseArt, {x: 600}, 1, {ease: FlxEase.cubeOut});
    FlxTween.tween(gradient, {x: 0}, 1, {ease: FlxEase.cubeOut});
    FlxTween.tween(pixelizationBlur, {alpha: 0.75}, 1, {ease: FlxEase.cubeOut});

    for (button in buttonGroup.members) {
        FlxTween.tween(button, {x: -50}, 1, {ease: FlxEase.cubeOut});
    }
    */

    curChoice = 0;
    changeSelection(0);
}

function update(elapsed:Float) {
    if (controls.UP_P) {
        changeSelection(-1);
    } else if (controls.DOWN_P) {
        changeSelection(1);
    }
    
    if (controls.ACCEPT && !confirmed) {
        confirmed = true;
        confirm();
    }
}

// code to change your selection
function changeSelection(change:Int) {
    if (confirmed) return;

    buttonGroup.members[curChoice]?.animation?.play("idle");
    curChoice = FlxMath.wrap(curChoice + change, 0, buttonArray.length - 1);
    buttonGroup.members[curChoice]?.animation?.play("hover");
    FlxG.sound.play(Paths.sound("scrollPause"));
}

function confirm() {
    FlxG.sound.play(Paths.sound("chosenPause"));
    var selectedButton = buttonGroup.members[curChoice];
    selectedButton?.animation?.play("press");

    /*
    code to tween art and stuff away
    FlxTween.tween(pauseArt, {x: 1600}, 1, {ease: FlxEase.cubeIn});
    FlxTween.tween(gradient, {x: -1250}, 1, {ease: FlxEase.cubeIn});
    FlxTween.tween(backgroundDim, {alpha: 0}, 1, {ease: FlxEase.cubeIn});
    

    // reformat to forEach loop later
    for (button in buttonGroup.members) {
        FlxTween.tween(button, {x: -1250}, 1, {ease: FlxEase.cubeIn});
    }
    */

    new FlxTimer().start(1.25, function(_), {
        switch (curChoice) {
            case 0: close(); // resume
            case 1: FlxG.switchState(new PlayState()); // restart
            case 2: FlxG.switchState(new OptionsMenu((_) -> FlxG.switchState(new PlayState()))); // options
            case 3: FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState()); // exit
        }
    });
    selectedButton?.animation?.play("idle");
}