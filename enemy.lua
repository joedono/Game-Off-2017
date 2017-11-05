Enemy = Class {
  init = function(self, x, y)
    self.box = {
      x = x,
      y = y,
      w = ENEMY_INITIAL_DIMENSIONS.w,
      h = ENEMY_INITIAL_DIMENSIONS.h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);

    self.velocity = { x = 0, y = 0 };

    self.active = true;
    self.type = "enemy";
  end
};

function Enemy:update(dt)

end

function Enemy:draw()
  love.graphics.setColor(255, 0, 0);
  love.graphics.rectangle("fill", self.box.x, self.box.y, self.box.w, self.box.h);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", self.box.x, self.box.y, self.box.w, self.box.h);
  end
end