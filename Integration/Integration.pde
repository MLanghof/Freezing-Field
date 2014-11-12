
// Scales down the displayed stuff.
// Adjust this until the sketch fits your screen resolution.
float displayScale = 2;

final float INNER_RADIUS = 140;
final float OUTER_RADIUS = 710;
final float RADIUS_RANGE = OUTER_RADIUS - INNER_RADIUS;
final float EXPLOSION_AOE = 255;

// Integration step. Increase for faster but less precise calculations.
float dr = 10;


float midOffset = -(OUTER_RADIUS + EXPLOSION_AOE)/2;

void setup()
{
  size(int((OUTER_RADIUS + 3*EXPLOSION_AOE) * 1.2 / displayScale), int((4 * EXPLOSION_AOE) * 1.3 / displayScale));

  smooth(2);

  //drawTexts();

  //drawRanges();

  stroke(color(200, 200, 255, 20));
  fill(color(200, 200, 255, 20));

  probabilities = new float[ceil(OUTER_RADIUS + EXPLOSION_AOE) + 1];
}

int x = -1;
boolean automove = true;

float[] probabilities;

void draw()
{
  background(0, 8, 25);

  if (automove) x = (x + 1 > OUTER_RADIUS + EXPLOSION_AOE ? 0 : x+1);
  else x = int(constrain((mouseX - width/2)*displayScale - midOffset * 1.1, 0, OUTER_RADIUS + EXPLOSION_AOE));
  stroke(color(200, 200, 255, 20));
  //fill(color(200, 200, 255, 20));

  // Draw coordinate system
  stroke(#6F7CFF);
  noFill();

  resetMatrix();
  translate(width/2, 3*height/4);
  scale(1 / displayScale);
  translate(midOffset * 1.1, 0);

  strokeWeight(displayScale);
  line(-1.1 * (EXPLOSION_AOE), 0, 1.1 * (OUTER_RADIUS + 2 * EXPLOSION_AOE), 0);
  line(0, -EXPLOSION_AOE * 1.1, 0, EXPLOSION_AOE * 1.1);

  // Draw FF inner and outer boundary
  stroke(#2A39AF);
  strokeWeight(2 * displayScale);
  ellipse(0, 0, INNER_RADIUS*2, INNER_RADIUS*2);
  float tempAngle = asin(EXPLOSION_AOE * 1.1 / OUTER_RADIUS);
  arc(0, 0, OUTER_RADIUS*2, OUTER_RADIUS*2, -tempAngle, tempAngle);

  // Show the current radius in which explosions would hit you
  stroke(#CE2213);
  ellipse(x, 0, EXPLOSION_AOE*2, EXPLOSION_AOE*2);
  strokeWeight(4 * displayScale);
  point(x, 0);

  stroke(#C43424);
  strokeWeight(1);

  float pSum = 0;

  // Two other ways of choosing the starting r can be found at the end of this file. For larger dr, they are inferior though.
  for (float r = INNER_RADIUS; r <= OUTER_RADIUS; r += dr)
  {
    // This is not the most efficient way, but pretty clear. Besides, the theta arcs don't move with x.
    if ((r < x - EXPLOSION_AOE) || (r > x + EXPLOSION_AOE)) continue;
    float arg = (sq(x) - sq(EXPLOSION_AOE) + sq(r)) / (2.0 * x * r);
    float theta = acos((sq(x) - sq(EXPLOSION_AOE) + sq(r)) / (2.0 * x * r));
    if (abs(arg) > 1) theta = PI;

    arc(0, 0, r*2, r*2, 0, theta);
    arc(0, 0, r*2, r*2, -theta, 0);

    // Probability to get hit in this differential area = 
    //       P(correct angle)    *  P(this radius)
    pSum += (2 * theta / TWO_PI) * (dr / (OUTER_RADIUS - INNER_RADIUS));
  }

  probabilities[x] = pSum;

  drawProbabilities();
}

void mouseClicked()
{
  automove = !automove;
}

void drawProbabilities()
{
  resetMatrix();
  translate(width/2, height / 4);
  scale(1 / displayScale);
  strokeWeight(displayScale);
  translate(midOffset * 1.1, EXPLOSION_AOE);

  for (int r = 0; r < OUTER_RADIUS + EXPLOSION_AOE; r++)
    line(r, 0, r, -probabilities[r] * EXPLOSION_AOE); // Just scaling
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



////////////////////////////////////
// Alternative dr initializations //
////////////////////////////////////


/*for (float r = x - EXPLOSION_AOE; r <= x + EXPLOSION_AOE; r += dr)
 {
 // This produces very ugly results, as expected.
 if ((r < INNER_RADIUS) || (r > OUTER_RADIUS)) continue;*/


/*float rMin = max(INNER_RADIUS, x - EXPLOSION_AOE);
 float rMax = min(OUTER_RADIUS, x + EXPLOSION_AOE);
 for (float r = rMin; r < rMax; r += dr)
 {
 // This arguably doesn't look much better in the second half.
 */
