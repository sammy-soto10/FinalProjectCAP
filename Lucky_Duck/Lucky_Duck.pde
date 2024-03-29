// Lucky Duck Code
import java.util.Iterator;

PImage menuImg;
PImage pondImg;
PImage duckImg;
PImage coinImg;

int gridSize = 35; // Size of each grid cell
int cols, rows; // Number of columns and rows in the grid

int MENU_STATE = 0;
int GAME_STATE = 1;
int currentState = MENU_STATE;

void drawGrid() {
  stroke(100, 100, 100, 20);
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      noFill();
      rect(i * gridSize, j * gridSize, gridSize, gridSize);
    }
  }
}

class Boundary {
  int xpos;
  int ypos;
  int w;
  int h;

  Boundary(int xpos, int ypos, int w, int h) {
    this.xpos = xpos;
    this.ypos = ypos;
    this.w = w;
    this.h = h;
  }

  void drawBoundary() {
    noStroke();
    fill(164, 192, 57);
    rect(xpos, ypos, w, h);
  }
}


class Duck {
  float duckX, duckY; // Ducks's position
  float duckDirection; // Duck's direction (0: right, 1: down, 2: left, 3: up)
  float duckSpeed;

  Duck() {
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
    } else if (keyCode == DOWN) {
      duckDirection = 1;
    } else if (keyCode == LEFT) {
      duckDirection = 2;
    } else if (keyCode == RIGHT) {
      duckDirection = 0;
    }

    // Move the duck in the current direction
    //if (withinWindow(nextX, nextY)) {
    if (duckDirection == 0) {
      nextX += duckSpeed;
    } else if (duckDirection == 1) {
      nextY += duckSpeed;
    } else if (duckDirection == 2) {
      nextX -= duckSpeed;
    } else if (duckDirection == 3) {
      nextY -= duckSpeed;
    }

    if (!collidesWithAnyBoundary(nextX, nextY)) {
      duckX = nextX;
      duckY = nextY;
    }

    if (duckX <0) {
      duckX = cols-1;
    } else if (duckX > cols-1) {
      duckX =0;
    }
    //}
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

  float getX() {
    return duckX;
  }

  float getY() {
    return duckY;
  }
}

class Coin {
  float coinX, coinY;

  Coin(float x, float y) {
    coinX = x;
    coinY = y;
  }

  void drawCoin() {
    image(coinImg, coinX  + gridSize * 0.12, coinY + gridSize * 0.12, gridSize *.8, gridSize *.8);
  }

  float getX() {
    return coinX;
  }

  float getY() {
    return coinY;
  }
}


Duck playerDuck;
ArrayList<Boundary> boundaries;
ArrayList<Coin> coins;
Coin test;

void setup() {
  size(700, 700);
  cols = width / gridSize;
  rows = height / gridSize;
  menuImg = loadImage("Menu.png");
  pondImg = loadImage("Pond.png");
  duckImg = loadImage("Duck.png");
  coinImg = loadImage("coin.png");
 
  background(pondImg);
  playerDuck = new Duck();
  boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(0, 0, width, gridSize));
  boundaries.add(new Boundary(0, 700-35, width, gridSize));
  boundaries.add(new Boundary(0, 0, 35, height/2-15));
  boundaries.add(new Boundary(0, height/2+50, gridSize, height));
  boundaries.add(new Boundary(width-gridSize, 0, gridSize, height/2-15));
  boundaries.add(new Boundary(width-gridSize, height/2+50, gridSize, height));
  boundaries.add(new Boundary(width/2-gridSize/2, 0, gridSize, 4*gridSize));
  boundaries.add(new Boundary(width/2-gridSize/2, height - 4*gridSize, gridSize, height));

  test = new Coin(350, 350);
  coins = new ArrayList<Coin>();
  for (int i = 20; i> 0; i--) {
    coins.add(new Coin(random(1, cols) * gridSize, random(1, rows) * gridSize));
  }
}

void draw() {
  if(currentState == MENU_STATE){
    drawMenu();
  }else if(currentState == GAME_STATE){
    drawGame();
  }
}
void drawMenu(){
  background(menuImg);
  
  // Draw the start button
  rectMode(CENTER);
  stroke(255);
  fill(#FFD800);
  rect(150, 500, 150, 50, 20);
  

  fill(255);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("START", 150, 500);
}

void drawGame(){
  background(pondImg);
  drawGrid();
  playerDuck.drawDuck();
  playerDuck.moveDuck();
  
  for (Boundary boundary : boundaries) {
    boundary.drawBoundary();
  }

  Iterator<Coin> it = coins.iterator();
  while (it.hasNext()) {
    Coin coin = it.next();
    if (dist(playerDuck.getX() * gridSize, playerDuck.getY()* gridSize , coin.getX()  , coin.getY()  ) < gridSize*0.75){
      it.remove();
      println("Coin collected");
    } else {
      coin.drawCoin();
    }
    
    
  }
}
void mousePressed() {
  // Check if the mouse click is inside the start button
  if (currentState == MENU_STATE && mouseX > 150 - 150/2 && mouseX < 150 + 150/2 &&
      mouseY > 500 - 50/2 && mouseY < 500 + 50/2) {
    currentState = GAME_STATE; // Switch to game state
  }
}
