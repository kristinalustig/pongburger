local C = require("content")
local P = require("physics")
local S = require("score")

lg = love.graphics
lk = love.keyboard
lp = love.physics
la = love.audio

Scenes = 
{
  TITLE = 1,
  BOARD = 2,
  PAUSE = 3,
  GAME_OVER = 4
}

function love.load()
  
  C.initAssets()
  P.initPhysics()
  S.initScore()
  
end

function love.update(dt)
  
  P.update(dt)
  
end

function love.draw()
  
  C.draw()
  P.draw()
  S.drawScore()
  
end
