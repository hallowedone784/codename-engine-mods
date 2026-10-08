/*
I mean, this DOES spawn a spotlight... but it's very FNF-esque, and I want my spotlight to be more basic to fit the mood
We don't want a FNF spotlight in Hidden Talent, so I'll probably learn how to do it with shaders when I get home
*/

var beginning:Bool = true;
var bopPerStep:Bool = false;

function create() {
    spotlight = new FlxSprite(0, -60);
    spotlight.frames = Paths.getSparrowAtlas("stages/default/spotlight");
    spotlight.animation.addByPrefix("idle", "spotlight", 8, true);
    spotlight.animation.play("idle", true);
    spotlight.blend = "add";
    spotlight.alpha = 0.4;
    spotlight.visible = false;
    add(spotlight);
}

public function callSpotlight(focus:Character, scaling:Float, tweening:Bool, ?xOffset:Int, ?transparency:Float) {
    spotlight.scale.set(scaling, scaling + 0.1);
    if (tweening) {
        FlxTween.tween(spotlight, {alpha: transparency}, (Conductor.crochet/1000)*4, {ease: FlxEase.quintInOut});
    } else
        spotlight.visible = true;

    spotlight.x = focus.x + xOffset;
}
