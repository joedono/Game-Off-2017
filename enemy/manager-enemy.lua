require "enemy/enemy-straight";
require "enemy/enemy-pendulum";
require "enemy/enemy-sideways";
require "enemy/enemy-boss";

ManagerEnemy = Class {
  init = function(self, weaponManager, pickupManager)
    self.weaponManager = weaponManager;
    self.pickupManager = pickupManager;
    self.enemies = {};
    self.effects = {};

    self.imageEnemyStraight = love.graphics.newImage("asset/image/sprite/enemy-straight.png");
    self.imageEnemySideways = love.graphics.newImage("asset/image/sprite/enemy-sideways.png");
    self.imageEnemyPendulum = love.graphics.newImage("asset/image/sprite/enemy-pendulum.png");
    self.imageEnemyBoss = love.graphics.newImage("asset/image/sprite/boss.png");

    self.bossIsActive = false;

    local partImage = love.graphics.newImage("asset/image/effect/effect-enemy-death.png");
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
    self.enemyDeathEffect = ps;
  end
};

function ManagerEnemy:bossIsDead()
  if not self.bossIsActive then
    return false;
  end

  local boss = nil;
  for index, enemy in ipairs(self.enemies) do
    if enemy.type == "boss" then
      boss = enemy;
    end
  end

  if boss and boss.active then
    return false;
  end

  return true;
end

function ManagerEnemy:spawnEnemy(enemy)
  if enemy.type == "straight" then
    table.insert(self.enemies, EnemyStraight(enemy.x, enemy.y, self.weaponManager, self.imageEnemyStraight));
  elseif enemy.type == "sideways" then
    table.insert(self.enemies, EnemySideways(enemy.x, enemy.y, self.weaponManager, self.imageEnemySideways));
  elseif enemy.type == "pendulum" then
    table.insert(self.enemies, EnemyPendulum(enemy.x, enemy.y, self.weaponManager, self.imageEnemyPendulum));
  elseif enemy.type == "boss" then
    table.insert(self.enemies, EnemyBoss(enemy.x, enemy.y, self.weaponManager, self.pickupManager, self.imageEnemyBoss));
    self.bossIsActive = true;
  end
end

function ManagerEnemy:update(dt)
  self:updateEnemies(dt);
  self:updateEffects(dt);
end

function ManagerEnemy:updateEnemies(dt)
  local activeEnemies = {};

  for index, enemy in ipairs(self.enemies) do
    enemy:update(dt, self.player);

    if enemy.active then
      table.insert(activeEnemies, enemy);
    else
      BumpWorld:remove(enemy);

      if not enemy.isOffScreen then
        local ps = self.enemyDeathEffect:clone();
        ps:setPosition(enemy.box.x + enemy.box.w / 2, enemy.box.y + enemy.box.h / 2);
        ps:emit(50);
        table.insert(self.effects, ps);

        local spawnHealth = love.math.random(1, 10);
        if spawnHealth <= 2 then
          self.pickupManager:spawnHealth(enemy.box.x + enemy.box.w / 2, enemy.box.y + enemy.box.h / 2);
        end
      end
    end
  end

  self.enemies = activeEnemies;
end

function ManagerEnemy:updateEffects(dt)
  local activeEffects = {};

  for index, effect in ipairs(self.effects) do
    effect:update(dt);

    if effect:getCount() > 0 then
      table.insert(activeEffects, effect);
    end
  end

  self.effects = activeEffects;
end

function ManagerEnemy:draw()
  love.graphics.setColor(255, 255, 255);
  for index, enemy in ipairs(self.enemies) do
    enemy:draw();
  end

  for index, effect in ipairs(self.effects) do
    love.graphics.draw(effect);
  end

  if DRAW_COUNTS then
    love.graphics.setColor(255, 255, 255);
    love.graphics.print("Enemies: " .. #self.enemies, 32, 60);
  end
end