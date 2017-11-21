State_Credits = {};

function State_Credits:init()
  self.image = love.graphics.newImage("asset/image/screen/credits.png");
  self.music = love.audio.newSource("asset/music/credits.mp3");
  self.music:setVolume(0.3);
end

function State_Credits:enter()
  if PLAY_MUSIC then
    self.music:play();
  end
end

function State_Credits:focus(focused)
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

function State_Credits:keypressed(key, scancode, isrepeat)
  if key == KEY_FIRE_STREAM then
    GameState.switch(State_Title);
  end
end

function State_Credits:gamepadpressed(joystick, button)
  if button == "start" then
    GameState.switch(State_Title);
  end
end

function State_Credits:leave()
  if PLAY_MUSIC then
    self.music:stop();
  end
end

function State_Credits:draw()
  love.graphics.setColor(255, 255, 255);
  love.graphics.draw(self.image, 0, 0);
end