import funkin.backend.utils.DiscordUtil;

function onPlayStateUpdate() {
    if (PlayState.SONG != null) {// checks if we're in a song
        var songName:String = PlayState.SONG.meta.name.toLowerCase();
        var difficulty:String = PlayState.difficulty;
        var song:String = PlayState.instance.inst;

        // The RPC text
        if (PlayState.instance.paused) {
            rpcDetails = songName.toUpperCase() + " [PAUSED]";
        } else {
            rpcDetails = songName.toUpperCase();
        }
        var rpcState:String = "i wish i was high on potenuse";
        var imageKey:String = "willow";

        switch (songName) {
            case "willow":
                rpcState = "[can you hear the silence?]";
                imageKey = "willow";
            case "alienation":
                return;
                // save this for an upcoming update!
            case "that's the norm!":
                return;
                // save this for an upcoming update!
            case "phantom":
                return;
                // save this for an upcoming update!
            case "today is gonna be a great day":
                return;
                // save this for an upcoming update!
            default:
                rpcState = "i wish i was high on potenuse";
                imageKey = "willow";
        }
        // Update Discord presence
        DiscordUtil.changeSongPresence(
            rpcDetails,
            rpcState,
            song,
            imageKey
        );
    }
}

function onDiscordPresenceUpdate(e) {
    var data = e.presence;

    if (data.button1Label == null) data.button1Label = "Listen to Willow here!";
    if (data.button1Url == null) data.button1Url = "https://www.youtube.com/watch?v=wDZwbvCZdOc";
}

function onMenuLoaded(name:String) {
	// Name is either "Main Menu", "Freeplay", "Title Screen", "Options Menu", "Credits Menu", "Beta Warning", "Update Available Screen", "Update Screen"
	DiscordUtil.changePresenceSince("Picking an Episode", null);
}

function onEditorTreeLoaded(name:String) {
	switch(name) {
		case "Character Editor":
			DiscordUtil.changePresenceSince("Choosing a Character", null);
		case "Chart Editor":
			DiscordUtil.changePresenceSince("Choosing a Chart", null);
		//case "Stage Editor": // secret for now
		//	DiscordUtil.changePresenceSince("Choosing a Stage", null);
	}
}

function onEditorLoaded(name:String, editingThing:String) {
	switch(name) {
		case "Character Editor":
			DiscordUtil.changePresenceSince("Editing a Character", editingThing);
		case "Chart Editor":
			DiscordUtil.changePresenceSince("Editing a Chart", editingThing);
		//case "Stage Editor":
		//	DiscordUtil.changePresenceSince("Editing a Stage", editingThing);
	}
}
/*
i'm ngl, a good portion of this is copypasted from the ACTUAL discord.hx
but i believe that's how you're supposed to do it? the script doesn't work properly otherwise
take it from me; i was trying to load it during update() and postCreate() a lot
*/