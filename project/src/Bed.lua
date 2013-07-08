module (..., package.seeall)

local image = require("ImageAndSpriteCreation")

local speedOfBed = 30;

function controlBedWithTouch(event)
  if event.phase == "began" then
    xPos = event.x;
  elseif event.phase == "moved" then
    if event.x > xPos then
        moved = "right";
      end
      if event.x < xPos then
        moved = "left";
      end
  elseif event.phase == "ended" then

  end
end

local function goToCenterFromLeft(event)
  event:translate(speedOfBed*pixelRatio, 0);
  if(event.x >= pointCenter) then
    event.x = pointCenter
    moved = "stop";
    end
end

local function goToCenterFromRight(event)
  event:translate(-speedOfBed*pixelRatio, 0);
  if(event.x <= pointCenter) then
    event.x = pointCenter
    moved = "stop";
    end
end

local function goToRight(event)

  event:translate(speedOfBed*pixelRatio, 0);
  if(event.x >= pointRight) then
    event.x = pointRight
    moved = "stop";
    end
end

local function goToLeft(event)

  event:translate(-speedOfBed*pixelRatio, 0);
  if(event.x <= pointLeft) then
    event.x = pointLeft
    moved = "stop";
    end
end

function moveHospitalBed(event)
  local xPosition = math.floor(event.x)
  local pointLeft = math.floor(pointLeft)
  local pointRight = math.floor(pointRight)
  local pointCenter = math.floor(pointCenter)

  if (moved == "right" and xPosition >= pointLeft and xPosition < pointCenter) then
    goToCenterFromLeft(event);
  end

  if (moved == "left" and xPosition <= pointRight and xPosition > pointCenter) then
    goToCenterFromRight(event);
  end
  if (moved == "right" and (xPosition == pointCenter or xPosition >= pointCenter)) then

    goToRight(event);
  end

  if (moved == "left" and (xPosition == pointCenter or xPosition <=pointCenter)) then

    goToLeft(event);
  end

  if(moved == "stop") then
  end
end