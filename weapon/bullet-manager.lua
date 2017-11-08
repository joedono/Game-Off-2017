require "weapon/bullet";

BulletManager = Class {
  init = function(self, player)
    self.bullets = {};
    self.player = player;
  end
};

function BulletManager:spawnBullet(bx, by, type)
  table.insert(self.bullets, Bullet(bx, by, type));
end

function BulletManager:update(dt)
  local activeBullets = {};

  for index, bullet in ipairs(self.bullets) do
    bullet:update(dt, self.player);

    if bullet.active then
      table.insert(activeBullets, bullet);
    end
  end

  self.bullets = activeBullets;
end

function BulletManager:draw()
  for index, bullet in ipairs(self.bullets) do
    bullet:draw();
  end
end