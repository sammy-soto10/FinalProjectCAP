// Lucky Duck Code
PImage pondImg;
PImage duckImg;

void setup(){
  size(450, 253);
  pondImg = loadImage("Pond.jpg");
  duckImg = loadImage("Duck.png");
  background(pondImg);
}

void draw(){
  image(duckImg, width/2, height/2, 20, 20);
  
}
