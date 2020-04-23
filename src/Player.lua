Player = Class{}


local img = love.graphics.newImage('Sprites/particle.png')
local font = love.graphics.newFont(40)


chargeBufferTime = 0.2
chargingTime = 0.15
particleEmissionTime = 0.04
speedUpGemBufferTime = 0.4

chargeFactor = 5
friction = 100
gravity = 0--75
moveSpeed = 400

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
  psystem:setParticleLifetime(0.7)
  psystem:setEmissionRate(20)
  psystem:setSizeVariation(1)
  psystem:setPosition(self.x + self.width/2, self.y + self.height/2)
  psystem:setDirection(math.pi)
  psystem:setSpeed(200)
  psystem:setSpread(math.pi/2)
  --psystem:setTangentialAcceleration(10)
  --psystem:setLinearAcceleration(-10, -10, 10, 10)
  psystem:setColors(1, 1, 1, 1, 1, 0, 1, 0.7, 0, 1, 1, 0)

  chargeBufferTimer = 0
  chargingTimer = 0
  particleEmissionTimer = 0
  speedUpGemBufferTimer = 0

end

function Player:update(dt)
  --auto stop the player if no control
  if self.dx < 0 then
    self.dx = math.min(self.dx + friction, 0)
  end
  if self.dx > 0 then
    self.dx = math.max(self.dx - friction, 0)
  end
  if self.dy < 0 then
    self.dy = math.min(self.dy + friction, 0)
  end
  if self.dy > 0 then
    self.dy = math.max(self.dy - friction, 0)
  end

  --Pressing a direction will decelerate if player moves in opposite direction and
  --keep constant speed and won't decelerate in the same direction
  if love.keyboard.isDown("up") then
    self.dy = math.min(math.max(self.dy-moveSpeed, -moveSpeed), self.dy)
  end
  if love.keyboard.isDown("down") then
    self.dy = math.max(math.min(self.dy+moveSpeed, moveSpeed), self.dy)
  end
  if love.keyboard.isDown("left") then
    self.dx = math.min(math.max(self.dx-moveSpeed, -moveSpeed), self.dx)
  end
  if love.keyboard.isDown("right") then
    self.dx = math.max(math.min(self.dx+moveSpeed, moveSpeed), self.dx)
  end

  self.dy = self.dy + gravity

  --charge
  if love.keyboard.isDown("w") and chargeBufferTimer <= 0 then
    chargingTimer = math.min(chargingTimer + dt, chargingTime)
    self.dx, self.dy = self.dx*0.8, self.dy*0.8
  elseif not love.keyboard.isDown("w") then
    if chargingTimer >= chargingTime then
      self.dx, self.dy = self.dx*chargeFactor, self.dy*chargeFactor
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

  --speedUpGem eddect
  if collide(self.hitbox, speedUpGem.hitbox) then
    speedUpGemBufferTimer = speedUpGemBufferTime
  end
  if speedUpGemBufferTimer > 0 and keypressed("w") then
    speedUpGem:effect(self)
  end
  speedUpGemBufferTimer = math.max(speedUpGemBufferTimer - dt, 0)

  --update particle system
  if particleEmissionTimer >= particleEmissionTime then
    psystem:start()
    particleEmissionTimer = 0
  else
    psystem:pause( )
    particleEmissionTimer = particleEmissionTimer + dt
  end

  psystem:setDirection(math.atan(sign(self.dy)/sign(self.dx)) + (self.dx<0 and 0 or math.pi))--correct angle
  psystem:setPosition(self.x + self.width/2, self.y + self.height/2)
  psystem:setEmissionRate(math.max(math.abs(self.dx)*dt*100, math.abs(self.dy)*dt*100))
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
  love.graphics.print(tostring(self.__index == Player), 0, 0)
  love.graphics.print(tostring(chargingTimer), 0, 100)
  love.graphics.print(string.format("x=%f, y=%f, dx=%f, dy=%f", self.x, self.y, self.dx, self.dy), 0, 200)
  love.graphics.print(string.format("hitbox.x=%f,   hitbox.y=%f", self.hitbox.x, self.hitbox.y), 0, 300)

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
