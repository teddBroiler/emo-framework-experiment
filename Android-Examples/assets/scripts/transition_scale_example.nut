local stage = emo.Stage;

local text = null;

/*
 * This example shows scale in/out scene transition
 */
class SceneA {

    panel = null;
    loaded = null; // a flag to prevent scene to be loaded twice when stage is double-tapped.

    /*
     * Called when this class is loaded
     */
    function onLoad() {
        print("onLoad");

        panel = emo.Rectangle();
        panel.setSize(stage.getWindowWidth(), stage.getWindowHeight());
        panel.color(1, 0, 0);
        panel.setZ(0);
        panel.load();

        text.setText("SCENE A - TAP");
        text.show();

        loaded = true;
    }

    /*
     * Called when the class ends
     */
    function onDispose() {
        print("onDispose");
        panel.remove();
        text.hide();
    }

    /*
     * touch event
     */
    function onMotionEvent(mevent) {
        if (mevent.getAction() == MOTION_EVENT_ACTION_DOWN) {
            if (!loaded) return;
            loaded = false;
            // fade out current scene then rotate next scene
            local currentSceneModifier = emo.AlphaModifier(1, 0, 1000, emo.easing.CubicIn);
            local nextSceneModifier    = emo.RotateModifier(0, 360, 1000, emo.easing.BackOut);
            stage.load(SceneB(), currentSceneModifier, nextSceneModifier);
        }
    }
}
class SceneB {

    panel = null;
    loaded = null; // a flag to prevent scene to be loaded twice when stage is double-tapped.

    /*
     * Called when this class is loaded
     */
    function onLoad() {
        print("onLoad");

        panel = emo.Rectangle();
        panel.setSize(stage.getWindowWidth(), stage.getWindowHeight());
        panel.color(0, 0, 1);
        panel.setZ(0);
        panel.load();

        text.setText("SCENE B - TAP");
        text.show();

        loaded = true;
    }

    /*
     * Called when the class ends
     */
    function onDispose() {
        print("onDispose");
        panel.remove();
        text.hide();
    }

    /*
     * touch event
     */
    function onMotionEvent(mevent) {
        if (mevent.getAction() == MOTION_EVENT_ACTION_DOWN) {
            if (!loaded) return;
            loaded = false;
            // zoom out current scene then show next scene immediately
            local currentSceneModifier = emo.ScaleModifier(1, 0, 1000, emo.easing.CubicIn);
            local nextSceneModifier    = null;
            local loadNextSceneImmediately = false;
            stage.load(SceneC(), currentSceneModifier, nextSceneModifier, loadNextSceneImmediately);
        }
    }
}
class SceneC {

    panel = null;
    loaded = null; // a flag to prevent scene to be loaded twice when stage is double-tapped.

    /*
     * Called when this class is loaded
     */
    function onLoad() {
        print("onLoad");

        panel = emo.Rectangle();
        panel.setSize(stage.getWindowWidth(), stage.getWindowHeight());
        panel.color(0, 1, 0);
        panel.setZ(0);
        panel.load();

        text.setText("SCENE C - TAP");
        text.show();

        loaded = true;
    }

    /*
     * Called when the class ends
     */
    function onDispose() {
        print("onDispose");
        panel.remove();
        text.hide();
    }

    /*
     * touch event
     */
    function onMotionEvent(mevent) {
        if (mevent.getAction() == MOTION_EVENT_ACTION_DOWN) {
            if (!loaded) return;
            loaded = false;
            // zoom out current scene then show next scene immediately
            local currentSceneModifier = emo.ScaleModifier(1, 0, 1000, emo.easing.CubicIn);
            local nextSceneModifier    = null;
            local loadNextSceneImmediately = true;
            stage.load(SceneA(), currentSceneModifier, nextSceneModifier, loadNextSceneImmediately);
        }
    }
}

function emo::loadText() {
    // Below statements is an example of multiple screen density support.
    // (i.e. Retina vs non-Retina, cellular phone vs tablet device).
    if (stage.getWindowWidth() > 320) {
        // if the screen has large display, scale contents twice
        // that makes the stage size by half.
        // This examples shows how to display similar-scale images
        // on Retina and non-Retina display.
        stage.setContentScale(stage.getWindowWidth() / 320.0);
    }
        
    // 16x16 text sprite with 2 pixel border and 1 pixel margin
    text = emo.TextSprite("font_16x16.png",
        " !\"c*%#'{}@+,-./0123456789:;[|]?&ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        16, 16, 2, 1);
    text.setText("SCENE X - TAP");
    text.setZ(10);
        
    // move sprite to the center of the screen
    local x = (stage.getWindowWidth()  - text.getScaledWidth())  / 2;
    local y = (stage.getWindowHeight() - text.getScaledHeight()) / 2;

    text.move(x, y);

    // load sprite to the screen
    text.hide();
    text.load();
}

function emo::onLoad() {
    if (emo.Runtime.isSimulator() && emo.Runtime.os() == OS_ANDROID) {
        error("This program cannot run on the Android simulator.");
    }
    loadText();
    stage.load(SceneA());
}
