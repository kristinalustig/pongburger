P = {}

local C = require("content")
local S = require("score")

local world
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
local isNowServing
local walls = {}

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
  
  --name, density, x, y
  paddleBlob1.first = P.createPaddleObject("startingPaddle", 1, 24, 200, 1)
  paddleBlob2.first = P.createPaddleObject("startingPaddle", 1, w-24, 200, 1)
  paddleBlob1.others = {}
  paddleBlob2.others = {}
  
  --name, x1, y1, x2, y2
  walls.left = P.createWall("left", 0, 0, 0, h) 
  walls.right = P.createWall("right", w, 0, w, h) 
  walls.top = P.createWall("top", 0, h1, w, h1) 
  walls.bottom = P.createWall("bottom", 0, h2, w, h2) 
  
  --physics-related controls
  playerOneUpKey = "w"
  playerOneDownKey = "s"
  playerTwoUpKey = "up"
  playerTwoDownKey = "down"
  
  --physics constants
  paddleMovementFactor = 1000
  ballVelocityX = -5
  ballVelocityY = 5
  timeBallStuck = 0
  
  --handling scoring on this side (more in score.lua)
  appearedNum = 2
  startNewRoundOnNextCycle = false
  scoringPlayer = 0
  isNowServing = true

end

function P.createPaddleObject(n, d, x, y, num) --name, density, bodyX, bodyY, numPaddle
  
  local tempTable = {}
  
  if num == 1 then
    tempTable.name = n
    tempTable.image = C.getImage("paddle", n)
    tempTable.body = lp.newBody(world, x, y, "dynamic")
    tempTable.shape = lp.newRectangleShape(32, 192)
    tempTable.fixture = lp.newFixture(tempTable.body, tempTable.shape, d)
  else
    tempTable.name = n
    tempTable.image = C.getImage("paddle", n)
    tempTable.shape = lp.newRectangleShape(32+(32*numPaddle*2), 192)
  end
  
  return tempTable

end

function P.createBallObject(n, d, x, y) --name, density, bodyX, bodyY
  
  local tempTable = {}
  
  tempTable.name = n
  tempTable.image = C.getImage("ball", n)
  tempTable.body = lp.newBody(world, x, y, "dynamic")
  tempTable.shape = lp.newRectangleShape(64, 64)
  tempTable.fixture = lp.newFixture(tempTable.body, tempTable.shape, d)

  return tempTable

end

function P.createWall(n, x1, y1, x2, y2) --name, point1 x+y, point2 x+7
  
  local tempTable = {}
  
  tempTable.name = n
  tempTable.body = lp.newBody(world, x, y, "static")
  tempTable.shape = lp.newEdgeShape(x1, y1, x2, y2)
  tempTable.fixture = lp.newFixture(tempTable.body, tempTable.shape, 1)
  
  return tempTable
  
end


function P.draw()
  
  local iterP = 1
  lg.draw(paddleBlob1.first.image, (paddleBlob1.first.body:getX()-(paddleBlob1.first.image:getWidth()/4)), paddleBlob1.first.body:getY()-(paddleBlob1.first.image:getHeight()/4), 0, .5, .5)
  for k, v in pairs(paddleBlob1.others) do
    lg.draw(v.image, (paddleBlob1.first.body:getX()+(v.image:getWidth()/4*iterP)), paddleBlob1.first.body:getY()-(v.image:getHeight()/4), 0, .5, .5)
    iterP = iterP + 1
  end
  
  iterP = 1
  lg.draw(paddleBlob2.first.image, (paddleBlob2.first.body:getX()-(paddleBlob2.first.image:getWidth()/4)), paddleBlob2.first.body:getY()-(paddleBlob2.first.image:getHeight()/4), 0, .5, .5)
  for k, v in pairs(paddleBlob2.others) do
    lg.draw(v.image, (paddleBlob2.first.body:getX()-(v.image:getWidth()/4*iterP)), paddleBlob2.first.body:getY()-(v.image:getHeight()/4), 0, .5, .5)
    iterP = iterP + 1
  end
  
  lg.draw(currentBall.image, currentBall.body:getX()-32, currentBall.body:getY()-32, 0, .5, .5)
  
  if isNowServing then
    C.drawIsNowServing(currentBall.name)
  end
  
