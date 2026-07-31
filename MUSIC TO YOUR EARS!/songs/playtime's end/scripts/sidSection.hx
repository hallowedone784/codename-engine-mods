var camHUDX:Int;
function create() camHUDX = camHUD.x;
function beatHit(curBeat:Int) {
    if (curBeat >= 336 && curBeat < 400) {
        if (curBeat % 2 == 0) {
            FlxTween.tween(camHUD, {x: camHUDX + 50}, 0.4, {ease: FlxEase.cubeOut});
        } else {
            FlxTween.tween(camHUD, {x: camHUDX - 50}, 0.4, {ease: FlxEase.cubeOut});
        }
    }
    if (curBeat == 400) FlxTween.tween(camHUD, {x: camHUDX}, 0.4, {ease: FlxEase.cubeOut});
}