
// Scales down the displayed stuff.
// Adjust this until the sketch fits your screen resolution.
float displayScale = 2.0;

final float INNER_RADIUS = 230;
final float OUTER_RADIUS = 710;
final float RADIUS_RANGE = OUTER_RADIUS - INNER_RADIUS;

void setup()
{
  size(int((2 * OUTER_RADIUS + 360 * 2) * 1.3 / displayScale), int((2 * OUTER_RADIUS) * 1.2 / displayScale));
  
  background(0);
  smooth(2);
  
  drawTexts();
  
  drawRanges();
  
  stroke(color(200, 200, 255, 20));
  fill(color(200, 200, 255, 20));
  
  loadPixels();
  savedPixels = new color[pixels.length];
  arrayCopy(pixels, savedPixels);
}


int explosionCount = 0;

void draw()
{
  loadPixels();
  arrayCopy(savedPixels, pixels);
  updatePixels();
  
  stroke(color(200, 200, 255, 20));
  fill(color(200, 200, 255, 20));
  
  for (int i = 0; i < 400; i++)
  {
    float r = random(RADIUS_RANGE) + INNER_RADIUS;
    float theta = random(90) + 90 * (explosionCount % 4);
    
    
    float x = r * cos(theta);
    float y = r * sin(theta);
    
    resetMatrix();
    translate(height/2, height/2);
    scale(1 / displayScale);
    strokeWeight(2);
    point(x, -y); // Inverted y because of how screen coordinates work
    
    
    resetMatrix();
    translate(height + (width-height)/2, height/2);
    scale(2 / displayScale);
    translate(-360/2, OUTER_RADIUS/2);
    strokeWeight(1);
    point(theta, -r);
    
    explosionCount++;
  }
  
  loadPixels();
  arrayCopy(pixels, savedPixels);
  
  if (drawMouse)
  {
    resetMatrix();
    noStroke();
    fill(255, 20, 80);
    ellipse(height / 2 + xMouse/displayScale, height/2 - yMouse/displayScale, 7, 7);
    ellipse(height + (width-height)/2 + 2*(thetaMouse - 180)/displayScale,
            height/2 + 2*(-rMouse+OUTER_RADIUS/2)/displayScale, 7, 7);
  }
}

color[] savedPixels;

float xMouse, yMouse, rMouse, thetaMouse;
boolean drawMouse;

void mouseMoved()
{
  drawMouse = false;
  if (mouseX < height)
  {
    // In cartesian area
    xMouse = (mouseX - height/2) * displayScale;
    yMouse = -(mouseY - height/2) * displayScale;
    float r = sqrt(sq(xMouse) + sq(yMouse));
    if ((r < INNER_RADIUS) || (r > OUTER_RADIUS)) return;
    
    rMouse = r;
    thetaMouse = degrees(atan2(yMouse, xMouse));
    if (thetaMouse < 0) thetaMouse += 360;
    
    drawMouse = true;
  }
  else
  {
    // In polar area
    rMouse = (-(mouseY - height/2) * displayScale + OUTER_RADIUS) / 2;
    thetaMouse = ((mouseX - (height + (width-height)/2)) * displayScale / 2) + 180;
    
    if ((rMouse < INNER_RADIUS) || (rMouse > OUTER_RADIUS) ||
        (thetaMouse < 0) || (thetaMouse > 360)) return;
        
    xMouse = rMouse * cos(radians(thetaMouse));
    yMouse = rMouse * sin(radians(thetaMouse));
    
    drawMouse = true;
  }
}
void mouseDragged()
{
  mouseMoved();
}

void drawTexts()
{
  // Titles
  stroke(color(255));
  textSize(20);
  
  translate(height/2, 0.06 * height);
  String t = "Cartesian space";
  text(t, -textWidth(t)/2, 0);
  
  resetMatrix();
  translate(height + (width-height)/2, 0.083 * height);
  t = "Polar space";
  text(t, -textWidth(t)/2, -textDescent()-1.5);
  
  
  // Labels
  textSize(14);
  
  resetMatrix();
  translate(height + (width-height)/2, 0.917 * height);
  t = "theta";
  text(t, -textWidth(t)/2, textAscent());
  translate(-360 / displayScale, 0);
  t = "0";
  text(t, -textWidth(t) - 7, textAscent() + 1.5);
  translate(2 * 360 / displayScale, 0);
  t = "360";
  text(t, -textWidth(t)/2, textAscent() + 1.5);
  
  resetMatrix();
  
  translate(height + (width-height)/2 - 360/displayScale, height/2);
  t = "r";
  text(t, -textWidth(t) - 7, textAscent() - (textAscent() + textDescent())/2);
  pushMatrix();
  translate(0, -OUTER_RADIUS / displayScale);
  t = str(int(OUTER_RADIUS));
  text(t, -textWidth(t) - 7, textAscent() - (textAscent() + textDescent())/2);
  popMatrix();
  translate(0, (OUTER_RADIUS - 2 * INNER_RADIUS) / displayScale);
  t = str(int(INNER_RADIUS));
  text(t, -textWidth(t) - 7, textAscent() - (textAscent() + textDescent())/2);
  
}

void drawRanges()
{
  stroke(color(200, 200, 255));
  strokeWeight(1);
  noFill();
  
  resetMatrix();
  translate(height/2, height/2);
  scale(2 / displayScale);
  ellipse(0, 0, INNER_RADIUS, INNER_RADIUS);
  ellipse(0, 0, OUTER_RADIUS, OUTER_RADIUS);
  
  resetMatrix();
  translate(height + (width-height)/2, height/2);
  scale(2 / displayScale);
  rectMode(CENTER);
  rect(0, 0, 360, OUTER_RADIUS);
}
