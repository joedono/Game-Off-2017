require "config/collisions";
require "player";

State_Game = {};

function State_Game:init()
  BumpWorld = Bump.newWorld(32);
  self.player = Player();
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
end

function State_Game:resume()
  self.player.leftPressed = false;
  self.player.rightPressed = false;
  self.player.upPressed = false;
  self.player.downPressed = false;
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
end

function State_Game:update(dt)
  self.player:update(dt);
end

function State_Game:draw()
  love.graphics.setColor(255, 255, 255);
  self.player:draw();

  if DRAW_POSITIONS then
    love.graphics.setColor(255, 255, 255);
    love.graphics.print("Player: " .. self.player.box.x .. ", " .. self.player.box.y, 32, 32);
  end
end