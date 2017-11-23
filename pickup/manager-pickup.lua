require "pickup/pickup-health";

ManagerPickup = Class {
  init = function(self)
    self.weaponManager = weaponManager;
    self.pickups = {};

    self.imagePickupHealth = love.graphics.newImage("asset/image/sprite/health.png");
  end
};

function ManagerPickup:spawnHealth(x, y)
  x = x - HEALTH_WIDTH / 2;
  y = y - HEALTH_HEIGHT / 2;
  table.insert(self.pickups, PickupHealth(x, y, self.imagePickupHealth));
end

function ManagerPickup:update(dt)
  local activePickups = {};

  for index, pickup in ipairs(self.pickups) do
    pickup:update(dt);

    if pickup.active then
      table.insert(activePickups, pickup);
    else
      BumpWorld:remove(pickup);
    end
  end

  self.pickups = activePickups;
end

function ManagerPickup:draw()
  love.graphics.setColor(255, 255, 255);
  for index, pickup in ipairs(self.pickups) do
    pickup:draw();
  end
end