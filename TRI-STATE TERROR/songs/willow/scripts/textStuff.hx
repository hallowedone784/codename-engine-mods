var screenText:FlxText;
var chromaticAberration:CustomShader = new CustomShader("chromaticAberration");
function create() {
    screenText = new FlxText(FlxG.width/6, FlxG.height/3 + 50); // in the center
    // screenText.scrollFactor.set(0,0); is this needed?
    screenText.setFormat(Paths.font("adultswim.ttf"), 125, FlxColor.WHITE, "center");
    screenText.cameras = [camHUD];
    screenText.alpha = 0;
    add(screenText); // change this so it's layered in front of the cinematic bars but behind the ferbStrums as well

    chromaticAberration.intensity = 10;
    screenText.shader = chromaticAberration;
    /*
    this shader doesn't give the bloom effect i wanted, but it adds this cool effect when it fades out
    its like burn-in
    i do want to add the bloom shader eventually, though
    */
}
function beatHit(curBeat:Int) {
    // consider redoing the text placement
    switch (curBeat) {
        // fix colors
        case 756:
            screenText.y = FlxG.height/10 - 60;
            screenText.size = 45;

            screenText.alpha = 0.4;
            screenText.color = 0xF291F0;
            screenText.text = "[hi, phineas!]";
        case 758:
            // placeholder
            screenText.color = 0xDC815A;
            screenText.text = "[hey, isabella!]";
        case 760:
            // placeholder
            screenText.color = 0xF291F0;
            screenText.text = "[what'cha doin'?]";
        
        case 762:
            FlxTween.tween(screenText, {alpha: 0}, (Conductor.crochet/1000)*2, {ease: FlxEase.cubeOut});
        case 764:
            // cleanup
            screenText.alpha = 0;
    }
}

function stepHit(curStep:Int) {
    // this feels way too specific but i need it genuinely only for this part
    switch (curStep) {
        case 2392:
            screenText.alpha = 1;
            screenText.text = "[look";
        case 2394:
            screenText.text = "[look what";
        case 2397:
            screenText.text = "[look what you've]";
        case 2400:
            screenText.text = "[done]";
            screenText.screenCenter(FlxAxes.X);
            FlxTween.tween(screenText, {alpha: 0}, 0.7, {ease: FlxEase.expoIn}); // no longer works cuz of shader
    }
}
/*
jamie said that after the text, it should go middlescroll
i could probably make it so that mixes in with the splitscreen code i'm looking to implement
*/