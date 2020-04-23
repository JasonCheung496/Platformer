Brick = Class{}

function Brick:init()
  self.width = 100
  self.height = 100

  self.x = 200.5
  self.y = 200.5

  self.hitbox = {
    x = self.x,
    y = self.y,
    width = self.width,
    height = self.height
  }

end

function Brick:update(dt)

end

function Brick:render()
  love.graphics.setColor(0.9, 0.1, 0.6, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
