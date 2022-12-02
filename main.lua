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
  INTRO = 2,
  BOARD = 3,
  PAUSE = 4,
  GAME_OVER = 5
}

currentScene = Scenes.TITLE

function love.load()
  
  C.initAssets()
  P.initPhysics()
  S.initScore()
  
end

function love.update(dt)
  
  if currentScene == Scenes.BOARD then
    P.update(dt)
  end
  
end

function love.draw()
  
  if currentScene == Scenes.TITLE then
    C.drawTitle()
  else
    C.draw()
    P.draw()
    S.drawScore()
  end
  
end

function love.keyreleased(k, s)
  
  if currentScene == Scenes.TITLE then
    if k == "return" then
      currentScene = Scenes.BOARD
    end
  elseif currentScene == Scenes.BOARD then
    if k == "escape" then
      currentScene = Scenes.PAUSE
    end
  elseif currentScene == Scenes.PAUSE then
    if k == "return" then
      currentScene = Scenes.BOARD
    end
  end
  
end

