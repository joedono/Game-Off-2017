require "enemy/enemy-straight";
require "enemy/enemy-pendulum";

ManagerEnemy = Class {
  init = function(self, weaponManager)
    self.weaponManager = weaponManager;
    self.enemies = {};

    table.insert(self.enemies, EnemyStraight(100, 0, self.weaponManager));
  end
};

function ManagerEnemy:spawnEnemy(bx, by, type)

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
end