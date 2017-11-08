SCREEN_WIDTH = 600;
SCREEN_HEIGHT = 800;

KEY_LEFT = "left";
KEY_RIGHT = "right";
KEY_UP = "up";
KEY_DOWN = "down";
KEY_RUN = "lshift";
KEY_QUIT = "escape";
KEY_PICKUP = "z";

PLAYER_WIDTH = 32;
PLAYER_HEIGHT = 32;
PLAYER_SPEED = 300;
PLAYER_RUN_SPEED = 300;
PLAYER_INITIAL_DIMENSIONS = {
  x = 200,
  y = 500,
  w = PLAYER_WIDTH,
  h = PLAYER_HEIGHT
};

BULLET_SIZE = 8;
BULLET_SPEED = 400;
BULLET_INITIAL_DIMENSIONS = {
  w = BULLET_SIZE * 2,
  h = BULLET_SIZE * 2
};

WALL_DEPTH = 32;

ENEMY_SIZE = 32;
ENEMY_LEFT_LIMIT = WALL_DEPTH + ENEMY_SIZE;
ENEMY_RIGHT_LIMIT = SCREEN_WIDTH - WALL_DEPTH - ENEMY_SIZE * 2;
ENEMY_MOVEMENT_RATE = 1.5;
ENEMY_INITIAL_DIMENSIONS = {
  w = ENEMY_SIZE,
  h = ENEMY_SIZE
};

-- Debug Variables
DRAW_POSITIONS = false;
DRAW_BOXES = false;