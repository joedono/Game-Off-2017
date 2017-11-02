GameState = require "lib/hump/gamestate";
Class = require "lib/hump/class";
Bump = require "lib/bump";

require "lib/general";
require "config/constants";

require "state/state-game";

BumpWorld = {};

function love.load()
  GameState.registerEvents();
  GameState.switch(State_Game);
end

function love.keypressed(key, scancode, isrepeat)
  if key == KEY_QUIT then
    love.event.quit();
  end
end