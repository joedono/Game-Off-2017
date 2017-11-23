PickupHealth = Class {
  init = function(self, x, y, image)
    self.box = {
      x = x,
      y = y,
      w = HEALTH_INITIAL_DIMENSIONS.w,
      h = HEALTH_INITIAL_DIMENSIONS.h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);

    self.velocity = { x = 0, y = HEALTH_SPEED };
    self.image = image;

    self.active = true;
    self.type = "pickup-health";
  end
};

function PickupHealth:update(dt)
  if not self.active then
    return;
  end
  
  local dy = self.box.y + HEALTH_SPEED * dt;
  local actualX, actualY, cols, len = BumpWorld:move(self, self.box.x, dy, healthCollision);

  self.box.x = actualX;
  self.box.y = actualY;

  if self.box.x < 0 - HEALTH_WIDTH or self.box.x > SCREEN_WIDTH or self.box.y > SCREEN_HEIGHT then
    self.active = false;
  end
end

function PickupHealth:draw()
  if not self.active then
    return;
  end

  love.graphics.setColor(255, 255, 255);
  love.graphics.draw(self.image, self.box.x, self.box.y, 0, HEALTH_SCALE, HEALTH_SCALE);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", BumpWorld:getRect(self));
  end
end