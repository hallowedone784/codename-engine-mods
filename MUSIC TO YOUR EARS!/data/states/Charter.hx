//
import funkin.backend.system.Conductor;
import funkin.backend.system.Conductor.BeatType;
import funkin.editors.charter.Charter;
import funkin.backend.MusicBeatGroup;
import funkin.backend.MusicBeatState;
import funkin.game.Stage;
import flixel.FlxObject;
import funkin.backend.system.Flags;

/*
//seamless charter yea
//by TheZoroForce240 (Edited by GratchTheEchidna for camera movement, position and zoom event support)

//only supports default note types, events and cam offsets
//you can add your own stuff by adding to the functions: onEditorNoteHit, onEditorEventHit and onCameraMove
//i dont really feel like adding support for loading event scripts

//might not work for all stages (especially if its scripted, scripts don't get loaded)

*/

public static var PLAY_CHARTER_TRANSITION = false;

var backgroundGroup = null;
var characterGroups = [];
var characterGroupData = [];
var stage = null;

var stageCamera;
var curStage;
var camFollow;

public var defaultCamZoom = Flags.DEFAULT_CAM_ZOOM;
var camGameZoomLerp = Flags.DEFAULT_CAM_ZOOM_LERP;
var camGameZoomMult = Flags.DEFAULT_CAM_ZOOM_MULT;

//var defaultHudZoom = 1.0;
//var camHUDZoomLerp = 0.05;

var defaultZoom = Flags.DEFAULT_ZOOM;
var camZoomLerp = Flags.DEFAULT_ZOOM_LERP;

var camZooming = false;
var camZoomingInterval = Flags.DEFAULT_CAM_ZOOM_INTERVAL;
var camZoomingOffset = Flags.DEFAULT_CAM_ZOOM_OFFSET;
var camZoomingEvery:BeatType = BeatType.BEAT;
var camZoomingLastBeat:Float;
var camZoomingStrength = Flags.DEFAULT_CAM_ZOOM_STRENGTH;
var maxCamZoomMult = Flags.MAX_CAMERA_ZOOM_MULT;
var useCamZoomMult = Flags.USE_CAM_ZOOM_MULT;
var camZoomingMult = Flags.DEFAULT_ZOOM;

var maxCamZoom = Math.NaN;
function get_maxCamZoom() return Math.isNaN(maxCamZoom) ? defaultCamZoom + (camZoomingMult * camGameZoomMult) : maxCamZoom;

var nextNoteIndex = 0;
var nextEventLeftIndex = 0;
var nextEventRightIndex = 0;

function postCreate() {

	topMenu[2].childs[0].onSelect = _chart_playtest_override;
	topMenu[2].childs[1].onSelect = _chart_playtest_here_override;
	topMenu[2].childs[3].onSelect = _chart_playtest_opponent_override;
	topMenu[2].childs[4].onSelect = _chart_playtest_opponent_here_override;

	remove(charterBG);

	charterCamera.bgColor = 0;

	stageCamera = new FlxCamera();
	stageCamera.bgColor = 0;
	FlxG.cameras.insert(stageCamera, 0, false);

	camFollow = new FlxObject(0, 0, 2, 2);
	add(camFollow);

	if (PLAY_CHARTER_TRANSITION) {
		uiCamera.x += 1280;
		FlxTween.tween(uiCamera, {x: 0}, 1, {ease: FlxEase.quintOut});
		charterCamera.x += 1280;
		FlxTween.tween(charterCamera, {x: 0}, 1, {ease: FlxEase.quintOut});
	}
	PLAY_CHARTER_TRANSITION = false;

	camZoomingInterval = PlayState.SONG.meta.beatsPerMeasure != null ? PlayState.SONG.meta.beatsPerMeasure : 4;

	reloadStage(true);
}
function destroy() {
	FlxG.animationTimeScale = 1;
	FlxG.cameras.reset(); //leak fix???
	//stageCamera.destroy();
}

