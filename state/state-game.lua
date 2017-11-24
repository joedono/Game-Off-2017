require "config/collisions";
require "player";
require "weapon/manager-weapon";
require "enemy/manager-enemy";
require "pickup/manager-pickup";
require "asset/config/game-timeline";
require "background";

State_Game = {};

function State_Game:init()
  BumpWorld = Bump.newWorld(32);

  self.musicGameplay = love.audio.newSource("asset/music/gameplay.mp3");
  self.musicBoss = love.audio.newSource("asset/music/boss.mp3");
  self.deathTimer = Timer.new();
end

function State_Game:enter()
  local items = BumpWorld:getItems();
  for index, item in pairs(items) do
    BumpWorld:remove(item);
  end

  self.player = Player();
  self.pickupManager = ManagerPickup();
  self.weaponManager = ManagerWeapon(self.player);
  self.enemyManager = ManagerEnemy(self.weaponManager, self.pickupManager);
  self.background = Background();

  self.timePassed = 0;
  self.timelineIndex = 1;
  self.lastTime = 0;
  self.totalTime = 0;
  for index, event in ipairs(GAME_TIMELINE) do
    self.totalTime = self.totalTime + event.time;
  end

  self.active = true;
  self.deathTimer:clear();
  self.deathTimerRunning = false;

  if PLAY_MUSIC then
    self.musicGameplay:setVolume(0.3);
    self.musicGameplay:play();
  end
end

function State_Game:leave()
  if PLAY_MUSIC then
    self.musicGameplay:stop();
    self.musicBoss:stop();
  end
end

function State_Game:focus(focused)
  if focused then
    self.active = true;
    if PLAY_MUSIC then
      if self.enemyManager.bossIsActive then
        self.musicBoss:resume();
      else
        self.musicGameplay:resume();
      end
    end
  else
    self.active = false;
    if PLAY_MUSIC then
      self.musicGameplay:pause();
      self.musicBoss:pause();
    end
  end
end

function State_Game:keypressed(key, scancode, isrepeat)
  if not self.active then
    return;
  end

  if key == KEY_LEFT then
    self.player.leftPressed = true;
  end

  if key == KEY_RIGHT then
    self.player.rightPressed = true;
  end

  if key == KEY_UP then
    self.player.upPressed = true;
  end

  if key == KEY_DOWN then
    self.player.downPressed = true;
  end

  if key == KEY_RUN then
    self.player.runPressed = true;
  end

  if key == KEY_FIRE_STREAM then
    self.player:fireStream();
  end

  if key == KEY_FIRE_SPREAD then
    self.player:fireSpread();
  end

  if key == KEY_FIRE_BOMB then
    self.player:fireBomb();
  end

  if key == KEY_FIRE_FORCEFIELD then
    self.player:fireForcefield();
  end
end

function State_Game:keyreleased(key, scancode)
  if not self.active then
    return;
  end

  if key == KEY_LEFT then
    self.player.leftPressed = false;
  end

  if key == KEY_RIGHT then
    self.player.rightPressed = false;
  end

  if key == KEY_UP then
    self.player.upPressed = false;
  end

  if key == KEY_DOWN then
    self.player.downPressed = false;
  end

  if key == KEY_RUN then
    self.player.runPressed = false;
  end
end

function State_Game:gamepadpressed(joystick, button)
  if not self.active then
    return;
  end

  if button == JOY_LEFT then
    self.player.leftPressed = true;
  end

  if button == JOY_RIGHT then
    self.player.rightPressed = true;
  end

  if button == JOY_UP then
    self.player.upPressed = true;
  end

  if button == JOY_DOWN then
    self.player.downPressed = true;
  end

  if button == JOY_FIRE_STREAM then
    self.player:fireStream();
  end

  if button == JOY_FIRE_SPREAD then
    self.player:fireSpread();
  end

  if button == JOY_FIRE_BOMB then
    self.player:fireBomb();
  end

  if button == JOY_FIRE_FORCEFIELD then
    self.player:fireForcefield();
  end
end

function State_Game:gamepadreleased(joystick, button)
  if not self.active then
    return;
  end

  if button == JOY_LEFT then
    self.player.leftPressed = false;
  end

  if button == JOY_RIGHT then
    self.player.rightPressed = false;
  end

  if button == JOY_UP then
    self.player.upPressed = false;
  end

  if button == JOY_DOWN then
    self.player.downPressed = false;
  end
end

function State_Game:resume()
  self.player:resetKeys();
  if PLAY_MUSIC then
    if self.enemyManager.bossIsActive then
      self.musicBoss:resume();
    else
      self.musicGameplay:resume();
    end
  end
end

function State_Game:update(dt)
  if not self.active then
    return;
  end

  if self.deathTimerRunning then
    self.deathTimer:update(dt);
  end

  self:updateTimeline(dt);
  self.background:update(dt);
  self.enemyManager:update(dt);
  self.pickupManager:update(dt);
  self.player:update(dt);
  self.weaponManager:update(dt);

  -- Switch to boss music
  if PLAY_MUSIC and self.enemyManager.bossIsActive and not self.musicBoss:isPlaying() then
    self.musicGameplay:stop();
    self.musicBoss:setVolume(0.3);
    self.musicBoss:play();
  end

  -- If player or boss is dead, fade out music and switch to credits screen
  if (not self.player.active or self.enemyManager:bossIsDead()) and not self.deathTimerRunning then
    self.deathTimerRunning = true;

    self.deathTimer:script(function(wait)
      self.musicGameplay:setVolume(0.2);
      self.musicBoss:setVolume(0.2);
      wait(2);
      self.musicGameplay:setVolume(0.1);
      self.musicBoss:setVolume(0.1);
      wait(2);
      self.musicGameplay:setVolume(0.05);
      self.musicBoss:setVolume(0.05);
      wait(1);
      self.musicGameplay:setVolume(0);
      self.musicBoss:setVolume(0);
      wait(0.5);
      self.musicGameplay:stop();
      self.musicBoss:stop();
      self.enemyManager.bossIsActive = false;
      GameState.switch(State_Credits);
    end);
  end
end

function State_Game:updateTimeline(dt)
  self.timePassed = self.timePassed + dt;

  if(GAME_TIMELINE[self.timelineIndex]) then
    if(self.lastTime + self.timePassed > self.lastTime + GAME_TIMELINE[self.timelineIndex].time) then
      local enemies = GAME_TIMELINE[self.timelineIndex].enemies;

      for index, enemy in ipairs(enemies) do
        self.enemyManager:spawnEnemy(enemy);
      end

      self.lastTime = self.lastTime + GAME_TIMELINE[self.timelineIndex].time;
      self.timelineIndex = self.timelineIndex + 1;
      self.timePassed = 0;
    end
  end
end

function State_Game:draw()
  love.graphics.setColor(255, 255, 255);

  self.background:draw();
  self.enemyManager:draw();
  self.pickupManager:draw();
  self.player:draw();
  self.weaponManager:draw();

  if DRAW_POSITIONS then
    love.graphics.setColor(255, 255, 255);
    love.graphics.print("Player: " .. self.player.box.x .. ", " .. self.player.box.y, 32, 32);
    love.graphics.print("Total Time: " .. (self.totalTime / 60), 32, 64);
  end
end