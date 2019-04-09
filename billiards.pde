int m = 400;
int n = 400;
int r = 10;
int speedFactor = 0;
float permInitX, permInitY, initX, initY, longX, longY, x, y;
float vX, vY, longvX, longvY;
ArrayList<Float[]> lineValues;
int count;
boolean firstPath, pacman, drawTriangle, drawInitialPoint;

void setup(){
  frameRate(120);
  background(255);
  size(1200, 800);
  
  // Initialize Paramaters
  initX = x = permInitX = longX = m/3;
  initY = y = longY = permInitY = height-n/2;
  vX = longvX = (100.0/100);
  vY = longvY = (100.0/100);
  
  // Initialize the line arraylist, and add a line for the continuing line in index 0
  lineValues = new ArrayList<Float[]>();
  Float[] temp = {longX, longY, longX, longY};
  lineValues.add(temp);
  speedFactor = 10;
  
  pacman = false;
  drawTriangle = false;
  drawInitialPoint = true;
}


void draw(){
  
  background(244,251,211);
  
  createGrid();
  drawLines();
  
  //uncomment for flashy ball
  //fill((int) (255 * random(1)),(int) (255 * random(1)),(int)(255 * random(1)));
  
  
  //draw a black circle at the initial position with (x0, y0) text
  if (drawInitialPoint) {
    fill(0);
    ellipse(permInitX,permInitY,r,r);
    String startingPointString = "(x\u2080, y\u2080)";
    textSize(25*((m/400.0) + (n/400.0))/2);
    text(startingPointString, permInitX + 10*(m/400.0), permInitY + 30*(n/400.0));
  }
  
  int w = (int) longvX;
  int h = (int) longvY;
  
  
  //draw right triangle between starting point square w,h (width/height)
  if (drawTriangle) {
    noFill();
    line(permInitX, permInitY, permInitX + m*(w), permInitY);
    rect(permInitX + m*(w), permInitY, -30, -30);
    line(permInitX + m*(w), permInitY, permInitX + m*(w), permInitY - (h)*n);
    // draw an angle
    arc(permInitX, permInitY, 6*r, 6*r, -atan(longvY/longvX), 0);
    text("θ", permInitX + 70*(m/400.0), permInitY -10*(n/400.0));
  }
  
  //draw an ellipse of starting point in square w,h (width/height) and label it
  fill(0,255,0);
  strokeWeight(1);
  ellipse(permInitX + (w)*m, permInitY - (h)*n, r, r);
  String intersectionPointString;
  if (w != 1 && h != 1)
    intersectionPointString = "(x\u2080 +" + str(w) + "m, y\u2080 +" + str(h) + "n)";
  else if(w != 1)
    intersectionPointString = "(x\u2080 +" + str(w) + "m, y\u2080 + n)";
  else
    intersectionPointString = "(x\u2080 + m), y\u2080 +" + str(h) + "n)";
    
  fill(0);
  text(intersectionPointString, permInitX + 20*(m/400.0) + (w)*m, permInitY + 20*(n/400.0) - (h)*n);
  
  fill(255,133,85);
  
  //draw the ball
  strokeWeight(1);
  ellipse(x,y,r,r);
  for (int i = 0; i < speedFactor; i++){
    move();
    bounce();
  }
}

void move() {
  x += vX;
  y -= vY;
  longX += longvX;
  longY -= longvY;
}

void bounce() {
  boolean bounced = false;
  if (x <= 0 || x >= m) {
    if (pacman){
      if (x >= m) {
        x = 0;
      }
      else
        x = m;
    }
    else
      vX *= -1;
    
    bounced = true;
  }
  if (y <= height-n || y >= height) {
    if (pacman){
      if (y >= height) {
        y = height-n;
      }
      else
        y = height;
    }
    else
      vY *= -1;
    bounced = true;
  }
  trace(bounced);
}

void trace(boolean bounced) {
  Float[] coords = new Float[4];
  coords[0] = initX;
  coords[1] = initY;
  coords[2] = x;
  coords[3] = y;
  lineValues.get(0)[2] = longX;
  lineValues.get(0)[3] = longY;
  
  if (bounced) {
    initX = x;
    initY = y;
    coords[0] = initX;
    coords[1] = initY;
    lineValues.add(coords);
  }
  else
    lineValues.get(lineValues.size() - 1)[2] = x;
    lineValues.get(lineValues.size() - 1)[3] = y;
}

void drawLines() {
   stroke(0);
   strokeWeight(2);
   
   for (Float values[] : lineValues) {
    line(values[0], values[1], values[2], values[3]);
  }
}

void createGrid() {
   strokeWeight(2);
   for (int i = 0; i <= width; i+=m) {
     if ((i / m) % 2 == 0) {
       // left is red
       stroke(255,0,0);
     }
     else {
       // red is green
       stroke(0,255,0);
     }
     line(i,0,i,height);
   }  
   for (int i = height; i >= 0; i-=n) {
     if ((i / n) % 2 == 0) {
       // bottom is blue
       stroke(0,0,255);
     }
     else {
       // top is pink
       stroke(255,62,178);
     }
     line(0,i,width,i);
   }  
 
}
