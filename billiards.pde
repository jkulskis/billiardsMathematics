int m = 20;
int n = 20;
int r = 20;
int speedFactor, strokeWeightValue;
float permInitX, permInitY, initX, initY, longX, longY, x, y;
float vX, vY, longvX, longvY;
ArrayList<Float[]> lineValues;
int count, clickedX, clickedY;
boolean firstPath, pacman, drawTriangle, drawInitialPoint, drawIntersectionPoint, pigeonhole, pathFinder, redPaths, blackPaths, middleLines, drawCenterLines, drawConnectLines;
int[] pathLengths = {2, 4,6,8,10,12,14,16,18};

void setup(){
  frameRate(120);
  background(255);
  size(900, 900);
  
  // Initialize Paramaters
  initX = x = permInitX = longX = m/3;
  initY = y = longY = permInitY = height-n/2;
  vX = longvX = (200.0/100);
  vY = longvY = (100.0/100);
  
  // Initialize the line arraylist, and add a line for the continuing line in index 0
  lineValues = new ArrayList<Float[]>();
  Float[] temp = {longX, longY, longX, longY};
  lineValues.add(temp);
  speedFactor = 1;
  
  pacman = true;
  drawTriangle = true;
  drawInitialPoint = true;
  drawIntersectionPoint = true;
  pigeonhole = false;
  
  drawCenterLines = true;
  drawConnectLines = true;
  pathFinder = true;
  blackPaths = true;
  redPaths = true;
  
  strokeWeightValue = 5;
}

