PlayState = Class{__includes = BaseState}

function PlayState:init()
  entities = {}
  rigidBodies = {}
  triggerBodies = {}

  ground = Ground()
  wall = Wall()

  tilemap = Tilemap(200, 10)
  for i = 1, 10 do
    local newBrickTile = BrickTile(tilemap.x + (i-1)*tilemap.tilewidth, tilemap.y + tilemap.tileheight, tilemap.tilewidth, tilemap.tileheight)
    tilemap[2][i] = newBrickTile
  end

  speedUpGem = SpeedUpGem(500, 700)
  player = Player()

  screenScroll = {}
  screenScroll.x = 0
  screenScroll.y = 0
end

function PlayState:update(dt)

  for i, val in ipairs(entities) do
    val:update(dt)
  end

  screenScroll.x = math.floor(player.x > GAME_WIDTH/3 and -(player.x - GAME_WIDTH/3) or 0)
end

function PlayState:render()
  love.graphics.translate(screenScroll.x, screenScroll.y)

  for i, val in ipairs(entities) do
    val:render()
  end

end
