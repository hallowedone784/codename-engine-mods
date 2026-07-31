// trying something new with public and private labeling
// the screen text
private var screenText:FlxText = "";
private var faceImage:FlxSprite;

// text setup
function create()
{
    // screen text initialization
    screenText = new FlxText(FlxG.width/2 - 250, FlxG.height - 650, 480, "", 48, true);
    screenText.font = Paths.font("adultswim.ttf");
    screenText.alignment = "center";
    screenText.cameras = [camHUD];
    add(screenText);

    // face image initialization
    faceImage = new FlxSprite();
    add(faceImage);
    faceImage.scale.set(0.68, 0.68);
    faceImage.alpha = 0;
}

// the stuff to update the text
public function updateText(text:FlxText)
{
    switch (text)
    {
        case "destroy":
            remove(screenText);
        case "add":
            add(screenText);
            screenText.text = "";
        case "":
            screenText.text = "";
        default:
            screenText.text = "[" + text + "]";
    }
}

/* the following code is for the faceImage and shouldn't have anything to do with the screenText
credits for the code go to swagaruney
*/

function update()
{
    switch (elmo.animation.curAnim.name)
    {
        case "idle":
            faceImage.x = elmo.x + 40;
            faceImage.y = elmo.y + 190;
        case "singLEFT":
            faceImage.x = elmo.x - 100;
            faceImage.y = elmo.y + 225;
        case "singDOWN":
            faceImage.x = elmo.x + 185;
            faceImage.y = elmo.y + 325;
        case "singUP":
            faceImage.x = elmo.x + 10;
            faceImage.y = elmo.y + 120;
        case "singRIGHT":
            faceImage.x = elmo.x + 210;
            faceImage.y = elmo.y + 185;
    }
}

// small tweaks below here
function beatHit(curBeat:Int) 
{
    switch (curBeat)
    {
        case 284:
            faceImage.loadGraphic(Paths.image("glitch/basketball"));
            FlxTween.tween(faceImage, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
        
        case 288:
            FlxTween.tween(faceImage, {alpha: 0}, 0.5, {ease: FlxEase.circOut});

        case 635:
            screenText.size = 41;

        case 640:
            screenText.size = 48;

        case 658:
            faceImage.loadGraphic(Paths.image("glitch/kingvon"));
            FlxTween.tween(faceImage, {alpha: 1}, 0.5, {ease: FlxEase.circOut});

        case 660:
            faceImage.loadGraphic(Paths.image("glitch/crying"));

        case 664:
            FlxTween.tween(faceImage, {alpha: 0}, 0.5, {ease: FlxEase.circOut});
    }
}