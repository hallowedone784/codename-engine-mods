// this is just an optimized version of another script someone sent me in the CNE server
// i don't fully understand the syntax myself, a lot of this was optimized just by looking at other examples
/* here's some notes though:
    => is the key value operator, used to assign keys in maps
    ?, ?? and ??= are all just null checkers, e.g. if isPlayer comes up as null, default to true for boyfriend
    a lot of this is just nested if statements

rework this soon to work with custom characters and not just the default ones
*/
var ghostData:Map<String, Dynamic> = [
    "bf"  => {ghost: null, tween: null, lastStrum: -1.0, lastData: -1},
    "dad" => {ghost: null, tween: null, lastStrum: -1.0, lastData: -1},
    "gf"  => {ghost: null, tween: null, lastStrum: -1.0, lastData: -1}
];

function postCreate() {
    var chars = [
        { key: 'bf',  orig: boyfriend, isPlayer: boyfriend?.isPlayer ?? true, color: 0xFF63CC6D},
        { key: 'dad', orig: dad,       isPlayer: dad?.isPlayer ?? false, color: FlxColor.PINK},
        { key: 'gf',  orig: gf,        isPlayer: false}
    ];

    for (c in chars) {
        if (c.orig == null) continue;

        var ghost = new Character(c.orig.x, c.orig.y, c.orig.curCharacter, c.isPlayer);
        ghost.visible = false;
        // ghost.color = c.color; figure out how to implement character colors at some point
        insert(members.indexOf(c.orig), ghost);

        ghostData.get(c.key).ghost = ghost;
    }
}

function onPlayerHit(event) if (event.note != null && curMeasure >= 133) handleHit(event);
function onDadHit(event)    if (event.note != null && curMeasure >= 133) handleHit(event);

function handleHit(event) {
    var note = event.note;
    // Determine key based on character object in event
    var key = (event.character == gf) ? 'gf' : ((event.character == boyfriend) ? 'bf' : 'dad');
    var data = ghostData.get(key);

    // Trigger ghost if it's a simultaneous note but on a different lane
    if (data.lastStrum == note.strumTime && data.lastData != note.noteData) {
        doGhostAnim(key);
    }

    data.lastStrum = note.strumTime;
    data.lastData = note.noteData;
}

function doGhostAnim(key:String) {
    var data = ghostData.get(key);
    var orig = (key == 'bf') ? boyfriend : ((key == 'dad') ? dad : gf);

    if (data.ghost == null || orig == null) return;

    data.tween?.cancel();

    var ghost = data.ghost;
    ghost.setPosition(orig.x, orig.y);
    ghost.scale.set(orig.scale.x, orig.scale.y);
    ghost.flipX = orig.flipX;
    ghost.flipY = orig.flipY;

    // Sync animations
    ghost.playAnim(orig.animation.curAnim?.name, true);
    if (ghost.animation.curAnim != null) {
        ghost.animation.curAnim.curFrame = orig.animation.curAnim?.curFrame ?? 0;
    }

    ghost.alpha = 0.6;
    // maybe figure out how to make the ghost pink
    ghost.visible = true;

    // Assign tween
    data.tween = FlxTween.tween(ghost, {alpha: 0}, 0.75, {
        ease: FlxEase.linear,
        onComplete: function(twn:FlxTween) {
            ghost.visible = false;
            data.tween = null; 
        }
    });
}

/*
TODO for this script:
- figure out how to implement per-character colors so they can have colored afterimages (maybe? considering scrapping this)
- maybe figure out how to localize this for TST so it guaranteed works for every character
*/