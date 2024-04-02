// Andrea Contreras, Pablo Moreno, Sam Soto

import java.util.Iterator;
import processing.sound.*;

// Global variables
PImage menuImg;
PImage pondImg;
PImage duckImg;
PImage coinImg;
PImage leprechaunImg;
PImage Won;
PImage Lose;

SoundFile bg;
SoundFile coinSound;

int MENU_STATE = 0;
int GAME_STATE_EASY= 1;
int GAME_STATE_HARD= 2;
int WIN_STATE = 3;
int LOSE_STATE = 4;
int currentState = MENU_STATE;

int gridSize = 35; 
int cols, rows;

// Function to draw grid lines
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

// Class representing a boundary
class Boundary {
  int xpos;
  int ypos;
  int w;
  int h;

  // Constructor
  Boundary(int xpos, int ypos, int w, int h) {
    this.xpos = xpos;
    this.ypos = ypos;
    this.w = w;
    this.h = h;
  }

  // Function to draw the boundary
  void drawBoundary() {
    noStroke();
    fill(164, 192, 57);
    rect(xpos, ypos, w, h);
  }
}
  
// Class representing the player's duck
class Duck {
  float duckX, duckY;
  float duckDirection; // Duck's direction (0: right, 1: down, 2: left, 3: up)
  float duckSpeed;

  // Constructor
  Duck() {
    duckX = cols / 2;
    duckY = rows / 2;
    duckDirection = 0;
    duckSpeed = 0.05;
  }

  // Function to draw the duck
  void drawDuck() {
    image(duckImg, duckX * gridSize, duckY * gridSize, gridSize, gridSize);
  }
  
  // Function to check if duck is within the window
  boolean withinWindow(float x, float y) {
    return (x >= 0 && x < cols-1 && y >= 0 && y < rows-1);
  }
  
  // Function to check if duck collides with any boundary
  boolean collidesWithAnyBoundary(float x, float y) {
    for (Boundary boundary : boundaries) {
      if (collidesWithBoundary(boundary, x, y)) {
        return true;
      }
    }
    return false;
  }
  
  // Function to check if duck collides with a specific boundary
  boolean collidesWithBoundary(Boundary b, float x, float y) {
    if (x * gridSize + gridSize > b.xpos && x * gridSize < b.xpos + b.w &&
      y * gridSize + gridSize > b.ypos && y * gridSize < b.ypos + b.h) {
      return true;
    }
    return false;
  }

  // Function to move the duck based on user input
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

    // Check for collisions with boundaries before moving
    if (!collidesWithAnyBoundary(nextX, nextY)) {
      duckX = nextX;
      duckY = nextY;
    }

    // Wrap around the screen if duck moves beyond boundaries
    if (duckX < 0) {
      duckX = cols - 1;
    } 
    else if (duckX > cols - 1) {
      duckX = 0;
    }
  }

  // Function to get duck's X coordinate
  float getX() {
    return duckX;
  }

  // Function to get duck's Y coordinate
  float getY() {
    return duckY;
  }
}

// Class representing a coin
class Coin {
  float coinX, coinY;

  // Constructor
  Coin(float x, float y) {
    coinX = x;
    coinY = y;
  }

  // Function to draw the coin
  void drawCoin() {
    image(coinImg, coinX + gridSize * 0.12, coinY + gridSize * 0.12, gridSize * 0.8, gridSize * 0.8);
  }

  // Function to get coin's X coordinate
  float getX() {
    return coinX;
  }

  // Function to get coin's Y coordinate
  float getY() {
    return coinY;
  }
}

// Class representing a leprechaun
class Leprechaun {
  float leprechaunX, leprechaunY;
  float leprechaunSpeed;
  float leprechaunDirection;

  // Constructor
  Leprechaun(float x, float y, float speed) {
    leprechaunX = x;
    leprechaunY = y;
    leprechaunSpeed = speed;
    leprechaunDirection = random(TWO_PI);
  }

  // Function to draw the leprechaun
  void drawLeprechaun() {
    image(leprechaunImg, leprechaunX + gridSize * 0.12, leprechaunY + gridSize * 0.12, gridSize * 0.8, gridSize * 0.8 * 7/4);
  }

