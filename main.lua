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

local winner = false

function love.load()
  
  C.initAssets()
  P.initPhysics()
  S.initScore()
  C.playTheme()
  
end

function love.update(dt)
  
  if currentScene == Scenes.BOARD then
    local isGameOver = P.update(dt)
    winner = isGameOver
    if isGameOver then
      currentScene = Scenes.GAME_OVER
    end
  end
  
end

function love.draw()
  
  if currentScene == Scenes.BOARD or currentScene == Scenes.PAUSE then
    C.draw()
    P.draw()
    S.drawScore()
    if currentScene == Scenes.PAUSE then
      C.drawPause()
    end
  elseif currentScene == Scenes.TITLE then
    C.drawTitle()
  elseif currentScene == Scenes.INTRO then
    C.drawHowToPlay()
  elseif currentScene == Scenes.GAME_OVER then
    C.drawGameOver(winner)
    P.drawGameOverDetails()
  end
  
end

function love.keyreleased(k, s)
  
  if currentScene == Scenes.INTRO then
    if k == "return" then
      currentScene = Scenes.BOARD
    end
  elseif currentScene == Scenes.TITLE then
    if k == "return" then
      currentScene = Scenes.INTRO
    end
  elseif currentScene == Scenes.BOARD then
    if k == "escape" then
      currentScene = Scenes.PAUSE
    end
  elseif currentScene == Scenes.PAUSE then
    if k == "return" then
      currentScene = Scenes.BOARD
    end
  elseif currentScene == Scenes.GAME_OVER then
    if k == "y" then
      P.resetAll()
      currentScene = Scenes.TITLE
    end
  end
  
end

