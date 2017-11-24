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

    self.bulletIndex = 0;

    self.straightFireTimer = Timer.new();
    self.straightFireTimer:every(BOSS_STRAIGHT_FIRE_RATE, function() self:fireStream() end);

    self.waveFireTimer = Timer.new();
    self.waveFireTimer:every(BOSS_WAVE_FIRE_RATE, function() self:fireWave() end);

    self.bombFireTimer = Timer.new();
    self.bombFireTimer:every(BOSS_WAVE_FIRE_RATE, function() self:fireBomb() end);

    self.shieldBullets = {};

    self.active = true;
    self.type = "boss";
  end
};

function EnemyBoss:update(dt)
  self.modeTimer = self.modeTimer + dt;
  self:checkShield();

  if self.modeTimer >= BOSS_MODE_TIMER then
    self.modeTimer = 0;
    if self.mode ~= "entering" and love.math.random() < 0.5 then
      self.pickupManager:spawnHealth(SCREEN_WIDTH / 2, -HEALTH_HEIGHT);
    end

    self:clearShield();

    self.mode = self.firingModes[love.math.random(1, 4)];
    self.mode = "shield";

    if self.mode == "shield" then
      self:fireShield();
    end
  end

  if self.mode == "entering" then
    self:moveEntering(dt);
  elseif self.mode == "stream" then
    self:moveStream(dt);
    self.straightFireTimer:update(dt);
  elseif self.mode == "wave" then
    self:moveWave(dt);
    self.waveFireTimer:update(dt);
  elseif self.mode == "bomb" then
    self:moveBomb(dt);
    self.bombFireTimer:update(dt);
  elseif self.mode == "shield" then
    self:moveShield(dt);
  end

  if self.health <= 0 then
    self:clearShield();
    self.active = false;
  end
end

function EnemyBoss:clearShield()
  for index, bullet in ipairs(self.shieldBullets) do
    bullet.active = false;
  end

  self.shieldBullets = {};
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
  local timerUnit = BOSS_MODE_TIMER / 4;

  if currentState <= 1/4 then
    startX = 169;
    startY = 100;
    endX = SCREEN_WIDTH - BOSS_WIDTH - 10;
    endY = 100;
    progress = self.modeTimer / timerUnit;
  elseif currentState > 1/4 and currentState <= 3/4 then
    startX = SCREEN_WIDTH - BOSS_WIDTH - 10;
    startY = 100;
    endX = 10;
    endY = 100;
    progress = (self.modeTimer - BOSS_MODE_TIMER / 4) / (timerUnit * 2);
  elseif currentState > 3/4 then
    startX = 10;
    startY = 100;
    endX = 169;
    endY = 100;
    progress = (self.modeTimer - BOSS_MODE_TIMER  * 3/4) / timerUnit;
  end

  local curX = lerp(startX, endX, progress);
  local curY = lerp(startY, endY, progress);

  local actualX, actualY, cols, len = BumpWorld:move(self, curX, curY, bossCollision);

  self:handleCollision(cols, len);

  self.box.x = actualX;
  self.box.y = actualY;
end

function EnemyBoss:fireStream()
  local type = "bullet";
  self.bulletIndex = self.bulletIndex + 1;
  if self.bulletIndex % 4 == 1 then
    type = "bullet-pickup";
  end

  local bx = self.box.x + self.box.w / 2 - BULLET_WIDTH;
  local by = self.box.y + self.box.h - BULLET_WIDTH;
  self.weaponManager:spawnBullet(bx, by, type);
end

function EnemyBoss:moveWave(dt)
  local startX, startY = 0, 0;
  local endX, endY = 0, 0;
  local progress = 0;
  local currentState = self.modeTimer / BOSS_MODE_TIMER;
  local timerUnit = BOSS_MODE_TIMER / 4;

  if currentState <= 1/4 then
    startX = 169;
    startY = 100;
    endX = 10;
    endY = 100;
    progress = self.modeTimer / timerUnit;
  elseif currentState > 1/4 and currentState <= 2/4 then
    startX = 10;
    startY = 100;
    endX = 169;
    endY = 10;
    progress = (self.modeTimer - BOSS_MODE_TIMER / 4) / timerUnit;
  elseif currentState > 2/4 and currentState <= 3/4 then
    startX = 169;
    startY = 10;
    endX = SCREEN_WIDTH - BOSS_WIDTH - 10;
    endY = 100;
    progress = (self.modeTimer - BOSS_MODE_TIMER / 2) / timerUnit;
  elseif currentState > 3/4 then
    startX = SCREEN_WIDTH - BOSS_WIDTH - 10;
    startY = 100;
    endX = 169;
    endY = 100;
    progress = (self.modeTimer - BOSS_MODE_TIMER  * 3/4) / timerUnit;
  end

  local curX = lerp(startX, endX, progress);
  local curY = lerp(startY, endY, progress);

  local actualX, actualY, cols, len = BumpWorld:move(self, curX, curY, bossCollision);

  self:handleCollision(cols, len);

  self.box.x = actualX;
  self.box.y = actualY;
end

function EnemyBoss:fireWave(dt)
  for index = 1, BOSS_WAVE_SIZE do
    local type = "bullet";
    self.bulletIndex = self.bulletIndex + 1;
    if self.bulletIndex % 4 == 1 then
      type = "bullet-pickup";
    end

    local bx = self.box.x + self.box.w / 2 - BULLET_WIDTH;
    local by = self.box.y + self.box.h - BULLET_WIDTH;

    local angle = BULLET_SPREAD[index] - math.pi;
    local v = Vector.fromPolar(angle, 1);
    local vx = v.x * BULLET_SPEED;
    local vy = v.y * BULLET_SPEED;
    self.weaponManager:spawnBulletWithVelocity(bx, by, vx, vy, type);
  end
