C = {}

local ballImages
local paddleImages
local titleScreen
local nowServing
local gameOverScreen
local startingPaddle
local iconOverlay
local mainScreen

function C.initAssets()
  
  titleScreen =lg.newImage("/assets/pongburger-title.png")
  nowServing = lg.newImage("/assets/now-serving.png")
  iconOverlay = lg.newImage("/assets/icon-overlay.png")
  gameOverScreen = lg.newImage("/assets/pongburger-title.png")
  mainScreen = lg.newImage("/assets/pongburger-ui.png")
  
  startingPaddle = lg.newImage("/assets/paddle-plate.png")

  ballImages = {
    bunTop = lg.newImage("/assets/ball-bun-top.png"),
    bunBottom = lg.newImage("/assets/ball-bun-bottom.png"),
    cheese = lg.newImage("/assets/ball-cheese.png"),
    ketchup = lg.newImage("/assets/ball-ketchup.png"),
    lettuce = lg.newImage("/assets/ball-lettuce.png"),
    mustard = lg.newImage("/assets/ball-mustard.png"),
    mayo = lg.newImage("/assets/ball-mayo.png"),
    patty = lg.newImage("/assets/ball-patty.png"),
    pickle = lg.newImage("/assets/ball-pickle.png"),
    tomato = lg.newImage("/assets/ball-tomato.png")
  }
  
  paddleImages = {
    bunTop = lg.newImage("/assets/paddle-bun-top.png"),
    bunBottom = lg.newImage("/assets/paddle-bun-bottom.png"),
    cheese = lg.newImage("/assets/paddle-cheese.png"),
    ketchup = lg.newImage("/assets/paddle-ketchup.png"),
    lettuce = lg.newImage("/assets/paddle-lettuce.png"),
    mustard = lg.newImage("/assets/paddle-mustard.png"),
    mayo = lg.newImage("/assets/paddle-mayo.png"),
    patty = lg.newImage("/assets/paddle-patty.png"),
    pickle = lg.newImage("/assets/paddle-pickle.png"),
    tomato = lg.newImage("/assets/paddle-tomato.png")
    }

end

function C.getImage(t, n) --type, name
  
  local imgTable = {}
  
  if t == "paddle" then
    imgTable = paddleImages
    if n == "startingPaddle" then return startingPaddle end
  elseif t == "ball" then
    imgTable = ballImages
  end
  
  if n == "bunTop" then
    return imgTable.bunTop
  elseif n == "bunBottom" then
    return imgTable.bunBottom
  elseif n == "cheese" then
    return imgTable.cheese
  elseif n == "ketchup" then
    return imgTable.ketchup
  elseif n == "lettuce" then
    return imgTable.lettuce
  elseif n == "mayo" then
    return imgTable.mayo
  elseif n == "mustard" then
    return imgTable.mustard
  elseif n == "patty" then
    return imgTable.patty
  elseif n == "pickle" then
    return imgTable.pickle
  elseif n == "tomato" then
    return imgTable.tomato
  end
  
end

function C.draw()
  
  lg.draw(mainScreen, 0, 0, 0, .5, .5)
  
end

function C.drawIcon(x, y)
  
  lg.draw(iconOverlay, x, y, 0, .5, .5)
  
end

return C