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
    self.modetimer = 0;
    self.pickupManager:spawnHealth(SCREEN_WIDTH, -HEALTH_HEIGHT);
    self:switchModes();
  end

  if self.mode == "entering" then
    self:updateEntering(dt);
  elseif self.mode == "stream" then
    self:updateStream(dt);
  elseif self.mode == "wave" then
    self:updateWave(dt);
  elseif self.mode == "bomb" then
    self:updateBomb(dt);
  elseif self.mode == "shield" then
    self:updateShield(dt);
  end
end

function EnemyBoss:switchModes();
  -- TODO
end

function EnemyBoss:updateEntering(dt);
  -- TODO
end

function EnemyBoss:updateStream(dt);
  -- TODO
end

function EnemyBoss:updateWave(dt);
  -- TODO
end

function EnemyBoss:updateBomb(dt);
  -- TODO
end

function EnemyBoss:updateShield(dt);
  -- TODO
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