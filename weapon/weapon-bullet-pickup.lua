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
    self.active = true;

    self.isForcefield = false;
    self.isSlave = false;
    self.slaves = {};

    self.type = "bullet-pickup";
  end
};

function BulletPickup:pickUp()
  self.pickedUp = true;
end

function BulletPickup:update(dt, player)
  if not self.active then
    if #self.slaves > 0 then
      self:throwSlaves();
    end

    return;
  end

  if self.pickedUp then
    self:followPlayer(player);
  elseif self.isForcefield then
    self:protectPlayer(dt, player);
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
  self.active = false;
  -- TODO
end

function BulletPickup:updatePosition(dt)
  local dx = self.box.x + self.velocity.x * dt;
  local dy = self.box.y + self.velocity.y * dt;

  local actualX, actualY, cols, len = BumpWorld:move(self, dx, dy, bulletCollision);

  self.box.x = actualX;
  self.box.y = actualY;

  if self.box.x < 0 - BULLET_WIDTH or self.box.x > SCREEN_WIDTH or self.box.y < 0 - BULLET_WIDTH or self.box.y > SCREEN_HEIGHT then
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
end

function BulletPickup:throwForcefield()
  if not self.pickedUp then
    return;
  end

  self.pickedUp = false;
  self.thrown = true;

  self.isForcefield = true;
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