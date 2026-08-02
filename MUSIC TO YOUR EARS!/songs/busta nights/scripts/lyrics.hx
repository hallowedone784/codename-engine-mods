// add lyrics into script (turn into module)

function marqueeLyrics(phrase:String, ?breakTime:Int, ?textSize:Int, ?font:String) // working title
{

}

function marqueeBars(distFromCenter:Int, numOfSteps:Int) // placeholder parameters, change later
{
    // figure out how to insert camera below camHUD but above camGame
    camBars:FlxCamera ??= new FlxCamera(); // not sure if this is how you initialize a camera, check refs later
    barGroup:FlxSpriteGroup ??= new FlxSpriteGroup();
    barGroup.cameras = [camBars];
    add(barGroup);

    // Cancels the tweens of the last bar movement. That way, they don't overlap.
    if (topBar != null) FlxTween.cancelTweensOf(topBar);
    if (bottomBar != null) FlxTween.cancelTweensOf(topBar);
    FlxTween.cancelTweensOf(barGroup);

    topBar:FlxSprite ??= new FlxSprite(-150, -FlxG.height/2).makeSolid(FlxG.width*2, FlxG.height/2, FlxColor.BLACK);
    topBar.scrollFactor.set(0, 0);
    topBar.cameras = [camBars];
    barGroup.add(topBar);

    bottomBar:FlxSprite ??= new FlxSprite(-150, FlxG.height).makeSolid(FlxG.width*2, FlxG.height/2, FlxColor.BLACK);
    bottomBar.scrollFactor.set(0,0);
    bottomBar.cameras = [camBars];
    barGroup.add(bottomBar);

    // Distance calculation logic
    var topGoal:Int = -FlxG.height/2 + Std.parseInt(distFromCenter);
    var bottomGoal:Int = FlxG.height - Std.parseInt(distFromCenter);
    
    // Maybe add tweening case logic later if we decide to use that?
    FlxTween.tween(topBar, {y: topGoal}, (Conductor.crochet/1000)*numOfSteps, {ease: FlxEase.circOut});
    FlxTween.tween(bottomBar, {y: bottomGoal}, (Conductor.crochet/1000)*numOfSteps, {ease: FlxEase.circOut});
}


/* lyrics:
['cause i'm feelin' like i'm runnin']
[and i'm feelin' like i gotta get away]
[get away]
[get away] (these 2 get aways get bigger each time)
[better know that i don't and i won't ever stop]
['cause you know i gotta win everyday-day]
[GO!] (secondary lyrics will be transparent or something)
[see, they really really really wanna pop me]
[BLOW!]
[just know that you will never flop me]
[and i know that i can be a little cocky]
[OOH]
[you ain't never gonna stop me]
---
[every time i come, a nigga gotta set it]
[then i gotta go, and then i gotta get it]
[WOO!]
[then i gotta blow, and then i gotta show that]
[any little thing a nigga think that he be doin']
['cause it doesn't matter, 'cause i'm gonna da-da-da-da]
[then i'm gonna murder everything and anything]
[a ba-da-boom, a ba-da-bing, i gotta do a lotta things]
[that make it clearer to a couple niggas that i always win]
[and then i gotta get it again]
[and again]
[and then again]
---
[and i be doin' it to death]
[and now i move a little foul, a nigga better call a ref]
[and everybody know my style and niggas know that i'm the best]
[when it come to doin' this and i be bangin' on my chest]
[and i bang in the east and i'm bangin' in the west]
[and i come to give you more and i will never give you less]
[you will hear it in the street or you could read it in the press]
[do you really wanna know what's next?] 
[let's go!] (secondary)
[see the way we on and then we all up in the race]
[and you know we gotta go, don't try to keep up with the pace]
[and we strugglin' and hustlin' and sendin' in and gettin']
[and we always gotta do it, take it to another place]
[gotta taste it and i gotta grab it]
[and i gotta cut all through this traffic]
[just to be at the top of the throne]
[better know i gotta have it ]
[HAVE IT!] 
*/