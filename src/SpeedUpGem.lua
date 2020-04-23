SpeedUpGem = Class{}

cooldownTime = 1
speedUpFactor = 1.8

function SpeedUpGem:init(x, y)
  self.width = 50
  self.height = 50

  self.x = x
  self.y = y

  self.hitbox = {
    x = self.x - self.width,
    y = self.y - self.height,
    width = self.width + 2*self.width,
    height = self.height + 2*self.height
  }

  self.cooldownTimer = 0

end

function SpeedUpGem:update(dt)
  self.cooldownTimer = math.min(self.cooldownTimer + dt, cooldownTime)
end

function SpeedUpGem:render()
  if self.cooldownTimer >= cooldownTime then
    love.graphics.setColor(0.8, 0.2, 0.1, 1)
  else
    love.graphics.setColor(0.8, 0.2, 0.1, 0.5)
  end

  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function SpeedUpGem:effect(p)
  if p.__index == Player then
    if self.cooldownTimer >= cooldownTime then
      p.dx, p.dy = (p.dx + sign(p.dx)*2000)*speedUpFactor, (p.dy + sign(p.dy)*2000)*speedUpFactor
      self.cooldownTimer = 0
    end
  end

end