  // Function to move the leprechaun
  void moveLeprechaun() {
    // Move leprechaun in a random direction
    leprechaunX += cos(leprechaunDirection) * leprechaunSpeed;
    leprechaunY += sin(leprechaunDirection) * leprechaunSpeed;

    // Check for collisions with boundaries and adjust direction if necessary
    if (collidesWithAnyBoundary(leprechaunX, leprechaunY)) {
      for (int i = 0; i < 100; i++) {
        leprechaunDirection = random(TWO_PI);
        if (!collidesWithAnyBoundary(leprechaunX + cos(leprechaunDirection) * leprechaunSpeed * 2, leprechaunY + sin(leprechaunDirection) * leprechaunSpeed * 2)) {
          break;
        }
      }
    }
   
    // Check for collisions with edge of window and adjust direction if necessary
    if (leprechaunX < 0 || leprechaunX > width || leprechaunY < 0 || leprechaunY > height) {
      for (int i = 0; i < 100; i++) {
        leprechaunDirection = random(TWO_PI);
        if (!collidesWithAnyBoundary(leprechaunX + cos(leprechaunDirection) * leprechaunSpeed * 2, leprechaunY + sin(leprechaunDirection) * leprechaunSpeed * 2)) {
          break;
        }
      }
    }
  }

  // Function to check if leprechaun collides with any boundary
  boolean collidesWithAnyBoundary(float x, float y) {
    for (Boundary boundary : boundaries) {
      if (collidesWithBoundary(boundary, x, y)) {
        return true;
      }
    }
    return false;
  }

  // Function to check if leprechaun collides with a specific boundary
  boolean collidesWithBoundary(Boundary b, float x, float y) {
    if (x + gridSize * 0.8 > b.xpos && x < b.xpos + b.w &&
      y + gridSize * 0.8 * 7/4 > b.ypos && y < b.ypos + b.h) {
      return true;
    }
    return false;
  }

  // Function to get leprechaun's X coordinate
  float getX() {
    return leprechaunX;
  }

  // Function to get leprechaun's Y coordinate
  float getY() {
    return leprechaunY;
  }
}

// Initializing objects and setting up the canvas
Duck playerDuck;
ArrayList<Boundary> boundaries;
ArrayList<Coin> coins;
Coin test;
ArrayList<Leprechaun> leprechauns;
Leprechaun testL;

int coinSize;

void setup() {
  size(700, 700);
  
  cols = width / gridSize;
  rows = height / gridSize;
  
  // Loading sound and image files
  menuImg = loadImage("Menu.png");
  pondImg = loadImage("Pond.png");
  duckImg = loadImage("Duck.png");
  coinImg = loadImage("coin.png");
  leprechaunImg = loadImage("leprechaun.png");
  Won = loadImage("Won.png");
  Lose = loadImage("Lose.png");
  coinSound = new SoundFile(this, "coinCollect.mp3");
  bg = new SoundFile(this, "backgroundmusic.mp3");
  
  bg.loop();

  // Creating new duck and boundary objects
  background(pondImg);
  playerDuck = new Duck();
  boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(0, 0, width, gridSize));
  boundaries.add(new Boundary(0, 700-35, width, gridSize));
  boundaries.add(new Boundary(0, 0, 35, height/2-15));
  boundaries.add(new Boundary(0, height/2+50, gridSize, height));
  boundaries.add(new Boundary(width-gridSize, 0, gridSize, height/2-15));
  boundaries.add(new Boundary(width-gridSize, height/2+50, gridSize, height));
  //boundaries.add(new Boundary(width/2-gridSize/2, 0, gridSize, 4*gridSize));
  //boundaries.add(new Boundary(width/2-gridSize/2, height - 4*gridSize, gridSize, height));

  // Creating new coin objects
  coins = new ArrayList<Coin>();
  
  // Creating new leprechaun objects
  leprechauns = new ArrayList<Leprechaun>();
}

// Main drawing loop
void draw() {
  if(currentState == MENU_STATE){
    drawMenu();
  }
  else if(currentState == GAME_STATE_EASY){
    drawGame();
  }
  else if(currentState == GAME_STATE_HARD){
    drawGame();
  }
  else if(currentState == WIN_STATE){
    drawWinScreen();
  }
  else if(currentState == LOSE_STATE){
    drawLoseScreen();
  }
}

