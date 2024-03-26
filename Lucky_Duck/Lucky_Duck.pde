// Lucky Duck Code
PImage pondImg;
PImage duckImg;

int gridSize = 35; // Size of each grid cell
int cols, rows; // Number of columns and rows in the grid

void drawGrid() {
  stroke(100);
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      noFill();
      rect(i * gridSize, j * gridSize, gridSize, gridSize);
    }
  }
}

class Duck{
  int duckX, duckY; // Ducks's position
  int duckSpeed; // Duck's movement speed
  int duckDirection; // Duck's direction (0: right, 1: down, 2: left, 3: up)

  Duck(){
    duckX = cols / 2;
    duckY = rows / 2;
    duckSpeed = 1;
    duckDirection = 0;
  }
  
  void drawDuck() {
    image(duckImg, duckX * gridSize, duckY * gridSize, gridSize, gridSize);
  }
  
  void moveDuck() {
    int nextX = duckX;
    int nextY = duckY;
    if (keyCode == UP) {
      nextY -= 1;
      duckDirection = 3;
    } 
    else if (keyCode == DOWN) {
      nextY += 1;
      duckDirection = 1;
    } 
    else if (keyCode == LEFT) {
      nextX -= 1;
      duckDirection = 2;
    } 
    else if (keyCode == RIGHT) {
      nextX += 1;
      duckDirection = 0;
    }
    if (isValidMove(nextX, nextY)) {
      duckX = nextX;
      duckY = nextY;
    }
  }
  
  boolean isValidMove(int x, int y) {
    return (x >= 0 && x < cols && y >= 0 && y < rows);
  }
}
Duck playerDuck;

void setup(){
  size(700, 700);
  cols = width / gridSize;
  rows = height / gridSize;
  pondImg = loadImage("Pond.png");
  duckImg = loadImage("Duck.png");
  background(pondImg);
  playerDuck = new Duck();
}

void draw(){
  background(pondImg);
  drawGrid();
  playerDuck.drawDuck();
  if (keyPressed) {
    playerDuck.moveDuck();
  }
}
