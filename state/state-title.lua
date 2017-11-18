State_Title = {};

function State_Title:init()
  self.image = love.graphics.newImage("asset/image/title.png");
  self.music = love.audio.newSource("asset/music/title.mp3");
  self.music:setVolume(0.3);
end

function State_Title:enter()
  self.music:play();
end

function State_Title:focus(focused)
  if focused then
    self.music:resume();
  else
    self.music:pause();
  end
end

function State_Title:keypressed(key, scancode, isrepeat)
  if key == KEY_FIRE_STREAM then
    GameState.switch(State_Game);
  end
end

function State_Title:leave()
  self.music:stop();
end

function State_Title:draw()
  love.graphics.setColor(255, 255, 255);
  love.graphics.draw(self.image, 0, 0);
end