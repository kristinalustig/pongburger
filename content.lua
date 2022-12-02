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

function C.drawIsNowServing(n)
  
  local imgTable = ballImages
  local serving = nil
  local niceName = ""
  
  lg.draw(nowServing, 236, 260, 0, .5, .5)

  if n == "bunTop" then
    serving = imgTable.bunTop
    niceName = "the top half of the bun"
  elseif n == "bunBottom" then
    serving = imgTable.bunBottom
    niceName = "the bottom half of the bun"
  elseif n == "cheese" then
    serving = imgTable.cheese
    niceName = "a nice slice of cheese. mmm, cheese."
  elseif n == "ketchup" then
    serving = imgTable.ketchup
    niceName = "ooey gooey ketchup"
  elseif n == "lettuce" then
    serving = imgTable.lettuce
    niceName = "crisp, refreshing lettuce"
  elseif n == "mayo" then
    serving = imgTable.mayo
    niceName = "a dollop of good old-fashioned mayonnaise"
  elseif n == "mustard" then
    serving = imgTable.mustard
    niceName = "yellow mustard or brown, your preference!"
  elseif n == "patty" then
    serving = imgTable.patty
    niceName = "a big juicy burger made from veggies or meat"
  elseif n == "pickle" then
    serving = imgTable.pickle
    niceName = "tangy crispy dill pickles"
  elseif n == "tomato" then
    serving = imgTable.tomato
    niceName = "a beautiful tomato slice"
  end
  
  lg.draw(serving, 370, 320, 0, .5)
  lg.printf(niceName, 236, 400, 328, "center")
  lg.printf("press 'enter' to serve", 236, 440, 328, "center")
  
end

function C.draw()
  
  lg.draw(mainScreen, 0, 0, 0, .5, .5)
  
end

function C.drawTitle()
  
  lg.draw(titleScreen, 0, 0, 0, .5, .5)
  lg.printf("PRESS ENTER TO BEGIN", 0, 600, 800, "center")
  
end

function C.drawIcon(x, y)
  
  lg.draw(iconOverlay, x, y, 0, .5, .5)
  
end

return C