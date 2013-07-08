module (..., package.seeall)

local image = require("ImageAndSpriteCreation"); local countForBlast = 40; local countForFire = 70;

local function fireUpBuilding()
  buildingFire = image.addSprite("fire_new.png", 200, 200, buildingObj.x-buildingObj.contentWidth/2, buildingObj.y-(buildingObj.contentHeight*countForFire/100), display.CenterReferencePoint, 12, 1500, 0)
  buildingFire.xScale = 0.5*pixelRatio
  buildingFire.yScale = 0.5*pixelRatio
  countForFire = countForFire + 35;
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
  timer.performWithDelay( 2500, removeObj, 1 )
end

function fireBuilding(event)
    blast(countForBlast)
    countForBlast = countForBlast + 35;
end
