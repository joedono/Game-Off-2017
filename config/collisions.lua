playerCollision = function(player, other)
  if not other.active then
    return nil;
  end

  if other.type == "bullet" or other.type == "bulletPickup" then
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

  return nil;
end

enemyCollision = function(enemy, other)
  if not other.active then
    return nil;
  end

  if other.type == "bulletPickup" and other.thrown then
    return "touch";
  end

  return nil;
end