function reloadStage(firstLoad) {
	if (!firstLoad) {
		for (obj in stage.stageSprites) {
			remove(obj);
			obj.destroy();
		}
		remove(stage);
		stage.destroy();
		stage = null;

		for (grp in characterGroups) {
			for (char in grp) {
				remove(char);
				char.destroy();
			}
		}
		characterGroups = [];
		characterGroupData = [];
	}
	curStage = chart.stage;
	if (curStage == null || StringTools.trim(curStage) == "") curStage = "stage";

	stage = new Stage(curStage);
	for (obj in stage.stageSprites) obj.cameras = [stageCamera];
	add(stage);

	if (stage.stageXML.exists("startCamPosX")) {
		var parsed = Std.parseFloat(stage.stageXML.get("startCamPosX"));
		if (parsed != null) camFollow.x = parsed;
	}

	if (stage.stageXML.exists("startCamPosY")) {
		var parsed = Std.parseFloat(stage.stageXML.get("startCamPosY"));
		if (parsed != null) camFollow.y = parsed;
	}

	if (stage.stageXML.exists("zoom")) {
		var parsed = Std.parseFloat(stage.stageXML.get("zoom"));
		if (parsed != null) defaultCamZoom = parsed;
	}

	stageCamera.follow(camFollow, 0x00, 0.04);
	stageCamera.zoom = defaultCamZoom;

	for(i=>strumLineGrp in strumLines.members) {
		var strumLine = strumLineGrp.strumLine;
		if (strumLine == null) continue;

		var chars = [];
		var charPosName:String = strumLine.position == null ? (switch(strumLine.type) {
			case 0: "dad";
			case 1: "boyfriend";
			case 2: "girlfriend";
		}) : strumLine.position;
		if (strumLine.characters != null) for(k=>charName in strumLine.characters) {
			var char = new Character(0, 0, charName, stage.isCharFlipped(stage.characterPoses[charName] != null ? charName : charPosName, strumLine.type == 1), true, true);
			stage.applyCharStuff(char, charPosName, k);
			char.cameras = [stageCamera];
			chars.push(char);
		}
		characterGroups.push(chars);
		characterGroupData.push({
			animSuffix: "",
			lastHit: {
				time: 0,
				endTime: 0,
				dir: -1,
				animSuffix: ""
			},
			characterList: Std.string(strumLine.characters)
		});
	}


	if (firstLoad) {
		if (PlayState.smoothTransitionData != null && PlayState.smoothTransitionData.stage == curStage) {
			stageCamera.scroll.set(PlayState.smoothTransitionData.camX, PlayState.smoothTransitionData.camY);
			stageCamera.zoom = PlayState.smoothTransitionData.camZoom;
			MusicBeatState.skipTransIn = true;
			camFollow.setPosition(PlayState.smoothTransitionData.camFollowX, PlayState.smoothTransitionData.camFollowY);
		} else {
			stageCamera.focusOn(camFollow.getPosition(FlxPoint.weak()));
		}
		PlayState.smoothTransitionData = null;
	}
}
var curCameraTarget = 0;
var camEventIndex = 0;

