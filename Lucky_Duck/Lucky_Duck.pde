// Lucky Duck Code
PImage pondImg;
PImage duckImg;

int gridSize = 35; // Size of each grid cell
int cols, rows; // Number of columns and rows in the grid

void drawGrid() {
  stroke(100, 100, 100, 20);
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      noFill();
      rect(i * gridSize, j * gridSize, gridSize, gridSize);
    }
  }
}

class Boundary{
  int xpos;
  int ypos;
  int w;
  int h;
  
  Boundary(int xpos, int ypos, int w, int h){
    this.xpos = xpos;
    this.ypos = ypos;
    this.w = w;
    this.h = h;
  }
  
  void drawBoundary(){
    noStroke();
    fill(164, 192, 57);
    rect(xpos, ypos, w, h);
  }
}
  

class Duck{
  float duckX, duckY; // Ducks's position
  float duckDirection; // Duck's direction (0: right, 1: down, 2: left, 3: up)
  float duckSpeed;

  Duck(){
    duckX = cols / 2;
    duckY = rows / 2;
    duckDirection = 0;
    duckSpeed = 0.05;
  }
  
  void drawDuck() {
    image(duckImg, duckX * gridSize, duckY * gridSize, gridSize, gridSize);
  }
  
  void moveDuck() {
    float nextX = duckX;
    float nextY = duckY;
    if (keyCode == UP) {
      duckDirection = 3;
    } 
    else if (keyCode == DOWN) {
      duckDirection = 1;
    } 
    else if (keyCode == LEFT) {
      duckDirection = 2;
    } 
    else if (keyCode == RIGHT) {
      duckDirection = 0;
    }

    // Move the duck in the current direction
    if (withinWindow(nextX, nextY)) {
      if (duckDirection == 0) {
        nextX += duckSpeed;
      } 
      else if (duckDirection == 1) {
        nextY += duckSpeed;
      } 
      else if (duckDirection == 2) {
        nextX -= duckSpeed;
      } 
      else if (duckDirection == 3) {
        nextY -= duckSpeed;
      }
      
      if (!collidesWithAnyBoundary(nextX, nextY)) {
        duckX = nextX;
        duckY = nextY;
      }
    }
  }
  
  boolean withinWindow(float x, float y) {
    return (x >= 0 && x < cols-1 && y >= 0 && y < rows-1);
  }
  
  boolean collidesWithAnyBoundary(float x, float y) {
    for (Boundary boundary : boundaries) {
      if (collidesWithBoundary(boundary, x, y)) {
        return true;
      }
    }
    return false;
  }
  
  boolean collidesWithBoundary(Boundary b, float x, float y) {
    // check for collision with each boundary
    if (x * gridSize + gridSize > b.xpos && x * gridSize < b.xpos + b.w &&
        y * gridSize + gridSize > b.ypos && y * gridSize < b.ypos + b.h) {
      return true;
    }
    return false; 
  }
}

Duck playerDuck;
ArrayList<Boundary> boundaries;

void setup(){
  size(700, 700);
  cols = width / gridSize;
  rows = height / gridSize;
  pondImg = loadImage("Pond.png");
  duckImg = loadImage("Duck.png");
  background(pondImg);
  playerDuck = new Duck();
  boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(200,200,10,100));
  boundaries.add(new Boundary(0,0,width,gridSize));
  boundaries.add(new Boundary(0,700-35,width,gridSize));
  boundaries.add(new Boundary(0,0,35,height/2-15));
  boundaries.add(new Boundary(0,height/2+50,gridSize,height));
  boundaries.add(new Boundary(width-gridSize,0,gridSize,height/2-15));
  boundaries.add(new Boundary(width-gridSize,height/2+50,gridSize,height));
}

void draw(){
  background(pondImg);
  drawGrid();
  playerDuck.drawDuck();
  playerDuck.moveDuck();
  for (Boundary boundary : boundaries) {
    boundary.drawBoundary();
  }
}
