BulletPickup = Class {
  init = function(self, x, y, image)
    self.box = {
      x = x,
      y = y,
      w = BULLET_INITIAL_DIMENSIONS.w,
      h = BULLET_INITIAL_DIMENSIONS.h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);

    self.velocity = { x = 0, y = BULLET_SPEED };
    self.image = image;

    self.thrown = false;
    self.pickedUp = false;
    self.isOffScreen = false;
    self.active = true;

    self.isForcefield = false;
    self.isBossForcefield = false;
    self.forcefieldPosition = 0;
    self.forcefieldTimer = 0;
    self.boss = nil;

    self.isSlave = false;
    self.slaves = {};

    self.type = "bullet-pickup";
  end
};

function BulletPickup:pickUp()
  self.pickedUp = true;
  self.isBossForcefield = false;
  self.boss = nil;
end

function BulletPickup:update(dt, player)
  if not self.active then
    return;
  end

  if self.pickedUp then
    self:followPlayer(player);
  elseif self.isForcefield then
    self:protectPlayer(dt, player);
  elseif self.isBossForcefield then
    self:protectBoss(dt);
  else
    self:updatePosition(dt);
  end
end

function BulletPickup:followPlayer(player)
  local dx = player.box.x + player.box.w / 2;
  local dy = player.box.y + player.box.h / 2;

  dx = dx - BULLET_WIDTH;
  dy = dy - BULLET_WIDTH - 20;

  BumpWorld:update(self, dx, dy);

  self.box.x = dx;
  self.box.y = dy;
end

function BulletPickup:protectPlayer(dt, player)
  local cx = player.box.x + player.box.w / 2;
  local cy = player.box.y + player.box.h / 2;

  -- Increment the movement timer
  self.forcefieldTimer = self.forcefieldTimer + dt * FORCEFIELD_RATE;
  if self.forcefieldTimer > FORCEFIELD_RATE then
    self.forcefieldTimer = 0;
  end

  -- Find the current angle based on rotation rate and initial forcefield position
  local angle = self.forcefieldPosition + math.pi * 2 * self.forcefieldTimer / FORCEFIELD_RATE;
  local bv = Vector.fromPolar(angle, FORCEFIELD_DISTANCE);
  local dx = cx + bv.x - self.box.w / 2;
  local dy = cy + bv.y - self.box.h / 2;

  local actualX, actualY, cols, len = BumpWorld:move(self, dx, dy, bulletCollision);

  self.box.x = actualX;
  self.box.y = actualY;
end

function BulletPickup:protectBoss(dt)
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

function BulletPickup:updatePosition(dt)
  local dx = self.box.x + self.velocity.x * dt;
  local dy = self.box.y + self.velocity.y * dt;

  local actualX, actualY, cols, len = BumpWorld:move(self, dx, dy, bulletCollision);

  self.box.x = actualX;
  self.box.y = actualY;

  if self.box.x < 0 - BULLET_WIDTH or self.box.x > SCREEN_WIDTH or self.box.y < 0 - BULLET_WIDTH or self.box.y > SCREEN_HEIGHT then
    self.isOffScreen = true;
    self.active = false;
  end
end

function BulletPickup:throwStraight(isSlave)
  if not self.pickedUp then
    return;
  end

  self.pickedUp = false;
  self.thrown = true;
  self.isSlave = isSlave;

  self.velocity.x = 0;
  self.velocity.y = -BULLET_SPEED;
end

function BulletPickup:throwSpread(angle)
  if not self.pickedUp then
    return;
  end

  self.pickedUp = false;
  self.thrown = true;

  local v = Vector.fromPolar(angle, 1);
  self.velocity.x = v.x * BULLET_SPEED;
  self.velocity.y = v.y * BULLET_SPEED;
end

function BulletPickup:throwBombMaster(slaveBullets)
  if not self.pickedUp then
    return;
  end

  self.pickedUp = false;
  self.thrown = true;
  self.slaves = slaveBullets;

  self.box.y = self.box.y - 1;
  BumpWorld:update(self, self.box.x, self.box.y);

  self.velocity.x = 0;
  self.velocity.y = -BULLET_SPEED;
end

function BulletPickup:throwSlaves()
  local slaves = self.slaves;
  local count = #slaves - 1;
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
    love.audio.play(SFX_BOMB_EXPLODE);
  end
end

function BulletPickup:throwForcefield(ratio)
  if not self.pickedUp then
    return;
  end

  self.pickedUp = false;
  self.thrown = true;

  self.isForcefield = true;
  self.forcefieldPosition = ratio * math.pi * 2;
end

function BulletPickup:draw()
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