function update(elapsed) {
	//check for stage/char reloads
	var doReload = false;
	var stageName = chart.stage;
	if (stageName == null || StringTools.trim(stageName) == "") stageName = "stage";

	if (curStage != stageName) {
		doReload = true;
	}
	if (gridBackdrops.strumlinesAmount != characterGroupData.length) doReload = true;

	if (!doReload) {
		for (i => data in characterGroupData) {
			if (strumLines.members[i] == null || data.characterList != Std.string(strumLines.members[i].strumLine.characters)) {
				doReload = true;
			}
		}
	}

	if (doReload) reloadStage(false);

	var latestStep = 0;
	for (grp in [leftEventsGroup, rightEventsGroup]) {
		for (charterEvent in grp.members) {
			if (charterEvent.step > curStepFloat) break;
			/*for (e in charterEvent.events) {
				if (e.name == "Camera Movement" && charterEvent.step >= latestStep) {
					curCameraTarget = e.params[0];
					latestStep = charterEvent.step;
				}
			}*/
		}
	}


	if (camZooming) {
		var beat = Conductor.getBeats(camZoomingEvery, camZoomingInterval, camZoomingOffset);
		if (camZoomingLastBeat != beat) {
			camZoomingLastBeat = beat;
			if (useCamZoomMult) {
				if (camZoomingMult < maxCamZoomMult) camZoomingMult += camZoomingStrength;
			}
			else if (stageCamera.zoom < maxCamZoom) {
				stageCamera.zoom += camGameZoomMult * camZoomingStrength;
				//camHUD.zoom += camHUDZoomMult * camZoomingStrength;
			}
		}
	}

	if (curCameraTarget != -1) onCameraMove();

	if (camZooming) {
		stageCamera.zoom = CoolUtil.fpsLerp(stageCamera.zoom, defaultCamZoom, camGameZoomLerp * playBackSlider.value);
		//camHUD.zoom = lerp(camHUD.zoom, defaultHudZoom, camHUDZoomLerp);
	}

	if (camZooming) {
		if (useCamZoomMult) {
			camZoomingMult = CoolUtil.fpsLerp(camZoomingMult, defaultZoom, camZoomLerp) - defaultZoom;
			stageCamera.zoomMultiplier = camZoomingMult * camGameZoomMult + defaultZoom;
			//camHUD.zoomMultiplier = camZoomingMult * camHUDZoomMult + defaultZoom;
			camZoomingMult += defaultZoom;
		}
		stageCamera.zoom = CoolUtil.fpsLerp(stageCamera.zoom, defaultCamZoom, camGameZoomLerp * playBackSlider.value);
		//camHUD.zoom = lerp(camHUD.zoom, defaultHudZoom, camHUDZoomLerp);
	}

	FlxG.animationTimeScale = playBackSlider.value;


	while(nextNoteIndex < notesGroup.members.length) {
		var note = notesGroup.members[nextNoteIndex];
		if (curStepFloat >= note.step) {
			nextNoteIndex++;
			_onEditorNoteHit(note, false);
			continue;
		}
		break;
	}

	while(nextNoteIndex > 0) {
		var prevNote = notesGroup.members[nextNoteIndex-1];
		if (curStepFloat < prevNote.step) {
			nextNoteIndex--;
			_onEditorNoteHit(prevNote, true);
			continue;
		}
		break;
	}

	if (nextNoteIndex == 0) {
		if ((notesGroup.members[0] != null && notesGroup.members[0].step > curStepFloat) || notesGroup.members[0] == null) {
			camZooming = false;
		}
	}

	var eventsToTrigger = [];
	var eventsToTriggerRewind = [];
	
	{
		while(nextEventLeftIndex < leftEventsGroup.members.length) {
			var event = leftEventsGroup.members[nextEventLeftIndex];
			if (curStepFloat >= event.step) {
				nextEventLeftIndex++;
				eventsToTrigger.push({
					step: event.step,
					index: nextEventLeftIndex,
					isLeft: true
				});
				continue;
			}
			break;
		}

		while(nextEventLeftIndex > 0) {
				var prevEvent = leftEventsGroup.members[nextEventLeftIndex-1];
				if (curStepFloat < prevEvent.step) {
					nextEventLeftIndex--;
					eventsToTriggerRewind.push({
						step: event.step,
						index: nextEventLeftIndex,
						isLeft: true
					});
					continue;
				}
			break;
		}
	}
	{
		while(nextEventRightIndex < rightEventsGroup.members.length) {
			var event = rightEventsGroup.members[nextEventRightIndex];
			if (curStepFloat >= event.step) {
				nextEventRightIndex++;
				eventsToTrigger.push({
					step: event.step,
					index: nextEventRightIndex,
					isLeft: false
				});
				continue;
			}
			break;
		}

		while(nextEventRightIndex > 0) {
				var prevEvent = rightEventsGroup.members[nextEventRightIndex-1];
				if (curStepFloat < prevEvent.step) {
					nextEventRightIndex--;
					eventsToTriggerRewind.push({
						step: event.step,
						index: nextEventRightIndex,
						isLeft: false
					});
					continue;
				}
			break;
		}
	}

	if (eventsToTrigger.length > 1) {
		eventsToTrigger.sort(function(a, b) {
			if(a.step < b.step) return -1;
			else if(a.step > b.step) return 1;
			else return 0;
		});
	}
	if (eventsToTriggerRewind.length > 1) {
		eventsToTriggerRewind.sort(function(a, b) {
			if(a.step < b.step) return 1;
			else if(a.step > b.step) return -1;
			else return 0;
		});
	}

	for (e in eventsToTrigger) {
		if (e.isLeft) {
			nextEventLeftIndex = e.index;
			_onEditorEventHit(leftEventsGroup.members[e.index-1], false);
		} else {
			nextEventRightIndex = e.index;
			_onEditorEventHit(rightEventsGroup.members[e.index-1], false);
		}
	}

	for (e in eventsToTriggerRewind) {
		if (e.isLeft) {
			nextEventLeftIndex = e.index;
			_onEditorEventHit(leftEventsGroup.members[e.index], true);
		} else {
			nextEventRightIndex = e.index;
			_onEditorEventHit(rightEventsGroup.members[e.index], true);
		}
	}
}

