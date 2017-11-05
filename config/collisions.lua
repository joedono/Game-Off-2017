playerCollision = function(player, other)
  if not other.active then
    return nil;
  end

  if other.type == "wall" then
    return "slide";
  end

  if other.type == "bullet" then
    return "cross";
  end

  return nil;
end

bulletCollision = function(bullet, other)
  if not other.active then
    return nil;
  end

  if other.type == "enemy" and bullet.thrown then
    return "cross";
  end

  if other.type == "wall" then
    return "bounce";
  end

  return nil;
end