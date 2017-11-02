Player = Class {
  init = function(self)
    self.box = {
      x = PLAYER_INITIAL_DIMENSIONS.x,
      y = PLAYER_INITIAL_DIMENSIONS.y,
      w = PLAYER_INITIAL_DIMENSIONS.w,
      h = PLAYER_INITIAL_DIMENSIONS.h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);

    self.leftPressed = false;
    self.rightPressed = false;
    self.upPressed = false;
    self.downPressed = false;
    self.pickUpPressed = false;

    self.velocity = { x = 0, y = 0 };
    self.rotation = 0;

    self.active = true;
    self.type = "player";
  end
};

function Player:resetKeys()
  self.leftPressed = false;
  self.rightPressed = false;
  self.upPressed = false;
  self.downPressed = false;
  self.pickUpPressed = false;
end

function Player:update(dt)
  self:updateVelocity();
  self:updateRotation();
  self:updatePosition(dt);
end

function Player:updateVelocity()
  local vx = 0;
  local vy = 0;

  if self.leftPressed then
    vx = vx - 1;
  end

  if self.rightPressed then
    vx = vx + 1;
  end

  if self.upPressed then
    vy = vy - 1;
  end

  if self.downPressed then
    vy = vy + 1;
  end

  if vx ~= 0 or vy ~= 0 then
    vx, vy = math.normalize(vx, vy);
  end

  self.velocity.x = vx * PLAYER_SPEED;
  self.velocity.y = vy * PLAYER_SPEED;
end

function Player:updateRotation()
  if self.velocity.x ~= 0 or self.velocity.y ~= 0 then
    if self.velocity.y < 0 then
      self.rotation = 3;
    elseif self.velocity.y > 0 then
      self.rotation = 1;
    end

    if self.velocity.x < 0 then
      self.rotation = 2;
    elseif self.velocity.x > 0 then
      self.rotation = 0;
    end
  end
end

function Player:updatePosition(dt)
  local dx = self.box.x + self.velocity.x * dt;
  local dy = self.box.y + self.velocity.y * dt;

  dx = math.clamp(dx, 0, SCREEN_WIDTH - PLAYER_WIDTH);
  dy = math.clamp(dy, 0, SCREEN_HEIGHT - PLAYER_HEIGHT);

  local actualX, actualY, cols, len = BumpWorld:move(self, dx, dy, playerCollision);

  self.box.x = actualX;
  self.box.y = actualY;
end

function Player:draw()
  love.graphics.setColor(0, 0, 255);
  love.graphics.rectangle("fill", self.box.x, self.box.y, self.box.w, self.box.h);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", self.box.x, self.box.y, self.box.w, self.box.h);
  end
end