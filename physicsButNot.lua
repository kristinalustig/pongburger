P = {}

local C = require("content")
local H = require("helper")

local world
local objects = {}
local startingXPaddle
local startingYPaddle
local currentBall
local ballData = {}
local playerOneUpKey
local playerOneDownKey
local playerTwoUpKey
local playerTwoDownKey
local paddleBlob1 = {}
local paddleBlob2 = {}
local ballVelocityX
local ballVelocityY

local paddleMovementFactor
local ballMovementFactor

function P.initPhysics()
  
  lp.setMeter(100)
  
  local w, h, _ = love.window.getMode()
  
  h1 = 40
  h2 = 642

  world = lp.newWorld(0, 0, true)
  
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  
  currentBall = P.createBallObject("patty", 1, w/2, h/2)
  
  objects.walls = {}
  objects.centerLine = {}
  objects.paddleBlob1 = {}
  objects.paddleBlob2 = {}
  
  --name, density, x, y
  objects.paddleBlob1.first = P.createPaddleObject("startingPaddle", 5, 24, 200)
  objects.paddleBlob2.first = P.createPaddleObject("startingPaddle", 5, w-24, 200)
  
  ballData = {}
  
  --x, y, w, h
  objects.walls.left = P.createWall("left", 0, h1, 0, h2) 
  objects.walls.right = P.createWall("right", w, h1, w, h2) 
  objects.walls.top = P.createWall("top", 0, h1, w, h1) 
  objects.walls.bottom = P.createWall("bottom", 0, h2, w, h2) 
  
  playerOneUpKey = "w"
  playerOneDownKey = "s"
  playerTwoUpKey = "up"
  playerTwoDownKey = "down"
  
  paddleMovementFactor = 10
  
  ballVelocityX = -5
  ballVelocityY = 5


end

function P.createPaddleObject(n, d, x, y) --name, density
  
  local tempTable = {}
  
  tempTable.name = n
  tempTable.image = C.getImage("paddle", n)
  tempTable.body = lp.newBody(world, x, y, "dynamic")
  tempTable.shape = lp.newRectangleShape(32, 192)
  tempTable.fixture = lp.newFixture(tempTable.body, tempTable.shape, d)
  
  return tempTable

end

function P.createBallObject(n, d, x, y) --name, density
  
  local tempTable = {}
  
  tempTable.name = n
  tempTable.image = C.getImage("ball", n)
  tempTable.body = lp.newBody(world, x, y, "dynamic")
  tempTable.shape = lp.newRectangleShape(64, 64)
  tempTable.fixture = lp.newFixture(tempTable.body, tempTable.shape, d)

  return tempTable

end

function P.createWall(n, x1, y1, x2, y2)
  
  local tempTable = {}
  
  tempTable.name = n
  tempTable.body = lp.newBody(world, x, y, "static")
  tempTable.shape = lp.newEdgeShape(x1, y1, x2, y2)
  tempTable.fixture = lp.newFixture(tempTable.body, tempTable.shape, 1)
  
  return tempTable
  
end


function P.draw()
  
  for k, v in pairs(objects.paddleBlob1) do
    lg.draw(v.image, v.body:getX()-(v.image:getWidth()/4), v.body:getY()-(v.image:getHeight()/4), 0, .5, .5)
  end
  
  for k, v in pairs(objects.paddleBlob2) do
    lg.draw(v.image, v.body:getX()-(v.image:getWidth()/4), v.body:getY()-(v.image:getHeight()/4), 0, .5, .5)
  end
  
  lg.draw(currentBall.image, currentBall.body:getX()-32, currentBall.body:getY()-32, 0, .5, .5)
  
end

function P.update(dt)
  
  world:update(dt)
  
  currentBall.body:setX(currentBall.body:getX() + ballVelocityX)
  currentBall.body:setY(currentBall.body:getY() + ballVelocityY)
  
  for k, v in pairs(objects.paddleBlob1) do
    local _, velY = v.body:getLinearVelocity()
    v.body:setLinearVelocity(0, velY)
    v.body:setX(24)
  end
  for k, v in pairs(objects.paddleBlob2) do
    local _, velY = v.body:getLinearVelocity()
    v.body:setLinearVelocity(0, velY)
    v.body:setX(776)
  end
  
  local k = love.keyboard.isDown
  
  if k(playerOneUpKey) then
    P.movePaddle(objects.paddleBlob1, -1)
  end
  if k(playerOneDownKey) then
    P.movePaddle(objects.paddleBlob1, 1)
  end
  if k(playerTwoUpKey) then
    P.movePaddle(objects.paddleBlob2, -1)
  end
  if k(playerTwoDownKey) then
    P.movePaddle(objects.paddleBlob2, 1)
  end
  
end

function P.movePaddle(p, fy)
  
  local by = p.first.body:getY()
  if p.first.body:isTouching(objects.walls.top.body) and fy < 0 then
    return
  elseif p.first.body:isTouching(objects.walls.bottom.body) and fy > 0 then
    return
  else
    by = by + (fy * paddleMovementFactor)
  end
  
  p.first.body:setY(by)
  
end

function beginContact(a, b, coll)
  
  local doesContactInvolveBall = false
  local ball = nil
  local contactPoint = nil
  local whichWall = ""
  
  if a == currentBall.fixture then
    doesContactInvolveBall = true
    ball = a
    contactPoint = b
  elseif b == currentBall.fixture then
    doesContactInvolveBall = true
    ball = b
    contactPoint = a
  end
  
  if doesContactInvolveBall then
    for k, v in pairs(objects.walls) do
      if contactPoint == v.fixture then
        whichWall = v.name
      end
    end
    
    if whichWall == "" then
      if contactPoint == objects.paddleBlob1.first.fixture then
        whichWall = "leftPaddle"
      else
        whichWall = "rightPaddle"
      end
    end
    
    if whichWall == "top" or whichWall == "bottom" then
      ballVelocityY = 0 - ballVelocityY
    elseif whichWall == "left" then
      --point for Player 2!
    elseif whichWall == "right" then
      --point for Player 1!
    elseif whichWall == "leftPaddle" or whichWall == "rightPaddle" then
      --now we're into paddles
      ballVelocityX = 0 - ballVelocityX
    end
  end
  
end

return P