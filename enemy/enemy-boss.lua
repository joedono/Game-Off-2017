EnemyBoss = Class {
  init = function(self, x, y, weaponManager, image)
    self.box = {
      x = x,
      y = y,
      w = BOSS_INITIAL_DIMENSIONS.w,
      h = BOSS_INITIAL_DIMENSIONS.h
    };

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);
    self.image = image;
    self.weaponManager = weaponManager;

    self.active = true;
    self.type = "boss";
  end
};

function EnemyBoss:update(dt)

end

function EnemyBoss:draw()
  
end