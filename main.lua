GameState = require "lib/hump/gamestate";
Class = require "lib/hump/class";
Timer = require "lib/hump/timer";
Vector = require "lib/hump/vector";
Bump = require "lib/bump";

require "lib/general";
require "config/constants";
require "config/sound-effects";

require "state/state-title";
require "state/state-game";
require "state/state-pause";
require "state/state-credits";

BumpWorld = {};

function love.load()
  love.window.setFullscreen(FULLSCREEN);
  
  CANVAS = love.graphics.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT);
  CANVAS:setFilter("nearest");

  CANVAS_OFFSET_X = love.graphics.getWidth() / 2 - SCREEN_WIDTH / 2;
  CANVAS_OFFSET_Y = love.graphics.getHeight() / 2 - SCREEN_HEIGHT / 2;

  SFX_SHOOT:setVolume(0.2);
  GameState.registerEvents();
  GameState.switch(State_Title);
end

function love.keypressed(key, scancode, isrepeat)
  if key == KEY_QUIT then
    love.event.quit();
  end
end

function love.gamepadpressed(joystick, button)
  if button == JOY_QUIT then
    love.event.quit();
  end
end