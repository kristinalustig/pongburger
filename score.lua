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

function S.initScore()
  
  rowOneY = 660
  rowTwoY = 760
  iconWidth = 80
  playerOneScore = 0
  playerTwoScore = 0
  playerModOne = 0
  playerModTwo = 400
  
  
  playerOneIngreds = S.initIngreds(playerModOne)
  playerTwoIngreds = S.initIngreds(playerModTwo)


end

function S.drawScore()
  
  lg.setColor(1, 1, 1)
  lg.printf(playerOneScore, 370, 10, 20, "center")
  
  for _, v in pairs(playerOneIngreds) do
    if v.earned > 0 then
      C.drawIcon(v.x, v.y)
    end
  end
  
  lg.reset()
  
  for _, v in pairs(playerTwoIngreds) do
    if v.earned > 0 then
      C.drawIcon(v.x, v.y)
    end
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
    bunTop = {name = "bunTop", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(1, playerMod)), y = rowOneY},
    bunBottom = {name = "bunBottom", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(1, playerMod)), y = rowTwoY},
    cheese = {name = "cheese", earned = 0, x = playerMod + (iconWidth * 3), y = rowTwoY},
    ketchup = {name = "ketchup", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(2, playerMod)), y = rowOneY},
    lettuce = {name = "lettuce", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(5, playerMod)), y = rowOneY},
    mustard = {name = "mustard", earned = 0, x = playerMod + (iconWidth * 3), y = rowOneY},
    mayo = {name = "mayo", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(4, playerMod)), y = rowOneY},
    patty = {name = "patty", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(2, playerMod)), y = rowTwoY},
    pickle = {name = "pickle", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(5, playerMod)), y = rowTwoY},
    tomato = {name = "tomato", earned = 0, x = playerMod + (iconWidth * invertIfNeeded(4, playerMod)), y = rowTwoY}
  }
  
  return tempTable
  
end

function invertIfNeeded(n, pm)
  
  if pm == playerModOne then
    return n
  else
    return 5 - n
  end
  
end

return S