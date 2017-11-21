Background = Class {
  init = function(self)
    self.image = love.graphics.newImage("asset/image/background.png");
    self.positions = {-SCREEN_HEIGHT, 0};
  end
};

function Background:update(dt)
  for i, p in ipairs(self.positions) do
    self.positions[i] = math.floor(self.positions[i] + BACKGROUND_SPEED * dt);
    if self.positions[i] > SCREEN_HEIGHT then
      self.positions[i] = -SCREEN_HEIGHT;
    end
  end
end

function Background:draw()
  love.graphics.setColor(58, 46, 63);
  love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

  love.graphics.setColor(255, 255, 255);
  for i, p in ipairs(self.positions) do
    love.graphics.draw(self.image, 0, p);
  end
end