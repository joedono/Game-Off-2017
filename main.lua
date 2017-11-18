GameState = require "lib/hump/gamestate";
Class = require "lib/hump/class";
Timer = require "lib/hump/timer";
Vector = require "lib/hump/vector";
Bump = require "lib/bump";

require "lib/general";
require "constants";

require "state/state-title";
require "state/state-game";

BumpWorld = {};

function love.load()
  GameState.registerEvents();
  GameState.switch(State_Title);
end

function love.keypressed(key, scancode, isrepeat)
  if key == KEY_QUIT then
    love.event.quit();
  end
end