
--requirements
local storyboard = require( "storyboard" )
local bed = require ("Bed")
local collision = require ("collision")

local image = require("ImageAndSpriteCreation")
local menu = require("Menu")
local monetize = require("Monetization")

local scene = storyboard.newScene()

--> Start Physics
local ragdoll = require ("ragdoll")

local display = display; _W = display.contentWidth;_H = display.contentHeight; pixelRatio = _W/480; ragdollGroup = display.newGroup();
percent = (_H/100)*9;pointLeft = _W*(27/100); pointCenter = _W*(60/100); pointRight = _W*(93/100);
pointOne = (pointRight+pointCenter)/2; pointTwo = (pointLeft+pointCenter)/2; pointThree = (pointLeft)/2; local countForBlast = 40; local countForFire = 70;

local function addFrictionJoint(a, b, posX, posY, lowerAngle, upperAngle, mT)
    local j = physics.newJoint ( "pivot", a, b, posX, posY)
    j.isLimitEnabled = true
    j:setRotationLimits (lowerAngle, upperAngle)
    return j
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view

    local background = image.setImage("background.png", _W, _H, 0, 0, display.TopLeftReferencePoint)

    highScoreText = display.newText("Hi Score: "..settings.highScore, 0, 0,240, 32+(pixelRatio*4), "TequillaSunrise", 12+(pixelRatio*2));
    highScoreText:setReferencePoint(display.TopLeftReferencePoint);
    highScoreText:setTextColor(100,100,100,200)

    scoreText = display.newText("You Saved: 0", 0, 0,240, 28+(pixelRatio*4), "TequillaSunrise", 12+(pixelRatio*2));
    scoreText:setReferencePoint(display.TopLeftReferencePoint);
    scoreText.y = highScoreText.contentHeight;
    scoreText:setTextColor(100,100,100,200)

    buildingObj   = image.setImage("building_new.png", 70*pixelRatio, _H-(percent*2), _W, _H-percent, display.BottomRightReferencePoint)
    local buildingFire = image.addSprite("fire_new.png", 200, 200, buildingObj.x-buildingObj.contentWidth/2, buildingObj.y-(buildingObj.contentHeight*35/100), display.CenterReferencePoint, 12, 1500, 0)
    buildingFire.xScale = 0.5*pixelRatio
    buildingFire.yScale = 0.5*pixelRatio

    ambulance  = image.addSprite("ambulance.png", 102, 80, -33*pixelRatio, _H-(percent/2), display.BottomLeftReferencePoint, 2, 1000, 0)
    ambulance.xScale = 0.7*pixelRatio;
    ambulance.yScale = 0.7*pixelRatio;
    ambulance.containPatients = 0;

    hospitalBed = image.setImage("bed_still.png", 53*pixelRatio, 35*pixelRatio, pointRight, _H-(percent), display.CenterReferencePoint)

    walls = image.createWalls();
    wallBottomSensor = walls[2];
    wallAmbulance = walls[3];

    monetize.createFullScreenAd();

    group:insert(background);
    group:insert(buildingObj);
    group:insert(buildingFire);
    group:insert(ambulance);
    group:insert(hospitalBed);
    group:insert(scoreText);
    group:insert(highScoreText);
    group:insert(walls);
    group:insert(wallBottomSensor);
    group:insert(wallAmbulance);

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group = self.view
    Runtime:addEventListener("touch", bed.controlBedWithTouch);
    hospitalBed.enterFrame = bed.moveHospitalBed;
    Runtime:addEventListener("enterFrame", hospitalBed);
    delay = 3000;

    local function generateRagdoll()
      local color1 = {math.random(120), math.random(120), math.random(120), 255 }
      local ragdollObj = ragdoll.newRagDoll(pointRight, percent, color1)
      local activeBodyPart = ragdollObj[3];
      activeBodyPart.enterFrame = collision.jumpRagdoll
      Runtime:addEventListener("enterFrame", activeBodyPart);
      activeBodyPart.action = "drop"
      activeBodyPart.count = 1;
      ragdollObj.isRagdoll = true;
      group:insert(ragdollObj);
    end

    local function fireUpBuilding()
      buildingFire = image.addSprite("fire_new.png", 200, 200, buildingObj.x-buildingObj.contentWidth/2, buildingObj.y-(buildingObj.contentHeight*countForFire/100), display.CenterReferencePoint, 12, 1500, 0)
      buildingFire.xScale = 0.5*pixelRatio
      buildingFire.yScale = 0.5*pixelRatio
      countForFire = countForFire + 35;
      group:insert(buildingFire);
    end

    local function removeObj()
      blastObj:removeSelf();
      blastObj = nil;
    end

    local function blast()
      fireUpBuilding()
      blastObj  = image.addSprite("blast.png", 128, 128, buildingFire.x, buildingFire.y+(20*pixelRatio), display.CenterReferencePoint, 32, 2000, 1)
      blastObj.xScale = pixelRatio;
      blastObj.yScale = pixelRatio;
      group:insert(blastObj);
      removeObjTimer = timer.performWithDelay( 2500, removeObj, 1 )
    end

    local function fireBuilding(event)
        blast();
        countForBlast = countForBlast + 35;
    end


    ragdollTimer = timer.performWithDelay( 5000, generateRagdoll , 20)

    fireTimer = timer.performWithDelay( delay, fireBuilding , 2 )

    hospitalBed.collision = collision.onBedCollision;
    hospitalBed:addEventListener( "collision", hospitalBed )


    wallBottomSensor.collision = collision.onWallBottomSensorCollision;
    wallBottomSensor:addEventListener( "collision", wallBottomSensor )

    wallAmbulance.collision = collision.onAmbulanceWallCollision;
    wallAmbulance:addEventListener( "collision", wallAmbulance )


end


local function removeListeners(group)
  Runtime:removeEventListener("touch", bed.controlBedWithTouch);
  Runtime:removeEventListener("enterFrame", hospitalBed);
  hospitalBed:removeEventListener( "collision", hospitalBed )
  wallBottomSensor:removeEventListener( "collision", wallBottomSensor )
  wallAmbulance:removeEventListener( "collision", wallAmbulance )
  timer.cancel(removeObjTimer);
  timer.cancel(ragdollTimer);
  timer.cancel(fireTimer);
  for i=1,group.numChildren do
    local tempRagdoll = group[i];
    if (tempRagdoll.isRagdoll) then
      Runtime:removeEventListener("enterFrame", tempRagdoll[3]);
    end
  end
 countForBlast = 40; countForFire = 70;
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    local group = self.view

    removeListeners(group);
end

-- Called AFTER scene has finished moving offscreen:
function scene:didExitScene( event )
    local group = self.view

    removeListeners(group);
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    local group = self.view
    removeListeners(group)
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

