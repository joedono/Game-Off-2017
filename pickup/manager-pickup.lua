require "pickup/pickup-health";

ManagerPickup = Class {
  init = function(self)
    self.weaponManager = weaponManager;
    self.pickups = {};

    self.imagePickupHealth = love.graphics.newImage("asset/image/sprite/health.png");
  end
};

function ManagerPickup:spawnHealth(x, y)
  -- TODO
end

function ManagerPickup:update(dt)
  local activePickups = {};

  for index, pickup in ipairs(self.pickups) do
    pickup:update(dt);

    if pickup.active then
      table.insert(activePickups, pickup);
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