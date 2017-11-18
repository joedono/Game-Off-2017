EnemyStraight = Class {
  init = function(self, x, y, weaponManager, image)
    self.box = {
      x = x,
      y = y,
      w = STRAIGHT_ENEMY_INITIAL_DIMENSIONS.w,
      h = STRAIGHT_ENEMY_INITIAL_DIMENSIONS.h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);
    self.image = image;

    self.fireTimer = Timer.new();
    self.bulletIndex = 0;
    self.weaponManager = weaponManager;

    self.fireTimer:every(STRAIGHT_ENEMY_FIRE_RATE, function() self:fireBullet() end);

    self.active = true;
    self.type = "enemy";
  end
};

function EnemyStraight:fireBullet()
  local type = "bullet";
  self.bulletIndex = self.bulletIndex + 1;
  if self.bulletIndex % 2 == 1 then
    type = "bullet-pickup";
  end

  local bx = self.box.x + self.box.w / 2 - BULLET_WIDTH;
  local by = self.box.y + self.box.h / 2 - BULLET_WIDTH;
  self.weaponManager:spawnBullet(bx, by, type);
end

function EnemyStraight:update(dt)
  if not self.active then
    return;
  end

  self.fireTimer:update(dt);
  local dy = self.box.y + STRAIGHT_ENEMY_SPEED * dt;

  local actualX, actualY, cols, len = BumpWorld:move(self, self.box.x, dy, enemyCollision);

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

function EnemyStraight:draw()
  if not self.active then
    return;
  end

  love.graphics.setColor(255, 255, 255);
  love.graphics.draw(self.image, self.box.x, self.box.y);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", BumpWorld:getRect(self));
  end
end