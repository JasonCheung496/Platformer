Player = Class{}

Player.speed = 400
Player.friction = 100

local img = love.graphics.newImage('particle.png')
local font = love.graphics.newFont(40)

chargeBufferTime = 0.3
chargingTime = 0.3
gravity = 50

function Player:init()
  self.x = 0
  self.y = 0

  self.width = 50
  self.height = 50

  self.dx = 0
  self.dy = 0

  self.hitbox = {
    x = self.x,
    y = self.y,
    width = self.width,
    height = self.height
  }

  psystem = love.graphics.newParticleSystem(img, 1000)
  psystem:setParticleLifetime(1)
  psystem:setEmissionRate(20)
  psystem:setSizeVariation(1)
  psystem:setPosition(self.x + self.width/2, self.y + self.height/2)
  psystem:setDirection(math.pi)
  psystem:setSpeed(100)
  psystem:setSpread(math.pi/2)
  --psystem:setTangentialAcceleration(10)
  --psystem:setLinearAcceleration(-10, -10, 10, 10)
  psystem:setColors(1, 1, 1, 1, 1, 0, 1, 0.7, 0, 1, 1, 0)

  chargeBufferTimer = 0
  chargingTimer = 0

end

function Player:update(dt)
  --Pressing a direction will decelerate if player moves in opposite direction and
  --keep constant speed and won't decelerate in the same direction
  if love.keyboard.isDown("up") then
    self.dy = math.min(math.max(self.dy-Player.speed, -Player.speed), self.dy)
  end
  if love.keyboard.isDown("down") then
    self.dy = math.max(math.min(self.dy+Player.speed, Player.speed), self.dy)
  end
  if love.keyboard.isDown("left") then
    self.dx = math.min(math.max(self.dx-Player.speed, -Player.speed), self.dx)
  end
  if love.keyboard.isDown("right") then
    self.dx = math.max(math.min(self.dx+Player.speed, Player.speed), self.dx)
  end

  self.dy = self.dy + gravity

  --charge
  if love.keyboard.isDown("w") and chargeBufferTimer <= 0 then
    chargingTimer = math.min(chargingTimer + dt, chargingTime)
  elseif not love.keyboard.isDown("w") then
    if chargingTimer >= chargingTime then
      self.dy = self.dy*6
      self.dx = self.dx*6
      chargeBufferTimer = chargeBufferTime
    end
    chargingTimer = 0
  end

  chargeBufferTimer = math.max(chargeBufferTimer - dt, 0)


  --handle collision x-axis
  self.x = self.x + self.dx*dt
  self:updateHitbox()

  for k, val in pairs(rigidBodies) do
    if val ~= self then
      self:collideWithRigidbody(val, "x")
    end
  end

  --handle collision y-axis
  self.y = self.y + self.dy*dt
  self:updateHitbox()

  for k, val in pairs(rigidBodies) do
    if val ~= self then
      self:collideWithRigidbody(val, "y")
    end
  end




  if self.dx < 0 then
    self.dx = math.min(self.dx + Player.friction, 0)
  end
  if self.dx > 0 then
    self.dx = math.max(self.dx - Player.friction, 0)
  end

  --[[if self.dy < 0 then
    self.dy = math.min(self.dy + Player.friction, 0)
  end
  if self.dy > 0 then
    self.dy = math.max(self.dy - Player.friction, 0)
  end]]--


  psystem:setDirection(math.atan(sign(self.dy)/sign(self.dx)))
  psystem:setPosition(self.x + self.width/2, self.y + self.height/2)
  psystem:setEmissionRate(math.max(math.abs(self.dx)*dt*20, math.abs(self.dy)*dt*20))

  psystem:update(dt)

end

function Player:render()
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.draw(psystem, 0, 0)
  if chargingTimer > 0 then
    --add random wiggle
    love.graphics.rectangle("fill", self.x + math.random(-3, 3), self.y + math.random(-3, 3), self.width, self.height)
  else
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  end

  love.graphics.setFont(font)
  love.graphics.print(tostring(math.floor(2.9) + 1.5 - math.floor(1.5)), 0, 0)
  love.graphics.print(tostring(chargingTimer), 0, 100)
  love.graphics.print(string.format("x=%f, y=%f, dx=%f, dy=%f", self.x, self.y, self.dx, self.dy), 0, 200)
  love.graphics.print(string.format("hitbox.x=%f,   hitbox.y=%f", self.hitbox.x, self.hitbox.y), 0, 300)

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

function Player:updateHitbox()
  self.hitbox = {
    x = self.x,
    y = self.y,
    width = self.width,
    height = self.height
  }
end
--separate different cases for different axes
function Player:collideWithRigidbody(obj, axis)
  if collide(self.hitbox, obj.hitbox) then
    self[axis] = math.floor(self[axis]) + obj[axis] - math.floor(obj[axis])
    self:updateHitbox()
    while collide(self.hitbox, obj.hitbox) do
      self[axis] = self[axis] - sign(self["d"..axis])
      self:updateHitbox()
    end
    self["d"..axis] = 0
  end
end
