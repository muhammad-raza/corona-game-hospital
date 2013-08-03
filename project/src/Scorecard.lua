module (..., package.seeall)
--requirements
local storyboard = require( "storyboard" )
local image = require("ImageAndSpriteCreation")
local widget = require("widget")
local loadSave = require("LoadSave")


local scene = storyboard.newScene()

local display = display; local _W = display.contentWidth; local _H = display.contentHeight; local pixelRatio = _W/480;
local percent = (_H/100)*9; local highScore = 0; local recentScore = 0; local totalScore = 0; local averageScore= 0;

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view

--    display.setDefault( "background", 255, 255, 255 );
    local background = image.setImage("scorecard.jpg", _W, _H, 0, 0, display.TopLeftReferencePoint);

    local saveData = loadSave.loadTable("settings.txt");
    if (saveData ~= nil) then
      highScore = saveData.highScore;
      averageScore = saveData.averageScore;
      recentScore = saveData.recentScore;
      totalScore = saveData.totalScore;
    end

    local ambulance  = image.addSprite("ambulance.png", 102, 80, _W/1.2, _H-(percent*3.2), display.CenterReferencePoint, 2, 1000, 0)
    ambulance.xScale = 0.5*pixelRatio;
    ambulance.yScale = 0.5*pixelRatio;

    local highScore = display.newText("High Score:               "..highScore, _W/3, percent, "TequillaSunrise", 12+(pixelRatio*2));
    highScore:setTextColor(0,0,0,200);
    highScore.xScale = 4*pixelRatio;
    highScore.yScale = 4*pixelRatio;

    local averageScore = display.newText("Average Score:       "..averageScore, _W/3, percent*2.5, "TequillaSunrise", 12+(pixelRatio*2));
    averageScore:setTextColor(0,0,0,200);
    averageScore.xScale = 4*pixelRatio;
    averageScore.yScale = 4*pixelRatio;
    averageScore.alpha = 0;

    local recentScore = display.newText("Recent Score:          "..recentScore, _W/3, percent*4, "TequillaSunrise", 12+(pixelRatio*2));
    recentScore:setTextColor(0,0,0,200);
    recentScore.xScale = 4*pixelRatio;
    recentScore.yScale = 4*pixelRatio;
    recentScore.alpha = 0;

    local totalScore = display.newText("Total Score:              "..totalScore, _W/3, percent*5.5, "TequillaSunrise", 12+(pixelRatio*2));
    totalScore:setTextColor(0,0,0,200);
    totalScore.xScale = 4*pixelRatio;
    totalScore.yScale = 4*pixelRatio;
    totalScore.alpha = 0;

    local back = display.newText("Back", _W/2, _H-(percent*1.5), "TequillaSunrise", 14+(pixelRatio*2));
    back:setTextColor(0,0,0,200);

    timer.performWithDelay(250, function() averageScore.alpha = 1; end);

    timer.performWithDelay(550, function() recentScore.alpha = 1; end);

    timer.performWithDelay(850, function() totalScore.alpha = 1; end);


    transition.to( highScore, { time=200, xScale=1, yScale=1 } )

    transition.to( averageScore, { time=200, delay=300, xScale=1, yScale=1 } )

    transition.to( recentScore, { time=200, delay=600, xScale=1, yScale=1 } )

    transition.to( totalScore, { time=200, delay=900, xScale=1, yScale=1 } )

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group = self.view

end


local function removeEventListeners()

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
    removeEventListeners();
end

-- Called if/when overlay scene is displayed via storyboard.showOverlay()
function scene:overlayBegan( event )
        local group = self.view
        local overlay_scene = event.sceneName  -- overlay scene name

  scoreText = display.newText("aasdf", 0, 0,240, 28+(pixelRatio*4), "TequillaSunrise", 16+pixelRatio);
    scoreText:setReferencePoint(display.TopLeftReferencePoint);
    scoreText:setTextColor(100,100,100,200)

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

