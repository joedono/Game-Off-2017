require "config/collisions";
require "player";
require "ball";

State_Game = {};

function State_Game:init()
  BumpWorld = Bump.newWorld(32);
  self.player = Player();
  self.ball = Ball();
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

  if key == KEY_PICKUP then
    self.ball:throw();
    self.player.pickUpPressed = false;
  end
end

function State_Game:update(dt)
  self.player:update(dt);
  self.ball:update(dt, self.player);
end

function State_Game:draw()
  love.graphics.setColor(255, 255, 255);
  self.player:draw();
  self.ball:draw();

  if DRAW_POSITIONS then
    love.graphics.setColor(255, 255, 255);
    love.graphics.print("Player: " .. self.player.box.x .. ", " .. self.player.box.y, 32, 32);
    love.graphics.print("Ball: " .. self.ball.box.x .. ", " .. self.ball.box.y, 32, 48);
  end
end