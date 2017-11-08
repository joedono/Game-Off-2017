require "enemy/enemy-straight";
require "enemy/enemy-pendulum";
require "enemy/enemy-sideways";

ManagerEnemy = Class {
  init = function(self, weaponManager)
    self.weaponManager = weaponManager;
    self.enemies = {};
  end
};

function ManagerEnemy:spawnEnemy(enemy)
  if enemy.type == "straight" then
    table.insert(self.enemies, EnemyStraight(enemy.x, enemy.y, self.weaponManager));
  elseif enemy.type == "sideways" then
    table.insert(self.enemies, EnemySideways(enemy.x, enemy.y, self.weaponManager));
  elseif enemy.type == "pendulum" then
    table.insert(self.enemies, EnemyPendulum(enemy.x, enemy.y, self.weaponManager));
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