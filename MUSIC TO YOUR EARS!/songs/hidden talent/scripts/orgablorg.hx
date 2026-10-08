// TODO:
// Add spotlight function (separate script) and calls here
// Add screenDim script and calls here

function create() {
    // Character stuff
    var stageChars = [bf, dad];
    for (char in stageChars) {
        char.scale.set(0.7, 0.7);
        char.color = FlxColor.BLACK;
    }
    bf.x = 950;
    dad.y = 150;


    // Stage stuff
    backgroundDim = new FlxSprite(-500, 0).makeGraphic(FlxG.width*4, FlxG.height*5, FlxColor.BLACK);
    backgroundDim.alpha = 0.8;
    backgroundDim.cameras = [camGame];
    insert(members.indexOf(bf) - 1, backgroundDim);

}

function postCreate() {
    var uiStuff = [healthBar, healthBarBG, iconP1, iconP2, accuracyTxt, scoreTxt, missesTxt];
    for (stuff in uiStuff) stuff?.alpha = 0;
}

function onCountdown(event) {
    event.cancelled = true;
}

function measureHit(curMeasure:Int) {
    switch (curMeasure) {
        case 3:
            bf.color = 0x00FFFFFF; // FlxColor.TRANSPARENT isn't mapped to the proper color
            // Cue in spotlight here
            // First time using blendmodes
            // callSpotlight(bf, .65, false, -125); Don't like the spotlight atm, fix later
    }
}