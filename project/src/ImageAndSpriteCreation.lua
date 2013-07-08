module (..., package.seeall)

local sprite = require ("sprite")

local img_src = "images/"; local amb = "ambulance";

function setImage (src, width, height, xAxis, yAxis, referencePoint)
  local image = display.newImageRect(img_src..src, width, height )
  image:setReferencePoint(referencePoint)
  image.x= xAxis
  image.y = yAxis
  return image
end

function addSprite(src, width, height, xAxis, yAxis, referencePoint, noOfImg, delay, isRepeat)

    local SpriteSheet = sprite.newSpriteSheet(img_src.. src, width, height);
    local loadSprite = sprite.newSpriteSet(SpriteSheet, 1, noOfImg);
    sprite.add (loadSprite, amb,1, noOfImg, delay, isRepeat);

    local spriteFinal = sprite.newSprite(loadSprite);
    spriteFinal:prepare (amb);
    spriteFinal:play();
    spriteFinal:setReferencePoint(referencePoint);

    spriteFinal.x = xAxis;
    spriteFinal.y = yAxis;
    spriteFinal.type = amb;
    return spriteFinal;
end

function createWalls()
  local wallGroup = display.newGroup();

  local wallBottom         = display.newRect( 0, _H-(percent/2), _W, percent/2 )

  local wallBottomSensor   = display.newRect( 0, _H-(percent/2)-(hospitalBed.contentHeight*3)/4, _W, 1*pixelRatio )
  local wallAmbulance      = display.newRect( 0, _H-(percent/2)-ambulance.contentHeight, pointLeft/2, 1*pixelRatio )

  physics.addBody( wallBottom, "static", {density=1, friction=1, bounce=0} )
  physics.addBody( wallBottomSensor, "static", {density=1, friction=1, isSensor = true} )
  physics.addBody( wallAmbulance, "static", {density=1, friction=1, isSensor = true} )


  wallBottom:setFillColor(0,0,0,0);
  wallBottomSensor:setFillColor(0,0,0,0);
  wallAmbulance:setFillColor(0,0,0,0);

  wallGroup:insert(wallBottom);
  wallGroup:insert(wallBottomSensor);
  wallGroup:insert(wallAmbulance);

  return wallGroup;

end

function removeObject(obj)
  obj:removeSelf();
  Runtime:removeEventListener("enterFrame", obj);
  obj = nil;
end