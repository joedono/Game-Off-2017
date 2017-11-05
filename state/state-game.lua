require "config/collisions";
require "player";
require "bullet";
require "wall";

State_Game = {};

function State_Game:init()
  BumpWorld = Bump.newWorld(32);
  self.player = Player();
  self.bullets = {};

  self.walls = {
    Wall(0, 0, SCREEN_WIDTH, WALL_DEPTH),
    Wall(0, 0, WALL_DEPTH, SCREEN_HEIGHT),

    Wall(0, SCREEN_HEIGHT - WALL_DEPTH, SCREEN_WIDTH, WALL_DEPTH),
    Wall(SCREEN_WIDTH - WALL_DEPTH, 0, WALL_DEPTH, SCREEN_HEIGHT)
  }
end

function State_Game:enter()
  self:startTimer();
end

function State_Game:keypressed(key, scancode, isrepeat)
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

  if key == KEY_PICKUP then
    self.player.pickUpPressed = true;
  end
end

function State_Game:resume()
  self.player:resetKeys();
  self:startTimer();
end

function State_Game:startTimer()
  Timer.every(1, function() self:spawnBullet() end);
end

function State_Game:leave()
  Timer.clear();
end

function State_Game:spawnBullet()
  local buffer = BULLET_SIZE + 5
  local bx = love.math.random(WALL_DEPTH + buffer, SCREEN_WIDTH - WALL_DEPTH - buffer);
  table.insert(self.bullets, Bullet(bx, WALL_DEPTH + buffer));
end

function State_Game:keyreleased(key, scancode)
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

  if key == KEY_PICKUP and self.player.caughtBall ~= nil then
    self.player.caughtBall:throw(self.player);
    self.player.holding = false;
    self.player.pickUpPressed = false;
  end
end

function State_Game:update(dt)
  local activeBullets = {};

  Timer.update(dt);
  self.player:update(dt);
  for index, bullet in ipairs(self.bullets) do
    bullet:update(dt, self.player);

    if bullet.active then
      table.insert(activeBullets, bullet);
    end
  end

  self.bullets = activeBullets;
end

function State_Game:draw()
  love.graphics.setColor(255, 255, 255);
  for i, w in ipairs(self.walls) do
    w:draw();
  end
  self.player:draw();
  for index, bullet in ipairs(self.bullets) do
    bullet:draw();
  end

  if DRAW_POSITIONS then
    love.graphics.setColor(255, 255, 255);
    love.graphics.print("Player: " .. self.player.box.x .. ", " .. self.player.box.y, 32, 32);
  end
end