end

function EnemyBoss:moveBomb(dt)
  local startX, startY = 0, 0;
  local endX, endY = 0, 0;
  local progress = 0;
  local currentState = self.modeTimer / BOSS_MODE_TIMER;
  local timerUnit = BOSS_MODE_TIMER / 6;

  if currentState <= 1/6 then
    startX = 169;
    startY = 100;
    endX = 169;
    endY = 200;
    progress = self.modeTimer / timerUnit;
  elseif currentState > 1/6 and currentState <= 2/6 then
    startX = 169;
    startY = 200;
    endX = SCREEN_WIDTH - BOSS_WIDTH - 10;
    endY = 100;
    progress = (self.modeTimer - BOSS_MODE_TIMER * 1/6) / timerUnit;
  elseif currentState > 2/6 and currentState <= 3/6 then
    startX = SCREEN_WIDTH - BOSS_WIDTH - 10;
    startY = 100;
    endX = 169;
    endY = 10;
    progress = (self.modeTimer - BOSS_MODE_TIMER * 2/6) / timerUnit;
  elseif currentState > 3/6 and currentState <= 4/6 then
    startX = 169;
    startY = 10;
    endX = 10;
    endY = 100;
    progress = (self.modeTimer - BOSS_MODE_TIMER  * 3/6) / timerUnit;
  elseif currentState > 4/6 and currentState <= 5/6 then
    startX = 10;
    startY = 100;
    endX = 169;
    endY = 200;
    progress = (self.modeTimer - BOSS_MODE_TIMER  * 4/6) / timerUnit;
  elseif currentState > 5/6 then
    startX = 169;
    startY = 200;
    endX = 169;
    endY = 100;
    progress = (self.modeTimer - BOSS_MODE_TIMER  * 5/6) / timerUnit;
  end

  local curX = lerp(startX, endX, progress);
  local curY = lerp(startY, endY, progress);

  local actualX, actualY, cols, len = BumpWorld:move(self, curX, curY, bossCollision);

  self:handleCollision(cols, len);

  self.box.x = actualX;
  self.box.y = actualY;
end

function EnemyBoss:fireBomb(dt)
  local bx = self.box.x + self.box.w / 2 - BULLET_WIDTH;
  local by = self.box.y + self.box.h - BULLET_WIDTH;

  self.weaponManager:spawnBossBomb(bx, by);
end

function EnemyBoss:moveShield(dt)
  local startX, startY = 0, 0;
  local endX, endY = 0, 0;
  local progress = 0;
  local currentState = self.modeTimer / BOSS_MODE_TIMER;
  local timerUnit = BOSS_MODE_TIMER / 6;

  if currentState <= 1/6 then
    startX = 169;
    startY = 100;
    endX = 169;
    endY = 10;
    progress = self.modeTimer / timerUnit;
  elseif currentState > 1/6 and currentState <= 4/6 then
    startX = 169;
    startY = 10;
    endX = 169;
    endY = SCREEN_HEIGHT - BOSS_HEIGHT - 100;
    progress = (self.modeTimer - BOSS_MODE_TIMER * 1/6) / (timerUnit * 3);
  elseif currentState > 4/6 then
    startX = 169;
    startY = SCREEN_HEIGHT - BOSS_HEIGHT - 100;
    endX = 169;
    endY = 100;
    progress = (self.modeTimer - BOSS_MODE_TIMER  * 4/6) / (timerUnit * 2);
  end

  local curX = lerp(startX, endX, progress);
  local curY = lerp(startY, endY, progress);

  local actualX, actualY, cols, len = BumpWorld:move(self, curX, curY, bossCollision);

  self:handleCollision(cols, len);

  self.box.x = actualX;
  self.box.y = actualY;
end

function EnemyBoss:fireShield()
  local shieldBullets = {};
  for index = 1, BOSS_SHIELD_SIZE do
    local type = "bullet";
    self.bulletIndex = self.bulletIndex + 1;
    if self.bulletIndex % 4 == 1 then
      type = "bullet-pickup";
    end

    local bx = self.box.x + self.box.w / 2 - BULLET_WIDTH;
    local by = self.box.y + self.box.h / 2 - BULLET_WIDTH;

    table.insert(shieldBullets, self.weaponManager:spawnBullet(bx, by, type));
  end

  local count = #shieldBullets;
  local ratio = 0;
  self.shieldBullets = shieldBullets;

  for index, bullet in ipairs(shieldBullets) do
    ratio = index / count;
    bullet.isBossForcefield = true;
    bullet.boss = self;
    bullet.forcefieldPosition = ratio * math.pi * 2;
  end
end

function EnemyBoss:checkShield()
  local shieldBullets = {};
  for index, bullet in ipairs(self.shieldBullets) do
    if not bullet.pickedUp and not bullet.thrown then
      table.insert(shieldBullets, bullet);
    end
  end

  self.shieldBullets = shieldBullets;
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

  love.graphics.setColor(255, 0, 0);
  love.graphics.rectangle("fill", 20, 20, SCREEN_WIDTH - 40, 32);
  love.graphics.setColor(0, 255, 0);
  local w = self.health / BOSS_HEALTH * (SCREEN_WIDTH - 48);
  love.graphics.rectangle("fill", 24, 24, w, 24);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", BumpWorld:getRect(self));
  end
end