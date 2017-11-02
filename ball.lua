Ball = Class {
  init = function(self)
    self.box = {
      x = BALL_INITIAL_DIMENSIONS.x,
      y = BALL_INITIAL_DIMENSIONS.y,
      w = BALL_INITIAL_DIMENSIONS.w,
      h = BALL_INITIAL_DIMENSIONS.h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);

    self.velocity = { x = 0, y = 0 };

    self.pickedUp = false;
    self.active = true;
    self.type = "ball";
  end
};

function Ball:pickUp()
  self.pickedUp = true;
end

function Ball:update(dt, player)
  if self.pickedUp then
    self:followPlayer(player);
  else
    self:moveAndBounce(dt);
  end
end

function Ball:followPlayer(player)
  --TODO stay in front of the player
end

function Ball:moveAndBounce(dt)
  local dx = self.box.x + self.velocity.x * dt;
  local dy = self.box.y + self.velocity.y * dt;

  dx = math.clamp(dx, 0, SCREEN_WIDTH - BALL_SIZE * 2);
  dy = math.clamp(dy, 0, SCREEN_HEIGHT - BALL_SIZE * 2);

  local actualX, actualY, cols, len = BumpWorld:move(self, dx, dy, ballCollision);

  self.box.x = actualX;
  self.box.y = actualY;
end

function Ball:throw()
  if not self.pickedUp then
    return;
  end

  --TODO throw ball in direction player is facing
end

function Ball:draw()
  love.graphics.setColor(255, 0, 0);
  love.graphics.circle("fill", self.box.x + self.box.w / 2, self.box.y + self.box.h / 2, BALL_SIZE);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", self.box.x, self.box.y, self.box.w, self.box.h);
  end
end