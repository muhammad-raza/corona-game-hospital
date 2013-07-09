-- Abstract: Ragdoll sample project
-- A port of the ragdoll from http://www.box2dflash.org/
--
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- History
--  1.0		6/7/12		Initial version
-------------------------------------------------------------------------------------

local ragdoll = {}

local function setFill(ob, param)
	ob:setFillColor(param[1], param[2], param[3], param[4] or 255)
end

ragdoll.newRagDoll = function(originX, originY, colorTable) 
       
	--> Create Ragdoll Group
	 
	local spacing = 1

	local ragdoll = display.newGroup ()
	 
	local startX = originX
	local startY = originY

    local head = display.newCircle( 0, 0, 4*pixelRatio )
	head.x = startX
	head.y = startY
    head.type = "ragdoll"
	setFill(head, colorTable)
	ragdoll:insert (head)

	local w,h = 7.5*pixelRatio,5*pixelRatio

	-- Torso1
	local torsoA = display.newRect( -w*0.5, -h*0.5, w, h )
	torsoA:translate( startX, (startY + 9*pixelRatio) )
    torsoA.type = "ragdoll"
	setFill(torsoA, colorTable)
	ragdoll:insert (torsoA)

	-- Torso2
	local torsoB = display.newRect( -w*0.5, -h*0.5, w, h )
	torsoB:translate( startX-0.5*pixelRatio, (startY + 13*pixelRatio) )
	setFill(torsoB, colorTable)
    torsoB.type = "ragdoll"
	ragdoll:insert (torsoB)

	-- Torso3
	local torsoC = display.newRect( -w*0.5, -h*0.5, w, h )
	torsoC:translate( startX, (startY + 16*pixelRatio) )
    torsoC.type = "ragdoll"
	setFill(torsoC, colorTable)
	ragdoll:insert (torsoC)

	-- UpperArm
	local w,h = 9*pixelRatio,3*pixelRatio

	-- L
	local upperArmL = display.newRect( -w*0.5, -h*0.5, w, h )
	upperArmL:translate( (startX - 6*pixelRatio), (startY + 6*pixelRatio) )
    upperArmL.type = "ragdoll"
	setFill(upperArmL, colorTable)
	ragdoll:insert (upperArmL)

	-- R
	local upperArmR = display.newRect( -w*0.5, -h*0.5, w, h )
	upperArmR:translate( (startX + 6*pixelRatio), (startY + 6*pixelRatio) )
    upperArmR.type = "ragdoll"
	setFill(upperArmR, colorTable)
	ragdoll:insert (upperArmR)
	-- LowerArm
	local w,h = 9*pixelRatio,3*pixelRatio

	-- L
	local lowerArmL = display.newRect( -w*0.5, -h*0.5, w, h )
	lowerArmL:translate( (startX - 15*pixelRatio), (startY + 6*pixelRatio) )
    lowerArmL.type = "ragdoll"
	setFill(lowerArmL, colorTable)
	ragdoll:insert (lowerArmL)

	-- R
	local lowerArmR = display.newRect( -w*0.5, -h*0.5, w, h )
	lowerArmR:translate( (startX + 15*pixelRatio), (startY + 6*pixelRatio) )
    lowerArmR.type = "ragdoll"
	setFill(lowerArmR, colorTable)
	ragdoll:insert (lowerArmR)

	-- UpperLeg
	local w,h = 3*pixelRatio,11*pixelRatio

	-- L
	local upperLegL = display.newRect( -w*0.5, -h*0.5, w, h )
	upperLegL:translate( (startX - 2.5*pixelRatio), (startY + 23*pixelRatio) )
    upperLegL.type = "ragdoll"
	setFill(upperLegL, colorTable)
	ragdoll:insert (upperLegL)

	-- R
	local upperLegR = display.newRect( -w*0.5, -h*0.5, w, h )
	upperLegR:translate( (startX + 2.5*pixelRatio), (startY + 23*pixelRatio) )
    upperLegR.type = "ragdoll"
	setFill(upperLegR, colorTable)
	ragdoll:insert (upperLegR)

	-- LowerLeg
	local w,h = 3*pixelRatio,10*pixelRatio

	-- L
	local lowerLegL = display.newRect( -w*0.5, -h*0.5, w, h )
	lowerLegL:translate( (startX - 2.5*pixelRatio), (startY + 33*pixelRatio) )
    lowerLegL.type = "ragdoll"
	setFill(lowerLegL, colorTable)
	ragdoll:insert (lowerLegL)

	-- R
	local lowerLegR = display.newRect( -w*0.5, -h*0.5, w, h )
	lowerLegR:translate( (startX + 2.5*pixelRatio), (startY + 33*pixelRatio) )
    lowerLegR.type = "ragdoll"
	setFill(lowerLegR, colorTable)
	ragdoll:insert (lowerLegR)

    local d=1
