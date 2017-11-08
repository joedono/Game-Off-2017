Enemy = Class {
  init = function(self, x, y, bulletManager)
    self.box = {
      x = x,
      y = y,
      w = ENEMY_INITIAL_DIMENSIONS.w,
      h = ENEMY_INITIAL_DIMENSIONS.h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);

    self.fireTimer = Timer.new();
    self.bulletManager = bulletManager;
    self.moveTimer = 0;

    self.fireTimer:every(2.5, function() self:fireBullets() end);

    self.active = true;
    self.type = "enemy";
  end
};

function Enemy:fireBullets()
  self.fireTimer:script(function(wait)
    for i = 1, 5 do
      self:fireBullet(i);
      wait(0.1);
    end
  end);
end

function Enemy:fireBullet(index)
  local type = "bullet";
  if index == 5 then
    type = "bulletPickup";
  end

  local bx = self.box.x + self.box.w / 2 - BULLET_SIZE;
  local by = self.box.y + self.box.h / 2 - BULLET_SIZE;
  self.bulletManager:spawnBullet(bx, by, type);
end

function Enemy:update(dt)
  if not self.active then
    return;
  end

  self.fireTimer:update(dt);
  self.moveTimer = self.moveTimer + dt;
  self.box.x = cerp(ENEMY_LEFT_LIMIT, ENEMY_RIGHT_LIMIT, self.moveTimer / ENEMY_MOVEMENT_RATE);

  if self.moveTimer > ENEMY_MOVEMENT_RATE * 2 then
    self.moveTimer = 0;
  end

  local actualX, actualY, cols, len = BumpWorld:move(self, self.box.x, self.box.y, enemyCollision);

  for i = 1, len do
    if cols[i].other.type == "bulletPickup" and cols[i].other.thrown then
      self.active = false;
      cols[i].other.active = false;
    end
  end
end

function Enemy:draw()
  if not self.active then
    return;
  end

  love.graphics.setColor(255, 0, 0);
  love.graphics.rectangle("fill", self.box.x, self.box.y, self.box.w, self.box.h);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", BumpWorld:getRect(self));
  end
end