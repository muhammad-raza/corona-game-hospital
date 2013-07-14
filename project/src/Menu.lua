module (..., package.seeall)
--requirements
local storyboard = require( "storyboard" )
local image = require("ImageAndSpriteCreation")
local widget = require("widget")
local loadSave = require("LoadSave")
local monetize = require("Monetization")


local scene = storyboard.newScene()

local display = display; local _W = display.contentWidth; local _H = display.contentHeight; local pixelRatio = _W/480;
local percent = (_H/100)*9;

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view
    local background = image.setImage("background.png", _W, _H, 0, 0, display.TopLeftReferencePoint);
    background:setFillColor(110, 110, 110, 100)

    monetize.createAdLink();
    monetize.createFullScreenAd();
    monetize.startFullPageAdvert();
    monetize.showBannerAtTop();

    group:insert(background);

end

local function playGame()
    storyboard:gotoScene("game");
end

local function removeObject(obj)
  obj:removeSelf();
  obj = nil;
end

local function soundCheck(event)
  if (event == true) then
    settings.soundOn = not settings.soundOn;
  end
  if (settings.soundOn == true) then
    settings.soundOn = false;
    sound.isVisible = false;
    mute.isVisible = true;
  elseif (settings.soundOn == false) then
    settings.soundOn = true;
    sound.isVisible = true;
    mute.isVisible = false;
  end

  loadSave.saveTable(settings, "settings.txt");
end

local function goToAdvertLink()
  monetize.openAdLink();
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group = self.view

    local saveData = loadSave.loadTable("settings.txt");
    if (saveData ~= nil) then
      settings.soundOn = saveData.soundOn;
      settings.highScore = saveData.highScore;
    end

    local score = display.newText("Highest Score: "..settings.highScore, 0, 0, native.systemFont, 16);
    local play = image.setImage("play.png", 80*pixelRatio, 80*pixelRatio, _W/2, _H/2, display.CenterReferencePoint);
    local submit = image.setImage("submit.png", 50*pixelRatio, 50*pixelRatio, _W/2+100*pixelRatio, _H/2, display.CenterReferencePoint);
    sound = image.setImage("sound.png", 50*pixelRatio, 50*pixelRatio, _W/2-100*pixelRatio, _H/2, display.CenterReferencePoint);
    mute = image.setImage("mute.png", 50*pixelRatio, 50*pixelRatio, _W/2-100*pixelRatio, _H/2, display.CenterReferencePoint);

    local labelColor = {
    default = { 100, 100, 100, 200 },
    over = { 100, 100, 100, 200 },
    }

    local myButton = widget.newButton{
        width = 200,
        height = 40,
        defaultFile = "images/button_released.png",
        overFile = "images/button_pressed.png",
        label = "More Games",
        labelColor = labelColor,
        onRelease = goToAdvertLink,
    }

    myButton.x = _W/2;
    myButton.y = _H/2 + play.contentWidth;

    score:setReferencePoint(display.TopLeftReferencePoint);

    soundCheck(true);
    play:addEventListener("tap", playGame);
    sound:addEventListener("tap", soundCheck);
    mute:addEventListener("tap", soundCheck);
--    play:addEventListener("touch", SubmitScore);

    widgetTable = {play, sound, submit }

    group:insert(score);
    group:insert(play);
    group:insert(sound);
    group:insert(mute);
    group:insert(submit);
    group:insert(myButton);

end


local function removeEventListeners()
  widgetTable[1]:removeEventListener("touch", playGame);
  widgetTable[2]:removeEventListener("touch", soundCheck);
--  widgetTable[3]:removeEventListener("touch", submitScore);
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    local group = self.view

    removeEventListeners();
end

-- Called AFTER scene has finished moving offscreen:
function scene:didExitScene( event )
    local group = self.view

    removeEventListeners();
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    local group = self.view

end

-- Called if/when overlay scene is displayed via storyboard.showOverlay()
function scene:overlayBegan( event )
        local group = self.view
        local overlay_scene = event.sceneName  -- overlay scene name

        -----------------------------------------------------------------------------

        --      This event requires build 2012.797 or later.

        -----------------------------------------------------------------------------

end

-- Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
function scene:overlayEnded( event )
        local group = self.view
        local overlay_scene = event.sceneName  -- overlay scene name

        -----------------------------------------------------------------------------

        --      This event requires build 2012.797 or later.

        -----------------------------------------------------------------------------

end



---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "didExitScene" event is dispatched after scene has finished transitioning out
scene:addEventListener( "didExitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-- "overlayBegan" event is dispatched when an overlay scene is shown
scene:addEventListener( "overlayBegan", scene )

-- "overlayEnded" event is dispatched when an overlay scene is hidden/removed
scene:addEventListener( "overlayEnded", scene )

---------------------------------------------------------------------------------

return scene

