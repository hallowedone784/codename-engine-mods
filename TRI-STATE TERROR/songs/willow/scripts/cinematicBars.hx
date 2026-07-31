private var topBar:FlxSprite;
private var bottomBar:FlxSprite;
private var barGroup:FlxSpriteGroup;

public function cinematicBars(distance:Int, time:Float, tweenCase:Int) {
    barGroup ??= new FlxSpriteGroup();
    barGroup.cameras = [camHUD];
    add(barGroup);


    if (topBar != null) FlxTween.cancelTweensOf(topBar);
    if (bottomBar != null) FlxTween.cancelTweensOf(bottomBar);
    FlxTween.cancelTweensOf(barGroup);

    // y = FlxG.height/2 is the maximum tweening goal
    topBar ??= new FlxSprite(-150,-FlxG.height/2).makeSolid(FlxG.width*2, FlxG.height/2, FlxColor.BLACK);
    topBar.scrollFactor.set(0,0);
    topBar.cameras = [camHUD];
    barGroup.add(topBar);
    // insert(0, topBar);

    // code for bottomBar
    // y = FlxG.height/2 is the max tweening goal
    bottomBar ??= new FlxSprite(-150,FlxG.height).makeSolid(FlxG.width*2, FlxG.height/2, FlxColor.BLACK);
    bottomBar.scrollFactor.set(0,0);
    bottomBar.cameras = [camHUD];
    barGroup.add(bottomBar);
    // insert(0, bottomBar);

    // logic to calculate distance
    var topGoal:Int = (-FlxG.height/2) + Std.parseInt(distance);
    var bottomGoal:Int = (FlxG.height) - Std.parseInt(distance);

    switch (Std.parseInt(tweenCase)) {
        case 0:
            FlxTween.tween(topBar, {y: topGoal}, time, {ease: FlxEase.backOut});
            FlxTween.tween(bottomBar, {y: bottomGoal}, time, {ease: FlxEase.backOut});
        case 1:
            FlxTween.tween(topBar, {y: topGoal}, time, {ease: FlxEase.circOut});
            FlxTween.tween(bottomBar, {y: bottomGoal}, time, {ease: FlxEase.circOut});
        case 2:
            FlxTween.tween(topBar, {y: topGoal}, time, {ease: FlxEase.expoIn});
            FlxTween.tween(bottomBar, {y: bottomGoal}, time, {ease: FlxEase.expoIn});
        /*
        case 3:
            topBar.y = distance;
            bottomBar.y = distance;
            FlxTween.tween(topBar, {alpha: transparency}, time, {ease: FlxEase.cubeOut});
            FlxTween.tween(bottomBar, {alpha: transparency}, time, {ease: FlxEase.cubeOut});
        */
        default:
            FlxTween.tween(topBar, {y: topGoal}, time, {ease: FlxEase.backOut});
            FlxTween.tween(bottomBar, {y: bottomGoal}, time, {ease: FlxEase.backOut});
    }
    /*
    tweenCases:
    0 means they tween in with backOut
    1 means they tween in with cubeOut/circOut
    2 means they tween with expoIn
    */
}

function beatHit(curBeat:Int) {
    switch (curBeat) {
        case 808:
            FlxTween.tween(barGroup, {angle: 35}, 0.4, {ease: FlxEase.cubeOut});
        case 810:
            FlxTween.tween(barGroup, {angle: 70}, 0.4, {ease: FlxEase.cubeOut});
    }
}