local e=0
local f=1
local collisionFilter = { categoryBits = 2, maskBits = 1 };

	physics.addBody (head, "dynamic",{bounce = 0, density=1.0, friction=0.4, radius = 4*pixelRatio, filter = collisionFilter})
	physics.addBody (torsoA, "dynamic",{bounce = e, density=d, friction = f, filter = collisionFilter})
	physics.addBody (torsoB, "dynamic",{bounce = e, density=d, friction = f, filter = collisionFilter})
	physics.addBody (torsoC, "dynamic",{bounce = e, density=d, friction = f, filter = collisionFilter})
	physics.addBody (upperArmL, "dynamic",{bounce = e, density=d, friction = f, filter = collisionFilter})
	physics.addBody (upperArmR, "dynamic",{bounce = e, density=d, friction = f, filter = collisionFilter})
	physics.addBody (lowerArmL, "dynamic",{bounce = e, density=d, friction = f, filter = collisionFilter})
	physics.addBody (lowerArmR, "dynamic",{bounce = e, density=d, friction = f, filter = collisionFilter})
	physics.addBody (upperLegL, "dynamic",{bounce = e, density=d, friction = f, filter = collisionFilter})
	physics.addBody (upperLegR, "dynamic",{bounce = e, density=d, friction = f, filter = collisionFilter})
	physics.addBody (lowerLegL, "dynamic",{bounce = e, density=d, friction = f, filter = collisionFilter})
	physics.addBody (lowerLegR, "dynamic",{bounce = e, density=d, friction = f, filter = collisionFilter})
--]]
	local function addFrictionJoint(a, b, posX, posY, lowerAngle, upperAngle, mT) 
		local j = physics.newJoint ( "pivot", a, b, posX, posY, rFrom, rTo)
		j.isLimitEnabled = true
		j:setRotationLimits (lowerAngle, upperAngle)
		return j
	end

	-- Head to shoulders

    addFrictionJoint( torsoA, head, head.x, head.y+(2*pixelRatio), 1, 1 )

	-- Upper arm to shoulders
	-- L
	addFrictionJoint( torsoA, upperArmL, torsoA.x-2, torsoA.y-2, -1, 1 )

	-- R
	addFrictionJoint( torsoA, upperArmR, torsoA.x+2, torsoA.y-2, -1, 1 )

	-- Lower arm to upper arm
	-- L
	addFrictionJoint( upperArmL, lowerArmL, upperArmL.x-(upperArmL.contentWidth/2), upperArmL.y, -1,1 )

	-- R
	addFrictionJoint( upperArmR, lowerArmR, upperArmR.x+(upperArmR.contentWidth/2), upperArmR.y, -1, 1 )

	-- Shoulders/stomach
	local j = addFrictionJoint( torsoA, torsoB, torsoA.x, torsoA.y, 1,1 )

	-- Stomach/hips
	addFrictionJoint( torsoB, torsoC, torsoB.x, torsoB.y, 1,1 )

	-- L
	addFrictionJoint( torsoC, upperLegL, torsoC.x-2, torsoC.y+5, 1,1 )

	-- R
	addFrictionJoint( torsoC, upperLegR, torsoC.x+2, torsoC.y+5, 1,1 )
	-- L
	addFrictionJoint( upperLegL, lowerLegL, upperLegL.x, upperLegL.y+(upperLegL.contentWidth/2+3), 1,1 )

	-- R
	addFrictionJoint( upperLegR, lowerLegR, upperLegR.x, upperLegR.y+(upperLegR.contentWidth/2+3), 1,1 )

	return ragdoll
end

return ragdoll