end

function P.update(dt)
  
  if startNewRoundOnNextCycle then
    P.startNewRound(scoringPlayer, currentBall.name)
  end
  
  if not isNowServing then
  
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
    
    paddleBlob1.first.body:setX(24)
    paddleBlob2.first.body:setX(776)
    
    local k = love.keyboard.isDown
    
    if k("0") then
      P.startNewRound(0, currentBall.name)
    end
    
    if k(playerOneUpKey) then
      P.movePaddle(paddleBlob1, -1)
    end
    if k(playerOneDownKey) then
      P.movePaddle(paddleBlob1, 1)
    end
    if k(playerTwoUpKey) then
      P.movePaddle(paddleBlob2, -1)
    end
    if k(playerTwoDownKey) then
      P.movePaddle(paddleBlob2, 1)
    end
  
else
  
    if lk.isDown("return") then
      isNowServing = false
    end
    
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
    for k, v in pairs(walls) do
      if contactPoint == v.fixture then
        whichWall = v.name
      end
    end
    
    if whichWall == "" then
      if #paddleBlob1.others > 0 then
        if contactPoint == paddleBlob1.others[#paddleBlob1.others].fixture then
          whichWall = "leftPaddle"
        end
      elseif contactPoint == paddleBlob1.first.fixture then
          whichWall = "leftPaddle"
      end
      if #paddleBlob2.others > 0 then
        if contactPoint == paddleBlob2.others[#paddleBlob2.others].fixture then
          whichWall = "rightPaddle"
        end
      elseif contactPoint == paddleBlob2.first.fixture then
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
      ballVelocityX = 0 - ballVelocityX
    end
    
  end
  
end

function P.checkForStuckBall(newY, oldY)
  
  if newY == oldY then
    timeBallStuck = timeBallStuck + 1
  else
    timeBallStuck = 0
  end
  if timeBallStuck >= 3 then
    print("yes")
    if newY > 400 then
      newY = newY - 10
    else
      newY = newY + 10
    end
    timeBallStuck = 0
    ballVelocityY = 0 - ballVelocityY
  end

  return newY
  
end

function P.startNewRound(scoredPlayerNum, ingredName)
  
  S.updateScore(scoredPlayerNum, ingredName)
  
  local isGameOver = S.checkWinConditions()
  
  if isGameOver then
    ---how to end the game?
  end
  
  if scoredPlayerNum > 0 then
    P.updatePaddle(ingredName, scoredPlayerNum)
  end

  local newBall = ""
  
  local potentialBalls = {}
  local iter = 1
  
  for k, v in ipairs(ballData) do
    if v.name ~= ingredName and v.appeared <= appearedNum then
      potentialBalls[iter] = v
      iter = iter + 1
    end
  end
  
  if #potentialBalls == 0 then
    appearedNum = appearedNum + 1
    newBall = "bunTop"
  else
    local rand = math.random(1, #potentialBalls)
    newBall = potentialBalls[rand]
  end
  
  currentBall.body:destroy()
  
  currentBall = P.createBallObject(newBall.name, 1, w/2, h/2)
  
  startNewRoundOnNextCycle = false
  scoringPlayer = 0
  
  isNowServing = true
  
end

function P.updatePaddle(n, p)
  
  local blob = {}
  
  if p == 1 then 
    blob = paddleBlob1
  else
    blob = paddleBlob2
  end
  
  local newPaddle = P.createPaddleObject(n, 0, 0, 0, #blob.others+1)
  newPaddle.fixture = lp.newFixture(blob.first.body, newPaddle.shape, .5)
  table.insert(blob.others, newPaddle)
  
end

return P