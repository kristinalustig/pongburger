C = {}

local ballImages
local paddleImages
local titleScreen
local nowServing
local startingPaddle
local iconOverlay
local mainScreen
local bipSound
local bupSound
local themeMusic
local scoreSound
local numFont
local displayfont
local red
local orange
local yellow
local green
local blue
local purple
local pink
local darkblue
local pbfont
local fontIndex
local colors = {}
local colorIncr
local endingColorIncr
local gameOverBox
local gameOverOne
local gameOverTwo
local tinyFont
local howToPlay

function C.initAssets()
  
  titleScreen =lg.newImage("/assets/pongburger-title.png")
  nowServing = lg.newImage("/assets/now-serving.png")
  iconOverlay = lg.newImage("/assets/icon-overlay.png")
  mainScreen = lg.newImage("/assets/pongburger-ui.png")
  gameOverOne = lg.newImage("/assets/gameOverOne.png")
  gameOverTwo = lg.newImage("/assets/gameOverTwo.png")
  gameOverBox = lg.newImage("/assets/gameOverBox.png")
  howToPlay = lg.newImage("/assets/howToPlay.png")
  
  startingPaddle = lg.newImage("/assets/paddle-plate.png")
  
  bipSound = love.audio.newSource("/assets/audio/bip.mp3", "static")
  bupSound = love.audio.newSource("/assets/audio/bup.mp3", "static")
  bipSound:setVolume(.5)
  bupSound:setVolume(.5)
  themeMusic = love.audio.newSource("/assets/audio/theme.mp3", "stream")
  scoreSound = love.audio.newSource("/assets/audio/winJingle.mp3", "static")
  
  numFont = lg.newFont("/assets/fonts/SpaceGrotesk-SemiBold.ttf", 20)
  displayFont = lg.newFont("/assets/fonts/LondrinaSolid-Regular.ttf", 20)
  tinyFont = lg.newFont("/assets/fonts/ConcertOne-Regular.ttf", 14)
  pbfont = lg.newImageFont("/assets/fonts/pbfont.png", "PONGBURE!AUSCD- HWTLYI")

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
  
  local alpha = .3
  red = {.71, .14, .07, alpha}
  orange = {0.96,0.41,0.04, alpha}
  yellow = {0.96,0.75,0.28, alpha}
  green = {0.34,0.77,0.17, alpha}
  blue = {0.27,0.36,0.91, alpha}
  purple = {0.56,0.09,0.4, alpha}
  pink = {0.96,0.36,0.57, 1}
  darkblue = {0.14,0.12,0.27}
  
  colors = {red, orange, yellow, green, blue, purple}
  fontIndex = 1
  colorIncr = 1
  endingColorIncr = 1

end

function C.getImage(t, n) --type, name
  
  local imgTable = {}
  
  if t == "paddle" then
    imgTable = paddleImages
    if n == "startingPaddle" then return startingPaddle end
  elseif t == "ball" then
    imgTable = ballImages
  end
  
  if n == "bun top" then
    return imgTable.bunTop
  elseif n == "bun bottom" then
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

  if n == "bun top" then
    serving = imgTable.bunTop
    niceName = "the top half of the bun"
  elseif n == "bun bottom" then
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
    niceName = "a blob of good tasty mayonnaise"
  elseif n == "mustard" then
    serving = imgTable.mustard
    niceName = "yellow mustard, yeah!"
  elseif n == "patty" then
    serving = imgTable.patty
    niceName = "a big juicy veggie burger"
  elseif n == "pickle" then
    serving = imgTable.pickle
    niceName = "tangy crispy dill pickles"
  elseif n == "tomato" then
    serving = imgTable.tomato
    niceName = "a beautiful tomato slice"
  end
  
  lg.draw(serving, 370, 340, 0, .5)
  lg.setColor(.95, 93, 146)
  lg.setFont(displayFont)
  lg.printf(niceName, 236, 312, 328, "center")
  lg.printf("press 'enter' to serve", 236, 430, 328, "center")
  
end

function C.draw()
  
  lg.draw(mainScreen, 0, 0, 0, .5, .5)
  
end

function C.drawTitle()
  
  C.drawFancyPBs("PONGBURGER!", 320)
  
  lg.draw(titleScreen, 0, 0, 0, .4, .4)
  
end

function C.drawFancyPBs(bgt, xIncr)
  
  local startingPointX = -1000
  local startingPointY = 10
  local yIncr = 36
  lg.setColor(darkblue)
  love.graphics.rectangle("fill", 0, 0, 800, 800)
  lg.setFont(pbfont)
  if math.fmod(fontIndex,13) == 0 then
    colorIncr = endingColorIncr + 1
    if colorIncr >= 7 then
      colorIncr = 1
    end
  else
    colorIncr = endingColorIncr
  end
  fontIndex = fontIndex + 1
  endingColorIncr = colorIncr
  for i=1, 22, 1 do
    for j=1, 11, 1 do
      lg.setColor(colors[colorIncr])
      lg.printf(bgt, startingPointX, startingPointY, 500, "left")
      startingPointX = startingPointX + xIncr
      colorIncr = colorIncr + 1
      if colorIncr == 7 then
        colorIncr = 1
      end
    end
    startingPointX = -1000 + (yIncr*i)
    startingPointY = startingPointY + yIncr
  end
  
  lg.reset()
  
end

function C.drawGameOver(w)

  local bgt = "PLAYER "
  if w == "p1" then
    bgt = bgt .. "ONE WINS!"
  else
    bgt = bgt .. "TWO WINS!"
  end
  C.drawFancyPBs(bgt, 450)
  lg.draw(gameOverBox, 0, 0, 0, .5, .5)
  if w == "p1" then
    lg.draw(gameOverOne, 0, 0, 0, .5, .5)
  else
    lg.draw(gameOverTwo, 0, 0, 0, .5, .5)
  end
  
end

function C.printWinningBurgerText(txt)
  
  local tooLong = true
  local hadToShorten = false
  while tooLong do
    local _, l = displayFont:getWrap(txt, 300)
    if #l > 6 then
      txt = txt:sub(1, #txt-30)
      hadToShorten = true
    else
      tooLong = false
    end
  end
  
  if hadToShorten then
    txt = txt .. "...etc."
  end
  
  lg.setColor(1, 1, 1)
  lg.setFont(displayFont)
  lg.printf(txt, 240, 330, 300, "left")
  
end

function C.drawPause()
  
  C.drawFancyPBs("PAUSED - PRESS ESC", 500)
  
end

function C.drawIcon(x, y)
  
  lg.draw(iconOverlay, x, y, 0, .5, .5)
  
end

function C.playScoreSound()
  
  scoreSound:play()
  
end

function C.playBip()
  
  bipSound:play()
  
end

function C.playBup()
  
  bupSound:play()
  
end

function C.playTheme()
  
  themeMusic:play()
  themeMusic:setLooping(true)
  
end

function C.setNumFont()
  
  lg.setFont(numFont)
  
end

function C.drawHowToPlay()
  
  C.drawFancyPBs("HOW TO PLAY", 330)
  lg.reset()
  lg.draw(howToPlay, 0, 0, 0, .5, .5)
  
end

function C.setTinyFont()
  
  lg.setFont(tinyFont)
  
end

return C