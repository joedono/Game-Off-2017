playerCollision = function(player, other)
  if not other.active then
    return nil;
  end

  if other.type == "bullet" or other.type == "bullet-pickup" or other.type == "pickup-health" then
    return "cross";
  end

  return nil;
end

pickupBoxCollision = function(pickupBox, other)
  if not other.active then
    return nil;
  end

  if other.type == "bullet-pickup" then
    return "cross";
  end

  return nil;
end

bulletCollision = function(bullet, other)
  if not other.active then
    return nil;
  end

  if other.type == "enemy" then
    return "cross";
  end

  return nil;
end

enemyCollision = function(enemy, other)
  if not other.active then
    return nil;
  end

  if other.type == "bullet-pickup" then
    return "cross";
  end

  return nil;
end

healthCollision = function(health, other)
  if not other.active then
    return nil;
  end

  if other.type == "player" then
    return "cross";
  end

  return nil;
end

bossCollision = function(health, other)
  if not other.active then
    return nil;
  end

  if other.type == "bullet-pickup" then
    return "cross";
  end

  return nil;
end