// Function to draw the menu screen
void drawMenu(){
  background(menuImg);
  
  // Draw the easy mode button
  strokeWeight(3);
  stroke(0);
  fill(#FFE300);
  rect(75, 450, 150, 50, 20);
  fill(0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("EASY", 150, 475);
  
  // Draw the hard mode button
  strokeWeight(3);
  stroke(0);
  fill(#FFE300);
  rect(75, 550, 150, 50, 20);
  fill(0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("HARD", 150, 575);
}

// Function to draw the game screen
void drawGame(){
  background(pondImg);
  drawGrid();
  playerDuck.drawDuck();
  playerDuck.moveDuck();

  // Draw boundaries
  for (Boundary boundary : boundaries) {
    boundary.drawBoundary();
  }

  // Iterate through coins and check for collision with player duck
  Iterator<Coin> it = coins.iterator();
  while (it.hasNext()) {
    Coin coin = it.next();
    if (dist(playerDuck.getX() * gridSize, playerDuck.getY() * gridSize, coin.getX(), coin.getY()) < gridSize * 0.75) {
      it.remove(); // Remove collected coins
      coinSound.play(); // Play coin collect sound
      println("Coin collected"); // Print message to console
    } else {
      coin.drawCoin(); // Draw coins that are not collected
    }
  }
  
  //check if won
  if(coins.size() == 0){
    println("Player wins!");
    currentState = WIN_STATE;
  }
  
  // Iterate through leprechauns, draw them, and move them
  for (Leprechaun leprechaun : leprechauns) {
    leprechaun.drawLeprechaun();
    leprechaun.moveLeprechaun();

    // Check if player duck collides with leprechaun
    if (dist(playerDuck.getX() * gridSize, playerDuck.getY() * gridSize, leprechaun.getX(), leprechaun.getY()) < gridSize * 0.8) {
      println("Player loses!"); // Print message to console
      currentState = LOSE_STATE;
    }
  }
  
  //print coins
  fill(0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("Coins Remaining: " + coins.size(), 150, 680);
}

void drawWinScreen(){
  background(Won);
  
  // Draw the hard mode button
  strokeWeight(3);
  stroke(0);
  fill(#FFE300);
  rect(75, 550, 150, 50, 20);
  fill(0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("PLAY AGAIN", 150, 575);
}

void drawLoseScreen(){
  background(Lose);
  
  // Draw the hard mode button
  strokeWeight(3);
  stroke(0);
  fill(#FFE300);
  rect(75, 550, 150, 50, 20);
  fill(0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("PLAY AGAIN", 150, 575);
}

// Function to handle mouse clicks
void mousePressed() {
  // Check if the mouse click is inside the start buttons
  if (currentState == MENU_STATE && mouseX > 75 && mouseX < 75 + 150 &&
      mouseY > 450 && mouseY < 450 + 50) {
      currentState = GAME_STATE_EASY; // Switch to game state (easy mode)
    
    //make 20 coins
      coinSize = 20;
      for (int i = 0; i<coinSize; i++) {
        coins.add(new Coin( int(random(1,cols-2)) * gridSize , int(random(1,rows-2)) * gridSize ));
      }
      
      int leprechaunSize = 3;
      for (int i = 0; i < leprechaunSize; i++) {
        leprechauns.add(new Leprechaun(random(1, cols - 2) * gridSize, random(1, rows - 2) * gridSize, 3));
      }
  
  }
  
  if (currentState == MENU_STATE && mouseX > 75 && mouseX < 75 + 150 &&
      mouseY > 550 && mouseY < 550 + 50) {
      currentState = GAME_STATE_HARD; // Switch to game state (hard mode)
    
    //make 30 coins
      coinSize = 30;
      for (int i = 0; i<coinSize; i++) {
        coins.add(new Coin( int(random(1,cols-2)) * gridSize , int(random(1,rows-2)) * gridSize ));
      }
      
      int leprechaunSize = 4;
      for (int i = 0; i < leprechaunSize; i++) {
        leprechauns.add(new Leprechaun(random(1, cols - 2) * gridSize, random(1, rows - 2) * gridSize, 5));
      }
  }
  
  if (currentState == LOSE_STATE || currentState == WIN_STATE && mouseX > 75 && mouseX < 75 + 150 &&
      mouseY > 550 && mouseY < 550 + 50){
      currentState = MENU_STATE;
      resetGame();
  }
}

void resetGame() {
  // Reset duck position
  playerDuck = new Duck();

  // Clear coins
  coins.clear();

  // Reinitialize coins based on game mode
  if (currentState == GAME_STATE_EASY) {
    coinSize = 20;
    for (int i = 0; i < coinSize; i++) {
      coins.add(new Coin(int(random(1, cols - 2)) * gridSize, int(random(1, rows - 2)) * gridSize));
    }
  } 
  else if (currentState == GAME_STATE_HARD) {
    coinSize = 30;
    for (int i = 0; i < coinSize; i++) {
      coins.add(new Coin(int(random(1, cols - 2)) * gridSize, int(random(1, rows - 2)) * gridSize));
    }
  }

  // Clear leprechauns
  leprechauns.clear();

  // Reinitialize leprechauns based on game mode
  if (currentState == GAME_STATE_EASY) {
    int leprechaunSize = 3;
    for (int i = 0; i < leprechaunSize; i++) {
      leprechauns.add(new Leprechaun(random(1, cols - 2) * gridSize, random(1, rows - 2) * gridSize, 3));
    }
  } 
  else if (currentState == GAME_STATE_HARD) {
    int leprechaunSize = 4;
    for (int i = 0; i < leprechaunSize; i++) {
      leprechauns.add(new Leprechaun(random(1, cols - 2) * gridSize, random(1, rows - 2) * gridSize, 5));
    }
  }
}
