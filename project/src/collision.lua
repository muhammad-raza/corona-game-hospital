module (..., package.seeall)
local ragdoll = require ("ragdoll")
local loadSave = require ("LoadSave")

local jumpOne = "jumpOne"; local jumpTwo = "jumpTwo"; local jumpThree = "jumpThree"; local scoreCount = 0;

local function getSpeed()
  return 3*pixelRatio;
end

local function setVertex(ragdoll, x, y)
  ragdoll.vertex = {};
  ragdoll.vertex.x = x;
  ragdoll.vertex.y = y;

  local xPos = ragdoll.x - getSpeed();
  local square = (xPos - x)*(xPos - x)
  ragdoll.vertex.a = ((ragdoll.y-y)/square);
  print(ragdoll.vertex.a)
end

function onBedCollision(self, event)
  local ragdollLocal = event.other.parent
  local ragdollHead = ragdollLocal[1];
  if (ragdollHead.count == 1) then
    if (ragdollHead.action == jumpTwo) then
      setVertex(ragdollHead, pointThree+15*pixelRatio, percent*3);
      ragdollHead.action = jumpThree;
    elseif (ragdollHead.action == jumpOne) then
      setVertex(ragdollHead, pointTwo, percent*3);
      ragdollHead.action = jumpTwo;
    elseif (ragdollHead.action == "drop") then
      setVertex(ragdollHead, pointOne, percent*3);
      ragdollHead.action = jumpOne;
    end
    print(ragdollHead.action)
  ragdollHead.count = 2;
  end
  if (event.phase == "ended") then
    timer.performWithDelay(1000, function() ragdollHead.count = 1; end, 1)
  end
end

function onWallBottomSensorCollision(self, event)
  local ragdollLocal = event.other.parent
  ragdollLocal[1].action = "immobalize";
end

local function removeObject(obj)
  obj:removeSelf();
  Runtime:removeEventListener("enterFrame", obj);
  obj = nil;
end

function onAmbulanceWallCollision(self, event)
  local ragdollLocal = event.other.parent;
  ragdollLocal[1].action = "awardAndDestroy";
--  removeObject(ragdollLocal);
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
  event.headJoint = physics.newJoint("touch", event, event.x, event.y);
  local coords = getParabolicCoordinates(event, jumpPos);
  event.headJoint:setTarget(coords.x, coords.y)
  event.headJoint:removeSelf()
end

local function dropRagdoll(event)
  event.headJoint = physics.newJoint("touch", event, event.x, event.y);
  event.headJoint:setTarget(event.x, event.y+8*pixelRatio)
  event.headJoint:removeSelf()
end

local function awardAndDestroyRagdoll()
  scoreCount = scoreCount + 1;
  scoreText.text = "You Saved: "..scoreCount;
  if (scoreCount > settings.highScore) then
    settings.highScore = scoreCount;
    highScoreText.text = "High Score: "..scoreCount
    loadSave.saveTable(settings, "settings.txt")
  end
end

function jumpRagdoll(event)
--  print(event.action)

  if (event.action == "drop") then
    dropRagdoll(event)
  end

  if (event.action == jumpOne or event.action == jumpTwo or event.action == jumpThree) then
      jump(event, event.action);
  end

  if (event.action == "awardAndDestroy") then
    awardAndDestroyRagdoll();
  end
end