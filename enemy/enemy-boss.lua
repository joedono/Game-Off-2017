EnemyBoss = Class {
  init = function(self, x, y, weaponManager, pickupManager, image)
    self.box = {
      x = x,
      y = y,
      w = BOSS_INITIAL_DIMENSIONS.w,
      h = BOSS_INITIAL_DIMENSIONS.h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);
    self.image = image;
    self.weaponManager = weaponManager;
    self.pickupManager = pickupManager;
    self.health = BOSS_HEALTH;
    self.modeTimer = 0;
    self.mode = "entering";
    self.firingModes = {
      "stream",
      "wave",
      "bomb",
      "shield"
    };

    self.active = true;
    self.type = "boss";
  end
};

function EnemyBoss:update(dt)
  self.modeTimer = self.modeTimer + dt;
  if self.modeTimer >= BOSS_MODE_TIMER then
    self.modeTimer = 0;
    if not self.mode == "entering" then
      self.pickupManager:spawnHealth(SCREEN_WIDTH / 2, -HEALTH_HEIGHT);
    end

    --self.mode = self.firingModes[love.math.random(1, 4)];
    self.mode = "stream";
  end

  if self.mode == "entering" then
    self:moveEntering(dt);
  elseif self.mode == "stream" then
    self:moveStream(dt);
    self:fireStream(dt);
  elseif self.mode == "wave" then
    self:moveWave(dt);
    self:fireWave(dt);
  elseif self.mode == "bomb" then
    self:moveBomb(dt);
    self:fireBomb(dt);
  elseif self.mode == "shield" then
    self:moveShield(dt);
    self:fireShield(dt);
  end

  if self.health <= 0 then
    self.active = false;
  end
end

function EnemyBoss:moveEntering(dt)
  local startY = -400;
  local endY = 100;
  local curY = lerp(startY, endY, self.modeTimer / BOSS_MODE_TIMER);
  local actualX, actualY, cols, len = BumpWorld:move(self, self.box.x, curY, bossCollision);

  self:handleCollision(cols, len);

  self.box.x = actualX;
  self.box.y = actualY;
end

function EnemyBoss:moveStream(dt)
  local startX, startY = 0, 0;
  local endX, endY = 0, 0;
  local progress = 0;
  local currentState = self.modeTimer / BOSS_MODE_TIMER;

  if currentState <= 1/4 then
    -- Move from center to the right
    startX = 169;
    startY = 100;
    endX = SCREEN_WIDTH - BOSS_WIDTH - 30;
    endY = 100;
    progress = self.modeTimer / (BOSS_MODE_TIMER / 4);
  elseif currentState > 1/4 and currentState <= 3/4 then
    -- Move from the right to the left
    startX = SCREEN_WIDTH - BOSS_WIDTH - 30;
    startY = 100;
    endX = 30;
    endY = 100;
    progress = (self.modeTimer - BOSS_MODE_TIMER / 4) / (BOSS_MODE_TIMER / 2);
  elseif currentState > 3/4 then
    -- Move from the left to the center
    startX = 30;
    startY = 100;
    endX = 169;
    endY = 100;
    progress = (self.modeTimer - BOSS_MODE_TIMER  * 3/4) / (BOSS_MODE_TIMER / 4);
  end

  local curX = lerp(startX, endX, progress);
  local curY = lerp(startY, endY, progress);

  local actualX, actualY, cols, len = BumpWorld:move(self, curX, curY, bossCollision);

  self:handleCollision(cols, len);

  self.box.x = actualX;
  self.box.y = actualY;
end

function EnemyBoss:fireStream(dt)
  -- TODO
end

function EnemyBoss:moveWave(dt)
  local startX = 169;
  local startY = 100;

  -- TODO

  local curX = lerp(startX, endX, progress);
  local curY = lerp(startY, endY, progress);

  local actualX, actualY, cols, len = BumpWorld:move(self, curX, curY, bossCollision);

  self:handleCollision(cols, len);

  self.box.x = actualX;
  self.box.y = actualY;
end

function EnemyBoss:fireWave(dt)
  -- TODO
end

function EnemyBoss:moveBomb(dt)
  local startX = 169;
  local startY = 100;

  -- TODO

  local curX = lerp(startX, endX, progress);
  local curY = lerp(startY, endY, progress);

  local actualX, actualY, cols, len = BumpWorld:move(self, curX, curY, bossCollision);

  self:handleCollision(cols, len);

  self.box.x = actualX;
  self.box.y = actualY;
end

function EnemyBoss:fireBomb(dt)
  -- TODO
end

function EnemyBoss:moveShield(dt)
  local startX = 169;
  local startY = 100;

  -- TODO

  local curX = lerp(startX, endX, progress);
  local curY = lerp(startY, endY, progress);

  local actualX, actualY, cols, len = BumpWorld:move(self, curX, curY, bossCollision);

  self:handleCollision(cols, len);

  self.box.x = actualX;
  self.box.y = actualY;
end

function EnemyBoss:fireShield(dt)
  -- TODO
end

function EnemyBoss:handleCollision(cols, len)
  for i = 1, len do
    if cols[i].other.type == "bullet-pickup" and cols[i].other.thrown and not cols[i].other.isSlave then
      self.health = self.health - 1;
      cols[i].other.active = false;
    end
  end
end

function EnemyBoss:draw()
  if not self.active then
    return;
  end

  love.graphics.setColor(255, 255, 255);
  love.graphics.draw(self.image, self.box.x - BOSS_OFFSET_X, self.box.y - BOSS_OFFSET_Y, 0, BOSS_SCALE, BOSS_SCALE);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", BumpWorld:getRect(self));
  end
end