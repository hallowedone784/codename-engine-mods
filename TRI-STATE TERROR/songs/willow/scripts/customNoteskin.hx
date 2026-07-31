// sets all notes and receptors to the custom skin
function onStrumCreation(e:StrumCreationEvent) {
    e.sprite = "game/notes/test1";
}
function onNoteCreation(e:NoteCreationEvent) {
    e.noteSprite = "game/notes/test1";
}

/* overview of the code (since i've never done this before)
if the strumLine isn't a player, scale is 0.3, otherwise being 0.35
if the notes and strumLines aren't null, continue
same note scale logic as there are with the strumLines
not actually sure at all how this fixed the spacing but oh well
add logic in soon so that the same scaling affects enemy Phineas strums
*/

function onPostStrumCreation(e:StrumCreationEvent) {
    var scale:Float = if (e.player == 0) 0.3 else 0.35;
    e.strum.scale.set(scale, scale);
    e.strum.updateHitbox();
}
function onPostNoteCreation(e:NoteCreationEvent) {
    if (e.note == null || e.note.strumLine == null) return;

    var scale:Float = if (e.note.strumLine == isabellaStrums) 0.3 else 0.35;
    e.note.scale.set(scale, scale);
    e.note.updateHitbox();
}

function onPlayerHit(e:NoteHitEvent) {
    /*
    if (e.note == null || e.note.strumLine == null) return;

    var receptor = e.note.strumLine.members[e.note.id];
    if (receptor == null) return;

    var baseX:Float = receptor.scale.x;
    var baseY:Float = receptor.scale.y;
    var growX:Float = baseX + 0.05;
    var growY:Float = baseY + 0.05;

    FlxTween.cancelTweensOf(receptor);
    FlxTween.tween(receptor.scale, {x: growX, y: growY}, 0.05, {
        ease: FlxEase.cubeOut,
        onComplete: function(twn:FlxTween) {
            FlxTween.tween(receptor.scale, {x: baseX, y: baseY}, 0.05, {
                ease: FlxEase.cubeOut,
                onComplete: function(twn2:FlxTween) {
                    receptor.updateHitbox();
                }
            });
        }
    });
    */
    e.note.splash = "test1_splash";
}

// find all receptors in the strumLine
// take the specific receptor where the note was hit and grow it 
// shrink it right after note is gone