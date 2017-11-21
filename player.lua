Player = Class {
  init = function(self)
    self.box = {
      x = PLAYER_INITIAL_DIMENSIONS.x,
      y = PLAYER_INITIAL_DIMENSIONS.y,
      w = PLAYER_INITIAL_DIMENSIONS.w,
      h = PLAYER_INITIAL_DIMENSIONS.h
    };

    self.pickupBox = {
      x = PICKUP_BOX_INITIAL_DIMENSIONS.x,
      y = PICKUP_BOX_INITIAL_DIMENSIONS.y,
      w = PICKUP_BOX_INITIAL_DIMENSIONS.w,
      h = PICKUP_BOX_INITIAL_DIMENSIONS.h,
      type = "pickup-box"
    }

    BumpWorld:add(self, self.box.x, self.box.y, self.box.w, self.box.h);
    BumpWorld:add(self.pickupBox, self.pickupBox.x, self.pickupBox.y, self.pickupBox.w, self.pickupBox.h);
    self.shipImage = love.graphics.newImage("asset/image/sprite/player.png");

    self:resetKeys();

    self.velocity = { x = 0, y = 0 };
    self.facing = { x = 0, y = 0 };
    self.caughtBullets = {};
    self.forcefieldBullets = {};
    self.health = PLAYER_MAX_HEALTH;

    self.streamTimer = Timer.new();

    self.active = true;
    self.type = "player";
  end
};

function Player:resetKeys()
  self.leftPressed = false;
  self.rightPressed = false;
  self.upPressed = false;
  self.downPressed = false;
  self.runPressed = false;

  self.streaming = false;
end

function Player:fireStream()
  self:clearForcefield();

  if not self.streaming then
    local caughtBullets = self.caughtBullets;
    self.caughtBullets = {};

    self.streamTimer:script(function(wait)
      self.streaming = true;

      while #caughtBullets > 0 do
        caughtBullets[1]:throwStraight(false);
        table.remove(caughtBullets, 1);
        wait(0.2);
      end

      self.streaming = false;
    end);
  end
end

function Player:fireSpread()
  self:clearForcefield();

  local caughtBullets = self.caughtBullets;
  self.caughtBullets = {};

  for index, bullet in ipairs(caughtBullets) do
    local angle = BULLET_SPREAD[index];
    bullet:throwSpread(angle);
  end
end

function Player:fireBomb()
  self:clearForcefield();

  local caughtBullets = self.caughtBullets;
  self.caughtBullets = {};

  for index, bullet in ipairs(caughtBullets) do
    if index == 1 then
      bullet:throwBombMaster(caughtBullets);
    else
      bullet:throwStraight(true);
    end
  end
end

function Player:fireForcefield()
  self:clearForcefield();

  local caughtBullets = self.caughtBullets;
  local count = #caughtBullets;
  local ratio = 0;
  self.forcefieldBullets = caughtBullets;
  self.caughtBullets = {};

  if count == 0 then
    return;
  end

  for index, bullet in ipairs(caughtBullets) do
    ratio = index / count;
    bullet:throwForcefield(ratio);
  end
end

function Player:clearForcefield()
  for index, bullet in ipairs(self.forcefieldBullets) do
    bullet.active = false;
  end

  self.forcefieldBullets = {};
end

function Player:update(dt)
  if not self.active then
    return;
  end

  self.streamTimer:update(dt);
  self:updateVelocity();
  self:updateRotation();
  self:updatePosition(dt);
end

function Player:updateVelocity()
  local vx = 0;
  local vy = 0;

  if self.leftPressed then
    vx = vx - 1;
  end

  if self.rightPressed then
    vx = vx + 1;
  end

  if self.upPressed then
    vy = vy - 1;
  end

  if self.downPressed then
    vy = vy + 1;
  end

  if vx ~= 0 or vy ~= 0 then
    vx, vy = math.normalize(vx, vy);
  end

  self.velocity.x = vx * PLAYER_SPEED;
  self.velocity.y = vy * PLAYER_SPEED;
end

function Player:updateRotation()
  if self.velocity.x ~= 0 or self.velocity.y ~= 0 then
    local fx, fy = math.normalize(self.velocity.x, self.velocity.y);
    self.facing.x = fx;
    self.facing.y = fy;
  end
end

function Player:updatePosition(dt)
  local dx = self.box.x + self.velocity.x * dt;
  local dy = self.box.y + self.velocity.y * dt;

  dx = math.clamp(dx, 0, SCREEN_WIDTH - PLAYER_WIDTH);
  dy = math.clamp(dy, 0, SCREEN_HEIGHT - PLAYER_HEIGHT);

  local actualX, actualY, cols, len = BumpWorld:move(self, dx, dy, playerCollision);

  for i = 1, len do
    if cols[i].other.type == "bullet" then
      if KILL_PLAYER then
        self.health = self.health - 1;

        if self.health <= 0 then
          for index, bullet in ipairs(self.caughtBullets) do
            bullet.active = false;
          end

          self.caughtBullets = {};
          self.active = false;
        end
      end
      cols[i].other.active = false;
    end
  end

  self.box.x = actualX;
  self.box.y = actualY;

  local pux = actualX + PLAYER_WIDTH / 2 - PICKUP_BOX_WIDTH / 2;
  local puy = actualY + PLAYER_HEIGHT / 2 - PICKUP_BOX_HEIGHT / 2;

  local actualX, actualY, cols, len = BumpWorld:move(self.pickupBox, pux, puy, pickupBoxCollision);

  for i = 1, len do
    if cols[i].other.type == "bullet-pickup" and not cols[i].other.pickedUp and not cols[i].other.thrown then
      if #self.caughtBullets < MAX_HELD_BULLETS then
        table.insert(self.caughtBullets, cols[i].other);
        cols[i].other:pickUp();
      else
        cols[i].other.active = false;
      end
    end
  end

  self.pickupBox.x = actualX;
  self.pickupBox.y = actualY;
end

function Player:draw()
  if not self.active then
    return;
  end

  love.graphics.setColor(255, 255, 255, 150);
  love.graphics.rectangle("line", self.pickupBox.x, self.pickupBox.y, self.pickupBox.w, self.pickupBox.h);

  love.graphics.setColor(255, 255, 255);
  love.graphics.draw(self.shipImage, self.box.x, self.box.y, 0, PLAYER_SCALE, PLAYER_SCALE);

  -- Draw Health
  love.graphics.setColor(0, 255, 255);
  for i=1, self.health do
    love.graphics.rectangle("fill", i * 68, 16, 60, 32);
  end

  for i=self.health, PLAYER_MAX_HEALTH do
    love.graphics.rectangle("line", i * 68, 16, 60, 32);
  end

  if DRAW_BOXES then
    love.graphics.setColor(255, 255, 255);
    love.graphics.rectangle("line", BumpWorld:getRect(self));
  end
end