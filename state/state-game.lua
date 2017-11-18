require "collisions";
require "player";
require "weapon/manager-weapon";
require "enemy/manager-enemy";
require "asset/config/game-timeline";
require "background";

State_Game = {};

function State_Game:init()
  BumpWorld = Bump.newWorld(32);
  self.player = Player();
  self.weaponManager = ManagerWeapon(self.player);
  self.enemyManager = ManagerEnemy(self.weaponManager);
  self.background = Background();

  self.music = love.audio.newSource("asset/music/gameplay.mp3");
  self.music:setVolume(0.3);

  self.timePassed = 0;
  self.timelineIndex = 1;
  self.lastTime = 0;
  self.totalTime = 0;
  for index, event in ipairs(GAME_TIMELINE) do
    self.totalTime = self.totalTime + event.time;
  end
end

function State_Game:enter()
  self.active = true;
  self.music:play();
end

function State_Game:leave()
  self.music:stop();
end

function State_Game:focus(focused)
  if focused then
    self.active = true;
    self.music:resume();
  else
    self.active = false;
    self.music:pause();
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
end

function State_Game:resume()
  self.player:resetKeys();
  self.music:resume();
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

function State_Game:update(dt)
  if not self.active then
    return;
  end

  self:updateTimeline(dt);
  self.background:update(dt);
  self.enemyManager:update(dt);
  self.player:update(dt);
  self.weaponManager:update(dt);
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
  self.player:draw();
  self.weaponManager:draw();

  if DRAW_POSITIONS then
    love.graphics.setColor(255, 255, 255);
    love.graphics.print("Player: " .. self.player.box.x .. ", " .. self.player.box.y, 32, 32);
    love.graphics.print("Total Time: " .. (self.totalTime / 60), 32, 64);
  end
end