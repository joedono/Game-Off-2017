State_Title = {};

function State_Title:init()
  self.image = love.graphics.newImage("asset/image/screen/title.png");
  self.music = love.audio.newSource("asset/music/title.mp3");
  self.music:setVolume(0.3);
end

function State_Title:enter()
  if PLAY_MUSIC then
    self.music:play();
  end
end

function State_Title:focus(focused)
  if focused then
    if PLAY_MUSIC then
      self.music:resume();
    end
  else
    if PLAY_MUSIC then
      self.music:pause();
    end
  end
end

function State_Title:keypressed(key, scancode, isrepeat)
  if key == KEY_FIRE_STREAM then
    GameState.switch(State_Game);
  end
end

function State_Title:gamepadpressed(joystick, button)
  if button == JOY_START then
    GameState.switch(State_Game);
  end
end

function State_Title:leave()
  if PLAY_MUSIC then
    self.music:stop();
  end
end

function State_Title:draw()
  CANVAS:renderTo(function()
    love.graphics.clear();
    love.graphics.setColor(255, 255, 255);
    love.graphics.draw(self.image, 0, 0);
  end);

  love.graphics.setColor(255, 255, 255);
  love.graphics.draw(CANVAS, CANVAS_OFFSET_X, CANVAS_OFFSET_Y, 0, CANVAS_SCALE, CANVAS_SCALE);
end