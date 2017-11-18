SCREEN_WIDTH = 600;
SCREEN_HEIGHT = 800;

KEY_LEFT = "left";
KEY_RIGHT = "right";
KEY_UP = "up";
KEY_DOWN = "down";
KEY_RUN = "lshift";
KEY_QUIT = "escape";

KEY_FIRE_STREAM = "z";
KEY_FIRE_SPREAD = "x";
KEY_FIRE_BOMB = "c";
KEY_FIRE_FORCEFIELD = "v";

BACKGROUND_SPEED = 100;

UNIVERSAL_SCALE = 0.6;

PLAYER_SCALE = UNIVERSAL_SCALE;
PLAYER_WIDTH = 99 * PLAYER_SCALE;
PLAYER_HEIGHT = 75 * PLAYER_SCALE;
PICKUP_BOX_WIDTH = PLAYER_WIDTH * 2;
PICKUP_BOX_HEIGHT = PLAYER_HEIGHT * 2;
PLAYER_SPEED = 300;
PLAYER_RUN_SPEED = 300;
PLAYER_MAX_HEALTH = 5;
PLAYER_INITIAL_DIMENSIONS = {
  x = 270,
  y = 700,
  w = PLAYER_WIDTH,
  h = PLAYER_HEIGHT
};

PICKUP_BOX_INITIAL_DIMENSIONS = {
  x = PLAYER_INITIAL_DIMENSIONS.x + PLAYER_WIDTH / 2 - PICKUP_BOX_WIDTH / 2,
  y = PLAYER_INITIAL_DIMENSIONS.y + PLAYER_HEIGHT / 2 - PICKUP_BOX_HEIGHT / 2,
  w = PICKUP_BOX_WIDTH,
  h = PICKUP_BOX_HEIGHT
};

MAX_HELD_BULLETS = 9;
BULLET_SCALE = UNIVERSAL_SCALE;
BULLET_WIDTH = 7 * BULLET_SCALE;
BULLET_HEIGHT = 19 * BULLET_SCALE;
BULLET_SPEED = 400;
BULLET_INITIAL_DIMENSIONS = {
  w = BULLET_WIDTH * 2,
  h = BULLET_HEIGHT * 2
};

BULLET_SPREAD = {
  math.pi * 24/16,
  math.pi * 23/16,
  math.pi * 25/16,
  math.pi * 22/16,
  math.pi * 26/16,
  math.pi * 21/16,
  math.pi * 27/16,
  math.pi * 20/16,
  math.pi * 28/16
};

ENEMY_SIZE = 32;
ENEMY_SCALE = UNIVERSAL_SCALE;

STRAIGHT_ENEMY_FIRE_RATE = 0.4;
STRAIGHT_ENEMY_SPEED = 100;
STRAIGHT_ENEMY_INITIAL_DIMENSIONS = {
  w = 82 * ENEMY_SCALE,
  h = 84 * ENEMY_SCALE
};

SIDEWAYS_ENEMY_FIRE_RATE = 0.4;
SIDEWAYS_ENEMY_SPEED = 150;
SIDEWAYS_ENEMY_INITIAL_DIMENSIONS = {
  w = 103 * ENEMY_SCALE,
  h = 84 * ENEMY_SCALE
};

PENDULUM_ENEMY_SPEED = 100;
PENDULUM_ENEMY_LEFT_LIMIT = 0;
PENDULUM_ENEMY_RIGHT_LIMIT = SCREEN_WIDTH - 93 * ENEMY_SCALE;
PENDULUM_ENEMY_MOVEMENT_RATE = 1.5;
PENDULUM_ENEMY_INITIAL_DIMENSIONS = {
  w = 93 * ENEMY_SCALE,
  h = 84 * ENEMY_SCALE
};

-- Debug Variables
DRAW_POSITIONS = false;
DRAW_BOXES = false;
DRAW_COUNTS = false;
KILL_PLAYER = false;
PLAY_MUSIC = false;
PLAY_SOUNDS = false;