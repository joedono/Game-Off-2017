Wall = Class {
  init = function(self, x, y, w, h)
    self.box = {
      x = x,
      y = y,
      w = w,
      h = h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);

    self.active = true;
    self.type = "wall";
  end
};

function Wall:draw()
  love.graphics.setColor(0, 255, 0);
  love.graphics.rectangle("fill", self.box.x, self.box.y, self.box.w, self.box.h);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", BumpWorld:getRect(self));
  end
end