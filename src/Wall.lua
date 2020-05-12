Wall = Class{}

function Wall:init()
  self.width = 100
  self.height = GAME_HEIGHT

  self.x = GAME_WIDTH+2000
  self.y = 0

  self.hitbox = {
    x = self.x,
    y = self.y,
    width = self.width,
    height = self.height
  }

  table.insert(entities, self)
  table.insert(rigidBodies, self)
  
end

function Wall:update(dt)

end

function Wall:render()
  love.graphics.setColor(0.3, 0.7, 0.4, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
