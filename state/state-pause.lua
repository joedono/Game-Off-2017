State_Pause = {};

function State_Pause:enter(from)
  self.from = from;
end

function State_Pause:keypressed(key, scancode, isrepeat)
  if key == KEY_PAUSE then
    GameState.pop();
  end
end

function State_Pause:gamepadpressed(joystick, button)
  if button == JOY_START then
    GameState.pop();
  end
end

function State_Pause:draw()
  self.from:draw();

  love.graphics.setColor(0, 0, 0, 150);
  love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

  love.graphics.setColor(255, 255, 255);
  love.graphics.print("PAUSED", SCREEN_WIDTH / 2 - 120, SCREEN_HEIGHT / 2 - 50, 0, 5, 5);
end