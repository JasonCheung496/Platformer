BrickTile = Class{}

function BrickTile:init(x, y, width, height)
  self.width = width
  self.height = height

  self.x = x
  self.y = y

  self.hitbox = {
    x = self.x,
    y = self.y,
    width = self.width,
    height = self.height
  }
  

end

function BrickTile:update(dt)

end

function BrickTile:render()
  love.graphics.setColor(0.9, 0.1, 0.6, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
