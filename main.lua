push = require "lib/push"
Class = require "lib/class"

require "src/Player"
require "src/Ground"
require "src/Wall"
require "src/Brick"
require "src/SpeedUpGem"
require "src/Tilemap"

require 'lib/StateMachine'
require 'src/states/BaseState'
require 'src/states/PlayState'


GAME_WIDTH, GAME_HEIGHT = 1600, 900
local WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()
WINDOW_WIDTH, WINDOW_HEIGHT = WINDOW_WIDTH*0.8, WINDOW_HEIGHT*0.8



function love.load()
  push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

  love.graphics.setDefaultFilter("nearest", "nearest")

  gGameState = StateMachine {
      ['play'] = function() return PlayState() end
  }
  gGameState:change('play')

  inputTable = {}

end

function love.update(dt)

  gGameState:update(dt)


  inputTable = {}
end

function love.draw()
  push:start()

  gGameState:render()

  push:finish()
end


function love.resize(w, h)
  push:resize(w, h)
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  else
    inputTable[key] = true
  end
end

function collide(hitbox1, hitbox2)
  if hitbox1.x + hitbox1.width <= hitbox2.x or hitbox1.x >= hitbox2.x + hitbox2.width then
    return false
  end
  if hitbox1.y + hitbox1.height <= hitbox2.y or hitbox1.y >= hitbox2.y + hitbox2.height then
    return false
  end
  return true
end

function keypressed(key)
  return inputTable[key]
end

function sign(num)
  if num > 0 then
    return 1
  elseif num == 0 then
    return 0
  else
    return -1
  end
end
