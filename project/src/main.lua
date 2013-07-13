display.setStatusBar( display.HiddenStatusBar )

local physics = require ("physics")
physics.start (true)
--physics.setDrawMode( 'debug' )
--physics.setContinuous( false )
physics.setGravity(0, 0)

local storyboard = require "storyboard";
storyboard.gotoScene("menu");