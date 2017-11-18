EnemyPendulum = Class {
  init = function(self, x, y, weaponManager, image)
    self.box = {
      x = x,
      y = y,
      w = PENDULUM_ENEMY_INITIAL_DIMENSIONS.w,
      h = PENDULUM_ENEMY_INITIAL_DIMENSIONS.h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);
    self.image = image;

    self.fireTimer = Timer.new();
    self.weaponManager = weaponManager;
    self.moveTimer = 0;

    self.fireTimer:every(2.5, function() self:fireBullets() end);

    self.active = true;
    self.type = "enemy";
  end
};

function EnemyPendulum:fireBullets()
  self.fireTimer:script(function(wait)
    for i = 1, 5 do
      self:fireBullet(i);
      wait(0.1);
    end
  end);
end

function EnemyPendulum:fireBullet(index)
  local type = "bullet";
  if index == 5 then
    type = "bullet-pickup";
  end

  local bx = self.box.x + self.box.w / 2 - BULLET_WIDTH;
  local by = self.box.y + self.box.h / 2 - BULLET_WIDTH;
  self.weaponManager:spawnBullet(bx, by, type);
end

function EnemyPendulum:update(dt)
  if not self.active then
    return;
  end

  self.fireTimer:update(dt);
  self.moveTimer = self.moveTimer + dt;
  local dx = cerp(PENDULUM_ENEMY_LEFT_LIMIT, PENDULUM_ENEMY_RIGHT_LIMIT, self.moveTimer / PENDULUM_ENEMY_MOVEMENT_RATE);
  local dy = self.box.y + PENDULUM_ENEMY_SPEED * dt;

  if self.moveTimer > PENDULUM_ENEMY_MOVEMENT_RATE * 2 then
    self.moveTimer = 0;
  end

  local actualX, actualY, cols, len = BumpWorld:move(self, dx, dy, enemyCollision);

  self.box.x = actualX;
  self.box.y = actualY;

  if self.box.y > SCREEN_HEIGHT then
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

function EnemyPendulum:draw()
  if not self.active then
    return;
  end

  love.graphics.setColor(255, 255, 255);
  love.graphics.draw(self.image, self.box.x, self.box.y, 0, ENEMY_SCALE, ENEMY_SCALE);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", BumpWorld:getRect(self));
  end
end