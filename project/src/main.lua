display.setStatusBar( display.HiddenStatusBar )

local physics = require ("physics");
physics.start (true)
--physics.setDrawMode( 'debug' )
--physics.setContinuous( false )
physics.setGravity(0, 0)

settings = {soundOn = true, highScore = 0, averageScore = 0, recentScore = 0, totalScore = 0};
highScore = 0;

local options =
    {
        effect = "fade",
        time = 400,
    }

local storyboard = require "storyboard";
storyboard.gotoScene("menu", options);
