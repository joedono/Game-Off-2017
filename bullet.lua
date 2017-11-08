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
    self:moveAndBounce(dt);
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

function Bullet:moveAndBounce(dt)
  local dx = self.box.x + self.velocity.x * dt;
  local dy = self.box.y + self.velocity.y * dt;

  dx = math.clamp(dx, 0, SCREEN_WIDTH - BULLET_SIZE * 2);
  dy = math.clamp(dy, 0, SCREEN_HEIGHT - BULLET_SIZE * 2);

  local actualX, actualY, cols, len = BumpWorld:move(self, dx, dy, bulletCollision);

  for i = 1, len do
    if cols[i].other.type == "wall" or cols[i].other.type == "enemy" then
      self.active = false;
    end
  end

  self.box.x = actualX;
  self.box.y = actualY;
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