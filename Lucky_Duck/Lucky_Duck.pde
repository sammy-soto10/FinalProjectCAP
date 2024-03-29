// Lucky Duck Code
import java.util.Iterator;
import processing.sound.*;

PImage menuImg;
PImage pondImg;
PImage duckImg;
PImage coinImg;
PImage leprechaunImg;

SoundFile bg;
SoundFile coinSound;

int MENU_STATE = 0;
int GAME_STATE = 1;
int currentState = MENU_STATE;

int gridSize = 35; 
int cols, rows;
void drawGrid() {
  strokeWeight(1);
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
  float duckX, duckY;
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

class Leprechaun {
  float leprechaunX, leprechaunY;
  float leprechaunSpeed;
  float leprechaunDirection;

  Leprechaun(float x, float y) {
    leprechaunX = x;
    leprechaunY = y;
    leprechaunSpeed = 3;
    leprechaunDirection = random(TWO_PI);
  }

  void drawLeprechaun() {
    image(leprechaunImg, leprechaunX + gridSize * 0.12, leprechaunY + gridSize * 0.12, gridSize * 0.8, gridSize * 0.8 * 7/4);
  }

  void moveLeprechaun() {
    // move leprechaun in a random direction
    leprechaunX += cos(leprechaunDirection) * leprechaunSpeed;
    leprechaunY += sin(leprechaunDirection) * leprechaunSpeed;

    if (collidesWithAnyBoundary(leprechaunX, leprechaunY)) {
      for (int i = 0; i < 100; i++) {
        leprechaunDirection = random(TWO_PI);
        if (!collidesWithAnyBoundary(leprechaunX + cos(leprechaunDirection) * leprechaunSpeed * 2, leprechaunY + sin(leprechaunDirection) * leprechaunSpeed * 2)) {
          break;
        }
      }
    }
   
    
    if (leprechaunX < 0 || leprechaunX > width || leprechaunY < 0 || leprechaunY > height) {
      for (int i = 0; i < 100; i++) {
        leprechaunDirection = random(TWO_PI);
        if (!collidesWithAnyBoundary(leprechaunX + cos(leprechaunDirection) * leprechaunSpeed * 2, leprechaunY + sin(leprechaunDirection) * leprechaunSpeed * 2)) {
          break;
        }
      }
    }
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
    if (x + gridSize * 0.8 > b.xpos && x < b.xpos + b.w &&
      y + gridSize * 0.8 > b.ypos && y < b.ypos + b.h) {
      return true;
    }
    return false;
  }

  float getX() {
    return leprechaunX;
  }

  float getY() {
    return leprechaunY;
  }
}



Duck playerDuck;
ArrayList<Boundary> boundaries;
ArrayList<Coin> coins;
Coin test;
ArrayList<Leprechaun> leprechauns;
Leprechaun testL;

void setup() {
  size(700, 700);
  cols = width / gridSize;
  rows = height / gridSize;
  menuImg = loadImage("Menu.png");
  pondImg = loadImage("Pond.png");
  duckImg = loadImage("Duck.png");
  coinImg = loadImage("coin.png");
  leprechaunImg = loadImage("leprechaun.png");
  coinSound = new SoundFile(this, "coinCollect.mp3");
  bg = new SoundFile(this, "backgroundmusic.mp3");
  
  bg.loop();

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
    coins.add(new Coin(random(1, cols-1) * gridSize, random(1, rows-1) * gridSize));
  }
  
  leprechauns = new ArrayList<Leprechaun>();
  for (int i = 0; i < 3; i++) {
    leprechauns.add(new Leprechaun(random(1, cols - 1) * gridSize, random(1, rows - 1) * gridSize));
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
  strokeWeight(3);
  stroke(0);
  fill(#FFE300);
  rect(75, 450, 150, 50, 20);
  

  fill(0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("EASY", 150, 475);
  
  // Draw the start button
  strokeWeight(3);
  stroke(0);
  fill(#FFE300);
  rect(75, 550, 150, 50, 20);
  

  fill(0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("HARD", 150, 575);
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
      coinSound.play();
      println("Coin collected");
    } else {
      coin.drawCoin();
    }
  }
  
  for (Leprechaun leprechaun : leprechauns) {
    leprechaun.drawLeprechaun();
    leprechaun.moveLeprechaun();

    if (dist(playerDuck.getX() * gridSize, playerDuck.getY() * gridSize, leprechaun.getX(), leprechaun.getY()) < gridSize * 0.8) {
      println("Player loses!");
    }
  }
}

void mousePressed() {
  // Check if the mouse click is inside the start button
  if (currentState == MENU_STATE && mouseX > 75 && mouseX < 75 + 150 &&
      mouseY > 450 && mouseY < 450 + 50) {
    currentState = GAME_STATE; // Switch to game state
  }
  
  if (currentState == MENU_STATE && mouseX > 75 && mouseX < 75 + 150 &&
      mouseY > 550 && mouseY < 550 + 50) {
    currentState = GAME_STATE; // Switch to game state
  }
}
