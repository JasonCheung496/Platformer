PlayState = Class{__includes = BaseState}

function PlayState:init()
  player = Player()
  ground = Ground()
  wall = Wall()
  brick = Brick()
  speedUpGem = SpeedUpGem(500, 700)

  rigidBodies = {player, ground, wall, brick}
  triggerBodies = {speedUpGem}

  screenScroll = {}
  screenScroll.x = 0
  screenScroll.y = 0
end

function PlayState:update(dt)

  wall:update(dt)
  ground:update(dt)
  brick:update(dt)

  speedUpGem:update(dt)

  player:update(dt)

  screenScroll.x = math.floor(player.x > GAME_WIDTH/3 and -(player.x - GAME_WIDTH/3) or 0)
end

function PlayState:render()
  love.graphics.translate(screenScroll.x, screenScroll.y)

  wall:render()
  ground:render()
  brick:render()

  speedUpGem:render()

  player:render()

end
