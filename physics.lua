P = {}

local C = require("content")
local S = require("score")

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
local appearedNum
local timeBallStuck
local w, h
local startNewRoundOnNextCycle
local scoringPlayer

function P.initPhysics()
  
  lp.setMeter(100)
  
  w, h, _ = love.window.getMode()
  
  ballData = {
    {name = "bunTop", appeared = 0},
    {name = "bunBottom", appeared = 1},
    {name = "cheese", appeared = 0},
    {name = "ketchup", appeared = 0},
    {name = "lettuce", appeared = 0},
    {name = "mustard", appeared = 0},
    {name = "mayo", appeared = 0},
    {name = "patty", appeared = 0},
    {name = "pickle", appeared = 0},
    {name = "tomato", appeared = 0}
    }
  
  h1 = 40
  h2 = 642

  world = lp.newWorld(0, 0, true)
  
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  
  currentBall = P.createBallObject("bunBottom", 1, w/2, h/2)
  
  objects.walls = {}
  objects.centerLine = {}
  objects.paddleBlob1 = {}
  objects.paddleBlob2 = {}
  
  --name, density, x, y
  objects.paddleBlob1.first = P.createPaddleObject("startingPaddle", 1, 24, 200)
  objects.paddleBlob2.first = P.createPaddleObject("startingPaddle", 1, w-24, 200)
  
  ballData = {}
  
  --name, x1, y1, x2, y2
  objects.walls.left = P.createWall("left", 0, 0, 0, h) 
  objects.walls.right = P.createWall("right", w, 0, w, h) 
  objects.walls.top = P.createWall("top", 0, h1, w, h1) 
  objects.walls.bottom = P.createWall("bottom", 0, h2, w, h2) 
  
  playerOneUpKey = "w"
  playerOneDownKey = "s"
  playerTwoUpKey = "up"
  playerTwoDownKey = "down"
  
  paddleMovementFactor = 1000
  
  ballVelocityX = -5
  ballVelocityY = 5
  
  timeBallStuck = 0
  appearedNum = 2

  startNewRoundOnNextCycle = false
  scoringPlayer = 0

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
  
  local currBallX = currentBall.body:getX()
  local currBallY = currentBall.body:getY()
  local newBallX = currBallX + ballVelocityX
  local newBallY = currBallY + ballVelocityY
  if newBallY < 40 or newBallY > 642 - 32 then
    newBallY = newBallY - ballVelocityY
  end
  newBallY = P.checkForStuckBall(newBallY, currBallY)
  currentBall.body:setX(newBallX)
  currentBall.body:setY(newBallY)
  
  for k, v in pairs(objects.paddleBlob1) do
    v.body:setX(24)
  end
  for k, v in pairs(objects.paddleBlob2) do
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
  
  if startNewRoundOnNextCycle then
    P.startNewRound(scoringPlayer, currentBall.name)
  end
  
end

function P.movePaddle(p, fy)
  
  p.first.body:applyForce(0, fy * paddleMovementFactor)
  
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
      startNewRoundOnNextCycle = true
      scoringPlayer = 2
    elseif whichWall == "right" then
      startNewRoundOnNextCycle = true
      scoringPlayer = 1
    elseif whichWall == "leftPaddle" or whichWall == "rightPaddle" then
      --now we're into paddles
      ballVelocityX = 0 - ballVelocityX
    end
    
  end
  
end

function P.checkForStuckBall(newY, oldY)
  
  if newY == oldY then
    timeBallStuck = timeBallStuck + 1
    if timeBallStuck > 3 then
      timeBallStuck = 0
      if newY < 400 then
        return (newY + 10)
      else
        return (newY - 10)
      end
    end
  end
  
  return newY
  
end

function P.startNewRound(scoredPlayerNum, ingredName)
  
  S.updateScore(scoredPlayerNum, ingredName)
  
  currentBall.body:destroy()
  
  local newBall = ""
  
  local potentialBalls = {}
  
  print("pre loop")
  
  table.insert(ballData, {name = "a", appeared = 0})
  
  for k, v in ipairs(ballData) do
    print("in loop")
    if v.name ~= ingredName and v.appeared <= appearedNum then
      table.insert(potentialBalls, v)
    else
      print("nope" .. v.name .. " and " .. ingredName)
    end
  end
  
  print("post loop")
  
  if #potentialBalls == 0 then
    appearedNum = appearedNum + 1
    newBall = "bunTop"
  else
    local rand = math.random(1, #potentialBalls)
    newBall = potentialBalls[rand]
  end
  
  currentBall = P.createBallObject(newBall, 1, w/2, h/2)
  
  startNewRoundOnNextCycle = false
  scoringPlayer = 0
  
  
end

return P