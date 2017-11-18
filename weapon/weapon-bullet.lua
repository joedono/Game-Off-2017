Bullet = Class {
  init = function(self, x, y, image)
    self.box = {
      x = x,
      y = y,
      w = BULLET_INITIAL_DIMENSIONS.w,
      h = BULLET_INITIAL_DIMENSIONS.h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);
    self.image = image;

    self.velocity = { x = 0, y = BULLET_SPEED };

    self.active = true;
    self.type = "bullet";
  end
};

function Bullet:update(dt, player)
  if not self.active then
    return;
  end

  local dx = self.box.x + self.velocity.x * dt;
  local dy = self.box.y + self.velocity.y * dt;

  local actualX, actualY, cols, len = BumpWorld:move(self, dx, dy, bulletCollision);

  self.box.x = actualX;
  self.box.y = actualY;

  if self.box.x < 0 - BULLET_WIDTH or self.box.x > SCREEN_WIDTH or self.box.y > SCREEN_HEIGHT then
    self.active = false;
  end
end

function Bullet:draw()
  if not self.active then
    return;
  end

  love.graphics.setColor(255, 255, 255);
  love.graphics.draw(self.image, self.box.x, self.box.y);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", BumpWorld:getRect(self));
  end
end