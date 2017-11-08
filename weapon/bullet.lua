Bullet = Class {
  init = function(self, x, y, type)
    self.box = {
      x = x,
      y = y,
      w = BULLET_INITIAL_DIMENSIONS.w,
      h = BULLET_INITIAL_DIMENSIONS.h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);

    self.velocity = { x = 0, y = BULLET_SPEED };

    self.thrown = false;
    self.pickedUp = false;
    self.active = true;
    self.type = type;
  end
};

function Bullet:pickUp()
  self.pickedUp = true;
end

function Bullet:update(dt, player)
  if not self.active then
    return;
  end

  if self.pickedUp then
    self:followPlayer(player);
  else
    self:updatePosition(dt);
  end
end

function Bullet:followPlayer(player)
  local dx = player.box.x + player.box.w / 2;
  local dy = player.box.y + player.box.h / 2;

  dx = dx - BULLET_SIZE;
  dy = dy - BULLET_SIZE - 20;

  BumpWorld:update(self, dx, dy);

  self.box.x = dx;
  self.box.y = dy;
end

function Bullet:updatePosition(dt)
  local dx = self.box.x + self.velocity.x * dt;
  local dy = self.box.y + self.velocity.y * dt;

  local actualX, actualY, cols, len = BumpWorld:move(self, dx, dy, bulletCollision);

  self.box.x = actualX;
  self.box.y = actualY;

  if self.box.x < 0 - BULLET_SIZE or self.box.x > SCREEN_WIDTH or self.box.y < 0 - BULLET_SIZE or self.box.y > SCREEN_HEIGHT then
    self.active = false;
  end
end

function Bullet:throw(player)
  if not self.pickedUp then
    return;
  end

  self.velocity.x = 0;
  self.velocity.y = -BULLET_SPEED;
  self.pickedUp = false;
  self.thrown = true;
end

function Bullet:draw()
  if not self.active then
    return;
  end

  if self.type == "bulletPickup" then
    love.graphics.setColor(255, 255, 0);
  else
    love.graphics.setColor(255, 0, 0);
  end
  love.graphics.rectangle("fill", self.box.x, self.box.y, self.box.w, self.box.h);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", BumpWorld:getRect(self));
  end
end