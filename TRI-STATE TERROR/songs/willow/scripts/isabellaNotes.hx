function postCreate() {
    moveStrums(isabellaStrums, isabella, 285, 85);
    remove(isabella);
    insert(98, isabella);
}

function postUpdate(Elapsed:Float) {
    isabellaStrums.notes.forEach(function(note) {
        if (note.y < isabella.y - 1200) FlxTween.tween(note, {alpha: 0.75}, 0.5, {ease: FlxEase.cubeOut});
        else note.alpha = 0;
    });
}

function moveStrums(charStrums, char, xOffset, yOffset) {
    charStrums.cameras = [camGame];
    FlxTween.cancelTweensOf(charStrums);

    for (i in charStrums) {
        FlxTween.cancelTweensOf(i);
        i.scrollFactor.set(1,1);
        i.x = i.x + xOffset;
        i.y = char.y - yOffset;
        i.alpha = 1;
    }

    charStrums.notes.forEach(function(note) {
        FlxTween.cancelTweensOf(note);
    });
}