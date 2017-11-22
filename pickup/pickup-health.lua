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

function BulletPickup:update(dt)
  -- TODO
end

function BulletPickup:draw()
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