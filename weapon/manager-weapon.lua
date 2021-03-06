require "weapon/weapon-bullet";
require "weapon/weapon-bullet-pickup";

ManagerWeapon = Class {
  init = function(self, player)
    self.weapons = {};
    self.effects = {};
    self.player = player;

    self.imageBullet = love.graphics.newImage("asset/image/sprite/bullet.png");
    self.imageBulletPickup = love.graphics.newImage("asset/image/sprite/bullet-pickup.png");

    local partImage = love.graphics.newImage("asset/image/effect/effect-bullet-death.png");
    local ps = love.graphics.newParticleSystem(partImage, 50);
    ps:setColors(
      255, 255, 255, 255,
      255, 255, 175, 150,
      255, 0, 0, 0
    );
    ps:setEmissionRate(0);
    ps:setParticleLifetime(0.5, 1.5);
    ps:setSpeed(10, 40);
    ps:setSpread(math.pi * 2);
    self.bulletDeathEffect = ps;
  end
};

function ManagerWeapon:spawnBullet(bx, by, type)
  local bullet = nil;
  if type == "bullet" then
    bullet = Bullet(bx, by, self.imageBullet);
  elseif type == "bullet-pickup" then
    bullet = BulletPickup(bx, by, self.imageBulletPickup);
  end

  table.insert(self.weapons, bullet);
  return bullet;
end

function ManagerWeapon:spawnBulletWithVelocity(bx, by, vx, vy, type)
  local bullet = nil;

  if type == "bullet" then
    bullet = Bullet(bx, by, self.imageBullet);
  elseif type == "bullet-pickup" then
    bullet = BulletPickup(bx, by, self.imageBulletPickup);
  end

  bullet.velocity.x = vx;
  bullet.velocity.y = vy;

  table.insert(self.weapons, bullet);
end

function ManagerWeapon:spawnBossBomb(bx, by)
  local bombBullets;
  local masterBullet = Bullet(bx, by + 1, self.imageBullet);
  masterBullet:setLife(BOSS_BOMB_LIFE);
  local slaveBullets = {};

  for index = 1, BOSS_BOMB_SIZE - 1 do
    if love.math.random() < 0.4 then
      table.insert(slaveBullets, BulletPickup(bx, by, self.imageBulletPickup));
    else
      table.insert(slaveBullets, Bullet(bx, by, self.imageBullet));
    end
  end

  masterBullet.slaves = slaveBullets;
  table.insert(self.weapons, masterBullet);

  for index, bullet in ipairs(slaveBullets) do
    bullet.isSlave = true;
    table.insert(self.weapons, bullet);
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
      if weapon.slaves and #weapon.slaves > 0 then
        weapon:throwSlaves();
      end

      BumpWorld:remove(weapon);

      if not weapon.isOffScreen then
        local ps = self.bulletDeathEffect:clone();
        if weapon.type == "bullet" then
          ps:setColors(
            255, 0, 0, 255,
            255, 0, 0, 0
          );
        elseif weapon.type == "bullet-pickup" then
          ps:setColors(
            0, 255, 0, 255,
            0, 255, 0, 0
          );
        end

        ps:setPosition(weapon.box.x + weapon.box.w / 2, weapon.box.y + weapon.box.h / 2);
        ps:emit(50);
        table.insert(self.effects, ps);
      end
    end
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
  love.graphics.setColor(255, 255, 255);
  for index, weapon in ipairs(self.weapons) do
    weapon:draw();
  end

  for index, effect in ipairs(self.effects) do
    love.graphics.draw(effect);
  end
end