function onCameraMove() {
	if (characterGroups[curCameraTarget] != null) {
		var pos = FlxPoint.get();
		var r = 0;
		for(c in characterGroups[curCameraTarget]) {
			if (c == null || !c.visible) continue;
			var cpos = c.getCameraPosition();
			pos.x += cpos.x;
			pos.y += cpos.y;
			r++;
		}
		if (r > 0) {
			pos.x /= r;
			pos.y /= r;

			camFollow.setPosition(pos.x, pos.y);
		}
		pos.put();
	}
}

function createNoteHitEvent(note, rewind) {
	var event = {
		note: note,
		noteType: noteTypes[note.type-1],
		animSuffix: characterGroupData[note.strumLineID].animSuffix,
		direction: note.id,
		animCancelled: false,
		enableCamZooming: true,

		rewind: rewind,

		preventAnim: null,
		cancelAnim: null,
		preventCamZooming: null,
		cancelCamZooming: null,
	};
	event.preventAnim = function() { event.animCancelled = true; }
	event.cancelAnim = function() { event.animCancelled = true; }
	event.preventCamZooming = function() { event.enableCamZooming = false; }
	event.cancelCamZooming = function() { event.enableCamZooming = false; }

	return event;
}

function _onEditorNoteHit(note, rewind) {
	//trace("hit " + note.id);

	var event = createNoteHitEvent(note, rewind);
	
	onEditorNoteHit(event);

	if (!event.animCancelled) {
		var time = Conductor.getTimeForStep(note.step);

		if (time >= characterGroupData[note.strumLineID].lastHit.time && characterGroupData[note.strumLineID].lastHit.endTime > time) {
			//note pressed during sustain
			for (char in characterGroups[note.strumLineID]) {
				char.playSingAnim(event.direction, event.animSuffix, "SING", true);
				char.lastHit = characterGroupData[note.strumLineID].lastHit.endTime; //end after long note
			}
		}
		else {
			characterGroupData[note.strumLineID].lastHit.time = time;
			characterGroupData[note.strumLineID].lastHit.endTime = time + (Conductor.stepCrochet * note.susLength);
			characterGroupData[note.strumLineID].lastHit.dir = event.direction;
			characterGroupData[note.strumLineID].lastHit.animSuffix = event.animSuffix;

			for (char in characterGroups[note.strumLineID]) {
				char.playSingAnim(event.direction, event.animSuffix, "SING", true);
				char.lastHit = characterGroupData[note.strumLineID].lastHit.endTime; //end after long note
			}
		}

	}
	if (event.enableCamZooming) camZooming = true;
}

