playerCollision = function(player, other)
  if not other.active then
    return nil;
  end

  if other.type == "ball" then
    -- TODO check if ball should be picked up
  end

  return nil;
end

ballCollision = function(ball, other)
  return nil;
end