playerCollision = function(player, other)
  if not other.active then
    return nil;
  end

  if other.type == "ball" then
    if other.pickedUp then
      return nil;
    end

    if player.pickUpPressed then
      other:pickUp();
      return "cross";
    end
  end

  return nil;
end

ballCollision = function(ball, other)
  return nil;
end