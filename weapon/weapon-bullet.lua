Bullet = Class {
  init = function(self, x, y, image)
    self.box = {
      x = x,
      y = y,
      w = BULLET_INITIAL_DIMENSIONS.w,
      h = BULLET_INITIAL_DIMENSIONS.h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);
    self.image = image;

    self.velocity = { x = 0, y = BULLET_SPEED };

    self.hasLifespan = false;
    self.lifeTimer = Timer.new();
    self.isOffScreen = false;

    self.isBossForcefield = false;
    self.forcefieldPosition = 0;
    self.forcefieldTimer = 0;
    self.boss = nil;

    self.active = true;
    self.type = "bullet";
  end
};

function Bullet:setLife(life)
  self.hasLifespan = true;
  self.lifeTimer:after(life, function() self.active = false end);
end

function Bullet:update(dt, player)
  if not self.active then
    return;
  end

  if self.hasLifespan then
    self.lifeTimer:update(dt);
  end

  if self.isBossForcefield then
    self:protectBoss(dt);
  else
    local dx = self.box.x + self.velocity.x * dt;
    local dy = self.box.y + self.velocity.y * dt;

    local actualX, actualY, cols, len = BumpWorld:move(self, dx, dy, bulletCollision);

    self.box.x = actualX;
    self.box.y = actualY;

    if self.box.x < 0 - BULLET_WIDTH or self.box.x > SCREEN_WIDTH or self.box.y > SCREEN_HEIGHT then
      self.isOffScreen = true;
      self.active = false;
    end
  end
end

function Bullet:protectBoss(dt)
  local cx = self.boss.box.x + self.boss.box.w / 2;
  local cy = self.boss.box.y + self.boss.box.h / 2;

  -- Increment the movement timer
  self.forcefieldTimer = self.forcefieldTimer + dt;
  if self.forcefieldTimer > BOSS_SHIELD_RATE then
    self.forcefieldTimer = 0;
  end

  -- Find the current angle based on rotation rate and initial forcefield position
  local angle = self.forcefieldPosition + math.pi * 2 * self.forcefieldTimer / BOSS_SHIELD_RATE;
  local bv = Vector.fromPolar(angle, BOSS_SHIELD_DISTANCE);
  local dx = cx + bv.x - self.box.w / 2;
  local dy = cy + bv.y - self.box.h / 2;

  local actualX, actualY, cols, len = BumpWorld:move(self, dx, dy, bulletCollision);

  self.box.x = actualX;
  self.box.y = actualY;
end

function Bullet:throwSlaves()
  local slaves = self.slaves;
  local count = #slaves;
  if count == 0 then
    return;
  end

  local ratio = 0;
  local angle = 0;
  self.slaves = {};

  for index, bullet in ipairs(slaves) do
    bullet.isSlave = false;
    ratio = (index - 1) / count;
    angle = ratio * math.pi * 2;

    local v = Vector.fromPolar(angle, 1);
    bullet.velocity.x = v.x * BULLET_SPEED;
    bullet.velocity.y = v.y * BULLET_SPEED;
  end

  if PLAY_SOUNDS then
    SFX_BOMB_EXPLODE:rewind();
    SFX_BOMB_EXPLODE:play();
  end
end

function Bullet:draw()
  if not self.active then
    return;
  end

  love.graphics.setColor(255, 255, 255);
  love.graphics.draw(self.image, self.box.x, self.box.y, 0, BULLET_SCALE, BULLET_SCALE);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", BumpWorld:getRect(self));
  end
end