function onEditorNoteHit(event) {
	switch(event.noteType) {
		case "Alt Anim Note":
			event.animSuffix = "-alt";
		case "No Anim Note":
			event.cancelAnim();
	}
}

function _onEditorEventHit(event, rewind) {
	//trace(event);
	for (e in event.events) {
		var data = {event: e, rewind: rewind};
		onEditorEventHit(data);
	}
}

var camZoomTween:FlxTween;
var camMoveTween:FlxTween;

function onEditorEventHit(e) {
	switch(e.event.name) {
		case "Camera Movement":
			if (!e.rewind) {
				if (camMoveTween != null) camMoveTween.cancel();
				curCameraTarget = e.event.params[0];
				onCameraMove();
				stageCamera.followEnabled = true;

				if (e.event.params[1] == false) {
					stageCamera.scroll.x = camFollow.x - stageCamera.width * 0.5;
					stageCamera.scroll.y = camFollow.y - stageCamera.height * 0.5;
					stageCamera.snapToTarget();
				}

				if (e.event.params[3] == "CLASSIC") {
					stageCamera.followEnabled = true;
				}

				else if (e.event.params[3] != null && e.event.params[3] != "CLASSIC") {
					var oldFollow = stageCamera.followEnabled;
					stageCamera.followEnabled = false;
					camMoveTween = FlxTween.tween(stageCamera.scroll, {x: camFollow.x - stageCamera.width * 0.5, y: camFollow.y - stageCamera.height * 0.5},
					(Conductor.stepCrochet / 1000) * (e.event.params[2] == null ? 4 : e.event.params[2]), {
						ease: CoolUtil.flxeaseFromString(e.event.params[3], e.event.params[4]),
						onComplete: (_) -> stageCamera.followEnabled = oldFollow
					});
					camMoveTween.start();
				}
			}

		case "Camera Position":
			if (!e.rewind) {
				if (camMoveTween != null) camMoveTween.cancel();
				var isOffset = e.event.params[6] == true;
				camFollow.setPosition(isOffset ? (camFollow.x + e.event.params[0]) : e.event.params[0], isOffset ? (camFollow.y + e.event.params[1]) : e.event.params[1]);
				//if (e.event.params[4] == "CLASSIC") {
					//stageCamera.followEnabled = false;
				//}
				curCameraTarget = -1;
				trace([camFollow.x, camFollow.y]);
				if (e.event.params[2] == false) {
					stageCamera.scroll.x = camFollow.x;
					stageCamera.scroll.y = camFollow.y;
					stageCamera.snapToTarget();
				}

				if (e.event.params[4] == "CLASSIC") {
					stageCamera.followEnabled = true;
				}
				else if (e.event.params[4] != null && e.event.params[4] != "CLASSIC") {
						camMoveTween = FlxTween.tween(stageCamera.scroll, {x: camFollow.x - stageCamera.width * 0.5, y: camFollow.y - stageCamera.height * 0.5},
						(Conductor.stepCrochet / 1000) * (e.event.params[3] == null ? 4 : e.event.params[3]), {
							ease: CoolUtil.flxeaseFromString(e.event.params[4], e.event.params[5])
						});
						camMoveTween.start();
					}
				}

		case "Camera Zoom":
			if (e.event.params[2] != "camHUD" && !e.rewind) {
				if (camZoomTween != null) camZoomTween.cancel();
				if (e.event.params[7] == false) var finalZoom:Float = e.event.params[1]; else var finalZoom:Float = e.event.params[1] * stageCamera.zoom;
				if (e.event.params[0] == true) {
					var timeAhh = (Conductor.stepCrochet / 1000)*e.event.params[3];
					camZoomTween = FlxTween.num(defaultCamZoom, finalZoom, timeAhh, { ease: CoolUtil.flxeaseFromString(e.event.params[4], e.event.params[5])},
        				(value:Float) -> {
					defaultCamZoom = value;
            				stageCamera.zoom = value;
        				});
					}
				else {
					defaultCamZoom = finalZoom;
					stageCamera.zoom = finalZoom;
				}
			}
			
		case "Play Animation":
			if (!e.rewind) {
				for (char in characterGroups[e.event.params[0]]) {
					char.playAnim(e.event.params[1], e.event.params[2]);
				}
			}
		case "Alt Animation Toggle":
			
			var singSuffix = "";
			var idleSuffix = "";

			if (!e.rewind) {
				singSuffix = e.event.params[0] ? "-alt" : "";
				idleSuffix = e.event.params[1] ? "-alt" : "";
			} else {
				var prev = findPrevEventWithMatchingParam(e.event.name, 2, e.event.params[2]);
				if (prev != null) {
					singSuffix = prev.params[0] ? "-alt" : "";
					idleSuffix = prev.params[1] ? "-alt" : "";
				} else {
					//reset to default
				}
			}

			characterGroupData[e.event.params[2]].animSuffix = singSuffix;
			for (char in characterGroups[e.event.params[2]]) {
				char.idleSuffix = idleSuffix;
			}
		
		case "Add Camera Zoom":
			if (!e.rewind) {
				if (e.event.params[1] != "camHUD") {
					stageCamera.zoom += e.event.params[0];
				}
			}
		case "Camera Bop":
			camZoomingMult += e.rewind ? -e.event.params[0] : e.event.params[0];
		case "Camera Modulo Change":

			var interval = Flags.DEFAULT_CAM_ZOOM_INTERVAL;
			var strength = Flags.DEFAULT_CAM_ZOOM_STRENGTH;
			var every = BeatType.BEAT;
			var offset = Flags.DEFAULT_CAM_ZOOM_OFFSET;
			if (!e.rewind) {
				interval = e.event.params[0];
				strength = e.event.params[1];
				if (e.event.params[2] != null) every = switch (e.event.params[2].toUpperCase()) {
					case "STEP": BeatType.STEP;
					case "MEASURE": BeatType.MEASURE;
					default: BeatType.BEAT;
				}
				if (e.event.params[3] != null) offset = e.event.params[3];
			} else {
				var prev = findPrevEvent(e.event.name);
				if (prev != null) {
					interval = prev.params[0];
					strength = prev.params[1];
					if (prev.params[2] != null) every = switch (prev.params[2].toUpperCase()) {
						case "STEP": BeatType.STEP;
						case "MEASURE": BeatType.MEASURE;
						default: BeatType.BEAT;
					}
					if (prev.params[3] != null) offset = prev.params[3];
				} else {
					//reset to default
					interval = PlayState.SONG.meta.beatsPerMeasure != null ? PlayState.SONG.meta.beatsPerMeasure : 4;
				}
			}

			camZoomingInterval = interval;
			camZoomingStrength = strength;
			camZoomingEvery = every;
			camZoomingOffset = offset;
			//trace(camZoomingInterval + " : " + camZoomingStrength + " : " + camZoomingEvery);
		case "Camera Flash":
			var camera:FlxCamera = stageCamera;
			if (!e.rewind) {
				if (e.event.params[0]) // reversed
					camera.fade(e.event.params[1], (Conductor.stepCrochet / 1000) * e.event.params[2], false, () -> {camera._fxFadeAlpha = 0;}, true);
				else // Not Reversed
					camera.flash(e.event.params[1], (Conductor.stepCrochet / 1000) * e.event.params[2], null, true);
			}

	}
}

