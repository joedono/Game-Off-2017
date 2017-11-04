require "config/collisions";
require "player";
require "ball";
require "wall";

State_Game = {};

function State_Game:init()
  BumpWorld = Bump.newWorld(32);
  self.player = Player();
  self.balls = {
    Ball(350, 40),
    Ball(450, 40),
  };

  self.walls = {
    Wall(0, 0, SCREEN_WIDTH, WALL_DEPTH),
    Wall(0, 0, WALL_DEPTH, SCREEN_HEIGHT),

    Wall(0, SCREEN_HEIGHT - WALL_DEPTH, SCREEN_WIDTH, WALL_DEPTH),
    Wall(SCREEN_WIDTH - WALL_DEPTH, 0, WALL_DEPTH, SCREEN_HEIGHT)
  }
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
  self.player:update(dt);
  for index, ball in ipairs(self.balls) do
    ball:update(dt, self.player);
  end
end

function State_Game:draw()
  love.graphics.setColor(255, 255, 255);
  for i, w in ipairs(self.walls) do
    w:draw();
  end
  self.player:draw();
  for index, ball in ipairs(self.balls) do
    ball:draw();
  end

  if DRAW_POSITIONS then
    love.graphics.setColor(255, 255, 255);
    love.graphics.print("Player: " .. self.player.box.x .. ", " .. self.player.box.y, 32, 32);
    love.graphics.print("Ball: " .. self.ball.box.x .. ", " .. self.ball.box.y, 32, 48);
    love.graphics.print("Ball Velocity: " .. self.ball.velocity.x .. ", " .. self.ball.velocity.y, 32, 64);
  end
end