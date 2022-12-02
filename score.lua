S = {}

local C = require("content")

local playerOneScore
local playerTwoScore
local playerOneIngreds = {}
local playerTwoIngreds = {}
local rowOneY
local rowTwoY
local iconWidth
local playerModOne
local playerModTwo
local winningScore

function S.initScore()
  
  rowOneY = 656
  rowTwoY = 720
  iconWidth = 80
  playerOneScore = 0
  playerTwoScore = 0
  playerModOne = 16
  playerModTwo = 416
  winningScore = 15
  
  playerOneIngreds = S.initIngreds(playerModOne)
  playerTwoIngreds = S.initIngreds(playerModTwo)

end

function S.resetAll()
  
  playerOneIngreds = S.initIngreds(playerModOne)
  playerTwoIngreds = S.initIngreds(playerModTwo)
  
  playerOneScore = 0
  playerTwoScore = 0
  
end

function S.drawScore()
  
  lg.setColor(1, 1, 1)
  C.setNumFont()
  lg.printf(playerOneScore, 360, 10, 30, "right")
  lg.printf(playerTwoScore, 410, 10, 30, "left")
  
  C.setTinyFont()
  
  for _, v in pairs(playerOneIngreds) do
    if v.earned > 0 then
      C.drawIcon(v.x, v.y)
    end
    lg.printf(v.name, v.x-16, v.y + 48, 80, "center")
  end
  
  lg.reset()
  
  C.setTinyFont()
  
  for _, v in pairs(playerTwoIngreds) do
    if v.earned > 0 then
      C.drawIcon(v.x, v.y)
    end
    lg.printf(v.name, v.x-16, v.y + 48, 80, "center")
  end
  
end

function S.updateScore(player, ingredName)
  
  if player == 1 then
    for _, v in pairs(playerOneIngreds) do
      if v.name == ingredName then
        v.earned = v.earned + 1
      end
    end
    playerOneScore = playerOneScore + 1
  elseif player == 2 then
    for _, v in pairs(playerTwoIngreds) do
      if v.name == ingredName then
        v.earned = v.earned + 1
      end
    end
    playerTwoScore = playerTwoScore + 1
  end
  
end

function S.initIngreds(playerMod)
  
  local tempTable = 
  {
    bunTop = {name = "bun top", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(1, playerMod)), y = rowOneY},
    bunBottom = {name = "bun bottom", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(1, playerMod)), y = rowTwoY},
    cheese = {name = "cheese", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(3, playerMod)), y = rowTwoY},
    ketchup = {name = "ketchup", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(2, playerMod)), y = rowOneY},
    lettuce = {name = "lettuce", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(5, playerMod)), y = rowOneY},
    mustard = {name = "mustard", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(3, playerMod)), y = rowOneY},
    mayo = {name = "mayo", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(4, playerMod)), y = rowOneY},
    patty = {name = "patty", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(2, playerMod)), y = rowTwoY},
    pickle = {name = "pickle", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(5, playerMod)), y = rowTwoY},
    tomato = {name = "tomato", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(4, playerMod)), y = rowTwoY}
  }
  
  return tempTable
  
end

function invertIfNeeded(n, pm)
  
  if pm == playerModOne then
    return n-1
  else
    return 5 - n
  end
  
end

function S.checkWinConditions()

  local p1Wins = true
  local p2Wins = true
  for _, v in pairs(playerOneIngreds) do
    if v.earned == 0 then
      p1Wins = false
    end
  end
  
  for _, v in pairs(playerTwoIngreds) do
    if v.earned == 0 then
      p2Wins = false
    end
  end
  
  if playerOneScore >= winningScore then
    p1Wins = true
  elseif playerTwoScore >= winningScore then
    p2Wins = true
  end

  
  return p1Wins, p2Wins
  
end

return S