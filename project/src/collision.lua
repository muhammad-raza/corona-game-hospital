module (..., package.seeall)
local ragdoll = require ("ragdoll")
local loadSave = require ("LoadSave")
local storyboard = require( "storyboard" )

local jumpOne = "jumpOne"; local jumpTwo = "jumpTwo"; local jumpThree = "jumpThree"; local scoreCount = 0; local failCount = 0;

local function getSpeed()
  if (pixelRatio < 2) then return 2; else return 4; end
end

local function getSpeedMultiplier()
  if (pixelRatio < 2) then return 1.4; else return 2; end
end

local function setVertex(ragdoll, x, y)
  ragdoll.vertex = {};
  ragdoll.vertex.x = x;
  ragdoll.vertex.y = y;

  local xPos = ragdoll.x - getSpeed()*getSpeedMultiplier();
  local square = (xPos - x)*(xPos - x)
  ragdoll.vertex.a = ((ragdoll.y-y)/square);
end

function onBedCollision(self, event)
  local ragdollLocal = event.other.parent
  local ragdollTorzo = ragdollLocal[3];

  if (ragdollTorzo.action ~= "immobalize") then
    if (ragdollTorzo.count == 1) then
      if (ragdollTorzo.action == jumpTwo) then
        setVertex(ragdollTorzo, pointThree+(15*getSpeedMultiplier()), percent*3);
        ragdollTorzo.action = jumpThree;
      elseif (ragdollTorzo.action == jumpOne) then
        setVertex(ragdollTorzo, pointTwo, percent*3);
        ragdollTorzo.action = jumpTwo;
      elseif (ragdollTorzo.action == "drop") then
        setVertex(ragdollTorzo, pointOne, percent*3);
        ragdollTorzo.action = jumpOne;
      end
    ragdollTorzo.count = 2;
    end
    if (event.phase == "ended") then
    timer.performWithDelay(1000, function() ragdollTorzo.count = 1; end, 1)
    end
  end


end

function onWallBottomSensorCollision(self, event)
  local ragdollLocal = event.other.parent
  ragdollLocal[3].action = "immobalize";
end

local function removeObject(obj)
  obj:removeSelf();
  Runtime:removeEventListener("enterFrame", obj);
  obj = nil;
end

local function awardAndDestroyRagdoll(event)
  scoreCount = scoreCount + 1;
  scoreText.text = "You Saved: "..scoreCount;
end

function onAmbulanceWallCollision(self, event)
  transition.to( ambulance, { time=100, xScale=0.9*pixelRatio, yScale=0.9*pixelRatio } )
  transition.to( scoreText, { time=100, xScale=1.5, yScale=1.5 } )

  transition.to( ambulance, { time=100, delay=100, xScale=0.7*pixelRatio, yScale=0.7*pixelRatio } )
  transition.to( scoreText, { time=100, delay=100, xScale=1, yScale=1 } )

  local ragdollLocal = event.other.parent;
  ragdollLocal[3].action = "awardAndDestroy";
  awardAndDestroyRagdoll(event);
  removeObject(ragdollLocal);
end

local function getParabolicCoordinates(event, jumpPos)
  local coords = {};
--  local vertex = getVertex(jumpPos);
  local x = event.x - getSpeed();
  local square = (x - event.vertex.x)*(x - event.vertex.x)

  local y = (event.vertex.a* square) + event.vertex.y;
  coords.x = x;
  coords.y = y;
  return coords;
end

local function jump(event, jumpPos)
  event.torzoJoint = physics.newJoint("touch", event, event.x, event.y);
  event.torzoJoint.maxForce = 1000000
  local coords = getParabolicCoordinates(event, jumpPos);
  event.torzoJoint:setTarget(coords.x, coords.y)
  event.torzoJoint:removeSelf()
end

local function dropRagdoll(event)
  event.torzoJoint = physics.newJoint("touch", event, event.x, event.y);
  event.torzoJoint:setTarget(event.x, event.y+8*pixelRatio)
  event.torzoJoint:removeSelf()
end

local function stitchRagdoll(event)
  event:applyForce( 0, 5*pixelRatio, event.x, event.y );
  if (event.count == 1) then
    print(failCount)
    Runtime:removeEventListener("collision", event)
    failCount = failCount + 1;
    event.count = 2;
    if (failCount == 3) then
    local options =
    {
        effect = "fade",
        time = 400,
    }

    local saveData = loadSave.loadTable("settings.txt");
    if (saveData ~= nil) then
      if (saveData.averageScore == 0) then
        settings.averageScore = scoreCount;
      else
        settings.averageScore = (saveData.averageScore + scoreCount)/2;
      end
      settings.recentScore = scoreCount;
      if(saveData.highScore < scoreCount) then
        settings.highScore = scoreCount;
      end
      settings.totalScore = saveData.totalScore + scoreCount;
    else
      settings.averageScore = scoreCount;
      settings.totalScore = scoreCount;
    end
    print ("average score: "..settings.averageScore);
    loadSave.saveTable(settings, "settings.txt")

    failCount = 0; scoreCount = 0;
    storyboard.gotoScene("menu", options);
  end
  end

end

function jumpRagdoll(event)
  print(event.action)
  if (event.action == "drop") then
    dropRagdoll(event)
  end

  if (event.action == jumpOne or event.action == jumpTwo or event.action == jumpThree) then
      jump(event, event.action);
  end

  if (event.action == "immobalize") then
    stitchRagdoll(event);
  end
end