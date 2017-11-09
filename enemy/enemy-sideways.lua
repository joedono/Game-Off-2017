EnemySideways = Class {
  init = function(self, direction, y, weaponManager)
    self.box = {
      x = 0,
      y = y,
      w = SIDEWAYS_ENEMY_INITIAL_DIMENSIONS.w,
      h = SIDEWAYS_ENEMY_INITIAL_DIMENSIONS.h
    };

    self.direction = direction;
    if direction == -1 then
      self.box.x = SCREEN_WIDTH;
    else
      self.box.x = -self.box.w;
    end

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);

    self.fireTimer = Timer.new();
    self.bulletIndex = 0;
    self.weaponManager = weaponManager;

    self.fireTimer:every(1, function() self:fireBullet() end);

    self.active = true;
    self.type = "enemy";
  end
};

function EnemySideways:fireBullet()
  local type = "bullet";
  self.bulletIndex = self.bulletIndex + 1;
  if self.bulletIndex % 2 == 1 then
    type = "bullet-pickup";
  end

  local bx = self.box.x + self.box.w / 2 - BULLET_SIZE;
  local by = self.box.y + self.box.h / 2 - BULLET_SIZE;
  self.weaponManager:spawnBullet(bx, by, type);
end

function EnemySideways:update(dt)
  if not self.active then
    return;
  end

  self.fireTimer:update(dt);
  local dx = self.box.x + SIDEWAYS_ENEMY_SPEED * dt * self.direction;

  local actualX, actualY, cols, len = BumpWorld:move(self, dx, self.box.y, enemyCollision);

  self.box.x = actualX;
  self.box.y = actualY;

  if (self.box.x < 0 - self.box.w and self.direction == -1) or (self.box.x > SCREEN_WIDTH and self.direction == 1) then
    self.active = false;
    return;
  end

  for i = 1, len do
    if cols[i].other.type == "bullet-pickup" and cols[i].other.thrown then
      self.active = false;
      cols[i].other.active = false;
    end
  end
end

function EnemySideways:draw()
  if not self.active then
    return;
  end

  love.graphics.setColor(0, 0, 150);
  love.graphics.rectangle("fill", self.box.x, self.box.y, self.box.w, self.box.h);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", BumpWorld:getRect(self));
  end
end