function findPrevEvent(name) {
	var foundEvent = null;
	var foundEventStep = 0;

	var index = nextEventLeftIndex-1;
	while(index > 0) {
		var event = leftEventsGroup.members[index];
		for (e in event.events) {
			if (e.name == name) {
				foundEvent = e;
				foundEventStep = event.step;
				break;
			}
		}
		index--;
	}
	index = nextEventRightIndex-1;
	while(index > 0) {
		var event = rightEventsGroup.members[index];
		for (e in event.events) {
			if (e.name == name) {
				if (foundEventStep <= event.step) {
					foundEvent = e;
					foundEventStep = event.step;
				}
				break;
			}
		}
		index--;
	}

	return foundEvent;
}
function findPrevEventWithMatchingParam(name, pid, p) { //mainly for checking strumline id
	var foundEvent = null;
	var foundEventStep = 0;

	var index = nextEventLeftIndex-1;
	while(index > 0) {
		var event = leftEventsGroup.members[index];
		for (e in event.events) {
			if (e.name == name && e.params[pid] == p) {
				foundEvent = e;
				foundEventStep = event.step;
				break;
			}
		}
		index--;
	}
	index = nextEventRightIndex-1;
	while(index > 0) {
		var event = rightEventsGroup.members[index];
		for (e in event.events) {
			if (e.name == name && e.params[pid] == p) {
				if (foundEvent == null || foundEventStep <= event.step) {
					foundEvent = e;
					foundEventStep = event.step;
				}
				break;
			}
		}
		index--;
	}

	return foundEvent;
}

