Ground = Class{}

function Ground:init()
  self.width = 3000
  self.height = 100

  self.x = 0
  self.y = GAME_HEIGHT-self.height

  self.hitbox = {
    x = self.x,
    y = self.y,
    width = self.width,
    height = self.height
  }

end

function Ground:update(dt)

end

function Ground:render()
  love.graphics.setColor(0.5, 0.8, 0.7, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