void draw(){
  background(244,251,211);
  
  //uncomment for flashy ball
  //fill((int) (255 * random(1)),(int) (255 * random(1)),(int)(255 * random(1)));
  
  if (pigeonhole) {
    createGrid();
    split(5);
  }
  else if (pathFinder) {
    
    if (mousePressed) {
      if (mouseY >= height/2 - n/2 && mouseY <= height/2 + n/2 && mouseX <= width/2 + m/2 && mouseX >= width/2 - m/2){
        clickedX = mouseX;
        clickedY = mouseY; 
      }
      else if (mouseX <= width/2 + m/2 && mouseX >= width/2 - m/2) {
        clickedX = mouseX;
      }
      else if (mouseY >= height/2 - n/2 && mouseY <= height/2 + n/2) {
        clickedY = mouseY;
      }
    }
  
    createGrid();
    fill(0);
    stroke(0);
    
    if (clickedX == 0) {
      clickedX = width/2;
      clickedY = height/2;
    }
    
    int[] lastCoords = new int[4];
    strokeWeight(strokeWeightValue);
    for (int i = 0; i < pathLengths.length; i++) {
      for (int w = -pathLengths[i]; w <= pathLengths[i]; w++) {
        int h = pathLengths[i] - abs(w);
        if (abs(w) % 2 == 0 && blackPaths) {
          stroke(0);
          fill(0);
          if (w != -pathLengths[i] && drawConnectLines) {
           line(clickedX + m*w, clickedY + n*h, clickedX + m*(w-2), clickedY + n*(pathLengths[i] - abs(w-2))); 
           line(clickedX + m*w, clickedY - n*h, clickedX + m*(w-2), clickedY - n*(pathLengths[i] - abs(w-2))); 
          }
          ellipse(clickedX + m*w, clickedY + n*h, r, r);
          ellipse(clickedX + m*w, clickedY - n*h, r, r);
          if (drawCenterLines) {
            line(clickedX, clickedY, clickedX + m*w, clickedY + n*h);
            line(clickedX, clickedY, clickedX + m*w, clickedY - n*h);
          }
        }
        else if (abs(w) % 2 == 1 && redPaths){
          int flippedX = 0;
          int flippedY = 0;
          stroke(255, 0, 0);
          fill(255, 0, 0);
          if (w < 0) {
            flippedX = width - clickedX;
          }
          else {
            flippedX = width + m - clickedX;
          }
          if (h < 0) {
            flippedY = abs(height - clickedY);
          }
          else if (h != 0) {
            flippedY = abs(height + n - clickedY);
          }
          else {
            flippedY = clickedY;
          }
          if (w <= 0) {
            ellipse(flippedX + m*(w), flippedY - n*(h+1), r, r);
            ellipse(flippedX + m*(w), flippedY + n*(h-1), r, r);
            if (drawCenterLines) {
              line(clickedX, clickedY, flippedX + m*(w), flippedY - n*(h+1));
              line(clickedX, clickedY, flippedX + m*(w), flippedY + n*(h-1));
            }
          }
          else {
            ellipse(flippedX + m*(w-1), flippedY - n*(h+1), r, r);
            ellipse(flippedX + m*(w-1), flippedY + n*(h-1), r, r);
            if (drawCenterLines) {
              line(clickedX, clickedY, flippedX + m*(w-1), flippedY - n*(h+1));
              line(clickedX, clickedY, flippedX + m*(w-1), flippedY + n*(h-1));
            }
          }
          
          if (w != -pathLengths[i] + 1) {
            if (w <= 0 && drawConnectLines) {
              line(flippedX + m*(w), flippedY - n*(h+1), flippedX + m*(w-2), flippedY - n*(pathLengths[i] - abs(w-2) + 1)); 
              line(flippedX + m*(w), flippedY + n*(h-1), flippedX + m*(w-2), flippedY + n*(pathLengths[i] - abs(w-2) - 1)); 
            }
            else if (drawConnectLines) {
             line(flippedX + m*(w-1), flippedY - n*(h+1), flippedX + m*(w-3), flippedY - n*(pathLengths[i] - abs(w-2) + 1)); 
             line(flippedX + m*(w-1), flippedY + n*(h-1), flippedX + m*(w-3), flippedY + n*(pathLengths[i] - abs(w-2) - 1));
            }
           
          }
          if (abs(w) == pathLengths[i] - 1 && w > 0){
            if (drawConnectLines)
              line(flippedX + m*(w-1), flippedY - n*(h-1),flippedX + m*(w-1), flippedY - n*(h-1) - 2*n);
          }
          if (abs(w) == pathLengths[i] - 1 && w <= 0){
            if (drawConnectLines)
              line(flippedX + m*(w), flippedY - n*(h-1),flippedX + m*(w), flippedY - n*(h-1) - 2*n);
          }
        }

      }
    }
    // draw middle ellipse last so it is on top
    fill(0,0,255);
    strokeWeight(2);
    ellipse(clickedX, clickedY, r, r);
  }
  else {
    createGrid();
    drawLines();
    drawExtras();
    
    fill(255,133,85);
    
    //draw the ball
    strokeWeight(1);
    ellipse(x,y,r,r);
    for (int i = 0; i < speedFactor; i++){
      move();
      bounce();
    }
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

void split(int numDivides) {
  stroke(0);
  for (int i = 0; i <= numDivides; i++) {
     line(width/(pow(2, i)), height/(pow(2, i)), width/(pow(2, i)), 0);
     line(width/(pow(2, i))*2, height/(pow(2, i)), 0, height/(pow(2, i)));
     if (i == numDivides) {
      fill(239, 196, 239);
      rect(0, 0, width/(pow(2, i)), height/(pow(2, i)));
     }
  }
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
   strokeWeight(strokeWeightValue);
   
   for (Float values[] : lineValues) {
    line(values[0], values[1], values[2], values[3]);
  }
}

void createGrid() {
   strokeWeight(strokeWeightValue);
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

void drawExtras() {
  
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
  
  //draw an ellipse of starting point in a square w,h (width/height) away from the starting square and label the ellipse
  if (drawIntersectionPoint){
    fill(0,255,0);
    strokeWeight(1);
    ellipse(permInitX + (w)*m, permInitY - (h)*n, r, r);
    String intersectionPointString;
    if (w != 1 && h != 1)
      intersectionPointString = "(x\u2080 +" + str(w) + "m, y\u2080 +" + str(h) + "n)";
    else if(w != 1)
      intersectionPointString = "(x\u2080 +" + str(w) + "m, y\u2080 + n)";
    else if(h != 1)
      intersectionPointString = "(x\u2080 + m, y\u2080 +" + str(h) + "n)";
    else
      intersectionPointString = "(x\u2080 + m, y\u2080 + n)";
      
    fill(0);
    text(intersectionPointString, permInitX + 20*(m/400.0) + (w)*m, permInitY + 20*(n/400.0) - (h)*n);
  } 
  
}