function beatHit() {

	/*if (camZoomingInterval < 1) camZoomingInterval = 1;
	if (camZooming && stageCamera.zoom < maxCamZoom && curBeat % camZoomingInterval == 0)
	{
		stageCamera.zoom += 0.015 * camZoomingStrength;
		//camHUD.zoom += 0.03 * camZoomingStrength;
	}*/
}

//emulate replaying anim for each sustain segment
function stepHit() {
	for (id => grp in characterGroupData) {
		if (Conductor.songPosition > grp.lastHit.time && Conductor.songPosition < grp.lastHit.endTime) {
			for (char in characterGroups[id]) {
				char.playSingAnim(grp.lastHit.dir, grp.lastHit.animSuffix, "SING", true);
				char.lastHit = grp.lastHit.endTime;
			}
		} else if (Conductor.songPosition < grp.lastHit.time) {
			for (char in characterGroups[id]) {
				if (char.lastAnimContext == "SING") {
					char.dance();
				}
			}	
		}
	}
}

function _chart_playtest_override(_)
	playtestChart_override(0, false, false);
function _chart_playtest_here_override(_)
	playtestChart_override(Conductor.songPosition, false, true);
function _chart_playtest_opponent_override(_)
	playtestChart_override(0, true, false);
function _chart_playtest_opponent_here_override(_)
	playtestChart_override(Conductor.songPosition, true, true);

function playtestChart_override(time:Float, opponentMode, here) {
	buildChart();
	Charter.startHere = here;
	Charter.startTime = Conductor.songPosition;
	PlayState.opponentMode = opponentMode;
	PlayState.chartingMode = true;
	

	MusicBeatState.skipTransIn = true;
	MusicBeatState.skipTransOut = true;

	persistentUpdate = false;

	for (grp in characterGroups) {
		for (char in grp) {
			char.dance();
		}
	}

	FlxG.animationTimeScale = 1;

	FlxTween.tween(uiCamera, {x: 1280}, 0.5, {ease: FlxEase.quintOut});
	FlxTween.tween(charterCamera, {x: 1280}, 0.5, {ease: FlxEase.quintOut});
	new FlxTimer().start(0.5, function(tmr) {
		PlayState.smoothTransitionData = {
			stage: curStage,
			camX: stageCamera.scroll.x,
			camY: stageCamera.scroll.y,
			camFollowX: camFollow.x,
			camFollowY: camFollow.y,
			camZoom: stageCamera.zoom
		};
		FlxG.switchState(new PlayState());
	});
}