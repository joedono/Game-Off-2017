Enemy = Class {
  init = function(self, x, y)
    self.box = {
      x = x,
      y = y,
      w = ENEMY_INITIAL_DIMENSIONS.w,
      h = ENEMY_INITIAL_DIMENSIONS.h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);

    self.moveTimer = 0;

    self.active = true;
    self.type = "enemy";
  end
};

function Enemy:update(dt)
  self.moveTimer = self.moveTimer + dt;
  self.box.x = cerp(ENEMY_LEFT_LIMIT, ENEMY_RIGHT_LIMIT, self.moveTimer / ENEMY_MOVEMENT_RATE);

  BumpWorld:update(self, self.box.x, self.box.y);

  if self.moveTimer > ENEMY_MOVEMENT_RATE * 2 then
    self.moveTimer = 0;
  end
end

function Enemy:draw()
  love.graphics.setColor(255, 0, 0);
  love.graphics.rectangle("fill", self.box.x, self.box.y, self.box.w, self.box.h);

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", BumpWorld:getRect(self));
  end
end