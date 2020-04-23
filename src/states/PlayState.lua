PlayState = Class{__includes = BaseState}

function PlayState:init()
  player = Player()
  ground = Ground()
  wall = Wall()
  brick = Brick()

  rigidBodies = {player, ground, wall, brick}
end

function PlayState:update(dt)

  wall:update(dt)
  ground:update(dt)

  brick:update(dt)

  player:update(dt)

end

function PlayState:render()

  wall:render()
  ground:render()

  brick:render()

  player:render()

end
