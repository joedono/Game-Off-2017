require "weapon/weapon-bullet";
require "weapon/weapon-bullet-pickup";

ManagerWeapon = Class {
  init = function(self, player)
    self.weapons = {};
    self.player = player;

    self.imageBullet = love.graphics.newImage("asset/image/bullet.png");
    self.imageBulletPickup = love.graphics.newImage("asset/image/bullet-pickup.png");
  end
};

function ManagerWeapon:spawnBullet(bx, by, type)
  if type == "bullet" then
    table.insert(self.weapons, Bullet(bx, by, self.imageBullet));
  elseif type == "bullet-pickup" then
    table.insert(self.weapons, BulletPickup(bx, by, self.imageBulletPickup));
  end
end

function ManagerWeapon:update(dt)
  local activeWeapons = {};

  for index, weapon in ipairs(self.weapons) do
    weapon:update(dt, self.player);

    if weapon.active then
      table.insert(activeWeapons, weapon);
    end
  end

  self.weapons = activeWeapons;
end

function ManagerWeapon:draw()
  for index, weapon in ipairs(self.weapons) do
    weapon:draw();
  end
end