require "enemy/enemy-pendulum";

EnemyManager = Class {
  init = function(self, bulletManager)
    self.bulletManager = bulletManager;
    self.enemies = {};

    table.insert(self.enemies, EnemyPendulum(100, 0, self.bulletManager));
  end
};

function EnemyManager:spawnEnemy(bx, by, type)

end

function EnemyManager:update(dt)
  local activeEnemies = {};

  for index, enemy in ipairs(self.enemies) do
    enemy:update(dt, self.player);

    if enemy.active then
      table.insert(activeEnemies, enemy);
    end
  end

  self.enemies = activeEnemies;
end

function EnemyManager:draw()
  for index, enemy in ipairs(self.enemies) do
    enemy:draw();
  end
end