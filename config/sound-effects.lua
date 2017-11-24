SFX_BOMB_EXPLODE = love.audio.newSource("asset/sound/bomb-explode.wav", "static");
SFX_BOSS_DEATH = love.audio.newSource("asset/sound/boss-death.wav", "static");
SFX_BULLET_IMPACT = love.audio.newSource("asset/sound/bullet-impact.wav", "static");
SFX_ENEMY_DEATH = love.audio.newSource("asset/sound/enemy-death.wav", "static");
SFX_HEALTH_PICKUP = love.audio.newSource("asset/sound/health-pickup.wav", "static");
SFX_PLAYER_DEATH = love.audio.newSource("asset/sound/player-death.wav", "static");
SFX_BULLET_PICKUP = love.audio.newSource("asset/sound/player-pickup.wav", "static");
SFX_PLAYER_SHIELD = love.audio.newSource("asset/sound/player-shield.wav", "static");
SFX_SHOOT = love.audio.newSource("asset/sound/player-shoot.wav", "static");

if PLAY_SOUNDS then
  love.audio.play(SFX_SHOOT);
end