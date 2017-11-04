Ball = Class {
  init = function(self, x, y)
    self.box = {
      x = x,
      y = y,
      w = BALL_INITIAL_DIMENSIONS.w,
      h = BALL_INITIAL_DIMENSIONS.h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);

    self.velocity = { x = 0, y = BALL_SPEED };

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
  local dx = player.facing.x;
  local dy = -1;

  dx, dy = math.normalize(dx, dy);

  dx = player.box.x + player.box.w / 2 + dx * 20;
  dy = player.box.y + player.box.h / 2 + dy * 20;

  dx = dx - BALL_SIZE;
  dy = dy - BALL_SIZE;

  self.box.x = dx;
  self.box.y = dy;
end

function Ball:moveAndBounce(dt)
  local dx = self.box.x + self.velocity.x * dt;
  local dy = self.box.y + self.velocity.y * dt;

  dx = math.clamp(dx, 0, SCREEN_WIDTH - BALL_SIZE * 2);
  dy = math.clamp(dy, 0, SCREEN_HEIGHT - BALL_SIZE * 2);

  local actualX, actualY, cols, len = BumpWorld:move(self, dx, dy, ballCollision);

  for i = 1, len do
    if cols[i].other.type == "wall" then
      local vx = cols[i].bounce.x - cols[i].touch.x;
      local vy = cols[i].bounce.y - cols[i].touch.y;

      vx, vy = math.normalize(vx, vy);

      self.velocity.x = vx * BALL_SPEED;
      self.velocity.y = vy * BALL_SPEED;
    end
  end

  self.box.x = actualX;
  self.box.y = actualY;
end

function Ball:throw(player)
  if not self.pickedUp then
    return;
  end

  local vx = player.facing.x;
  local vy = -1;

  vx, vy = math.normalize(vx, vy);

  self.velocity.x = vx * BALL_SPEED;
  self.velocity.y = vy * BALL_SPEED;
  self.pickedUp = false;
end

function Ball:draw()
  love.graphics.setColor(255, 0, 0);
  love.graphics.circle("fill", self.box.x + self.box.w / 2, self.box.y + self.box.h / 2, BALL_SIZE);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", self.box.x, self.box.y, self.box.w, self.box.h);
  end
end