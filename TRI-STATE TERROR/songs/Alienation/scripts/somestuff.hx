var vignette:CustomShader = new CustomShader("vignette");
function create() {
    vignette.intensity = 0;
    vignette.vignetteColor = [0, 0, 0];
    camGame.addShader(vignette);
}
function beatHit(curBeat:Int) {
    switch (curBeat) {
        case 64, 80:
            vignette.intensity = 1.75;
            for (item in [healthBar, healthBarBG, iconP1, iconP2, accuracyTxt, missesTxt, scoreTxt]) item.visible = false;
        case 76:
            FlxTween.num(2, 1.5, 0.75, {ease: FlxEase.cubeOut}, function(v:Float) {
                vignette.data.intensity.value = [v];
            }); 
        case 78:
            FlxTween.num(2.25, 1.5, 0.5, {ease: FlxEase.cubeOut}, function(v:Float) {
                vignette.data.intensity.value = [v];
            }); 
        case 92:
            FlxTween.num(2, 0, 2, {ease: FlxEase.cubeIn}, function(v:Float) {
                vignette.data.intensity.value = [v];
            }); 
    }
}

function onDadHit(event) {
    FlxG.camera.shake(0.01, 0.01);
}
function onPlayerHit(event) {
    FlxG.camera.shake(0.007, 0.007);
}