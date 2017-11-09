Background = Class {
  init = function(self)
    self.image = love.graphics.newImage("asset/image/background.png");
    self.positions = {-SCREEN_HEIGHT, 0};
  end
};

function Background:update(dt)
  for i, p in ipairs(self.positions) do
    self.positions[i] = self.positions[i] + BACKGROUND_SPEED * dt;
    if self.positions[i] > SCREEN_HEIGHT then
      self.positions[i] = -SCREEN_HEIGHT;
    end
  end
end

function Background:draw()
  for i, p in ipairs(self.positions) do
    love.graphics.draw(self.image, 0, p);
  end
end