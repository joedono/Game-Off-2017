require "enemy/enemy-straight";
require "enemy/enemy-pendulum";
require "enemy/enemy-sideways";

ManagerEnemy = Class {
  init = function(self, weaponManager)
    self.weaponManager = weaponManager;
    self.enemies = {};

    self.imageEnemyStraight = love.graphics.newImage("asset/image/enemy-straight.png");
    self.imageEnemySideways = love.graphics.newImage("asset/image/enemy-sideways.png");
    self.imageEnemyPendulum = love.graphics.newImage("asset/image/enemy-pendulum.png");
  end
};

function ManagerEnemy:spawnEnemy(enemy)
  if enemy.type == "straight" then
    table.insert(self.enemies, EnemyStraight(enemy.x, enemy.y, self.weaponManager, self.imageEnemyStraight));
  elseif enemy.type == "sideways" then
    table.insert(self.enemies, EnemySideways(enemy.x, enemy.y, self.weaponManager, self.imageEnemySideways));
  elseif enemy.type == "pendulum" then
    table.insert(self.enemies, EnemyPendulum(enemy.x, enemy.y, self.weaponManager, self.imageEnemyPendulum));
  end
end

function ManagerEnemy:update(dt)
  local activeEnemies = {};

  for index, enemy in ipairs(self.enemies) do
    enemy:update(dt, self.player);

    if enemy.active then
      table.insert(activeEnemies, enemy);
    end
  end

  self.enemies = activeEnemies;
end

function ManagerEnemy:draw()
  for index, enemy in ipairs(self.enemies) do
    enemy:draw();
  end

  if DRAW_COUNTS then
    love.graphics.setColor(255, 255, 255);
    love.graphics.print("Enemies: " .. #self.enemies, 32, 60);
  end
end