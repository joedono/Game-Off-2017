require "weapon/weapon-bullet";
require "weapon/weapon-bullet-pickup";

ManagerWeapon = Class {
  init = function(self, player)
    self.weapons = {};
    self.effects = {};
    self.player = player;

    self.imageBullet = love.graphics.newImage("asset/image/bullet.png");
    self.imageBulletPickup = love.graphics.newImage("asset/image/bullet-pickup.png");

    local partImage = love.graphics.newImage("asset/image/effect-bullet-death.png");
    local ps = love.graphics.newParticleSystem(partImage, 50);
    -- TODO build enemy death effect
    self.bulletDeathEffect = ps;
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
  self:updateWeapons(dt);
  self:updateEffects(dt);

end

function ManagerWeapon:updateWeapons(dt)
  local activeWeapons = {};

  for index, weapon in ipairs(self.weapons) do
    weapon:update(dt, self.player);

    if weapon.active then
      table.insert(activeWeapons, weapon);
    else
      local ps = self.bulletDeathEffect:clone();
      ps:setPosition(weapon.box.x + weapon.box.w / 2, weapon.box.y + weapon.box.h / 2);
      ps:emit(50);
      table.insert(self.effects, ps);
  end

  self.weapons = activeWeapons;
end

function ManagerWeapon:updateEffects(dt)
  local activeEffects = {};

  for index, effect in ipairs(self.effects) do
    effect:update(dt);

    if effect:getCount() > 0 then
      table.insert(activeEffects, effect);
    end
  end

  self.effects = activeEffects;
end

function ManagerWeapon:draw()
  for index, weapon in ipairs(self.weapons) do
    weapon:draw();
  end
end