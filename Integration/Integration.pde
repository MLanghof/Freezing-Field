
// Scales down the displayed stuff.
// Adjust this until the sketch fits your screen resolution.
// In this case integer values yield better results.
float displayScale = 2;

// Integration step. Increase for faster but less precise calculations.
// Small values also make the visualization a bit more ugly.
float dr = 10;

// Enable this so the integrated arcs are more distinguishable. 
boolean alternatingColors = true;

// Controls the amount of axis annotations.
int diagramLabelCount = 10;

// Controls the amount of headroom the diagram leaves above the probabilities
float heightReserver = 0.8;

// Ranges should be correct for DotA 1
final float INNER_RADIUS = 140;
final float OUTER_RADIUS = 710;
final float EXPLOSION_AOE = 255;



float midOffset = -(OUTER_RADIUS + EXPLOSION_AOE)/2;

void setup()
{
  size(int((OUTER_RADIUS + 3*EXPLOSION_AOE) * 1.2 / displayScale), int((4 * EXPLOSION_AOE) * 1.3 / displayScale));

  smooth(1);


  stroke(color(200, 200, 255, 20));
  fill(color(200, 200, 255, 20));

  probabilities = new float[ceil(OUTER_RADIUS + EXPLOSION_AOE) + 1];
}

int x = -1;
boolean automove = false;

float[] probabilities;
float maxProbability = 0;

void draw()
{
  background(0, 8, 25);

  if (automove) x = (x + 1 > OUTER_RADIUS + EXPLOSION_AOE ? 0 : x+1);
  else x = int(constrain((mouseX - width/2)*displayScale - midOffset, 0, OUTER_RADIUS + EXPLOSION_AOE));
  stroke(color(200, 200, 255, 20));
  //fill(color(200, 200, 255, 20));


  drawDiagram();

  drawRanges();

  // Show the current radius in which explosions would hit you
  resetMatrix();
  translate(width/2, 3*height/4);
  scale(1 / displayScale);
  translate(midOffset, 0);
  stroke(#CE2213);
  ellipse(x, 0, EXPLOSION_AOE*2, EXPLOSION_AOE*2);
  strokeWeight(4 * displayScale);
  point(x, 0);

  strokeWeight(dr);

  float pSum = 0;

  strokeCap(SQUARE);
  // Two other ways of choosing the starting r can be found at the end of this file. For larger dr, they are inferior though.
  for (float r = INNER_RADIUS + dr/2; r <= OUTER_RADIUS - dr/2; r += dr)
  {
    // This is not the most efficient way, but pretty clear. Besides, the theta arcs don't move with x.
    if ((r < x - EXPLOSION_AOE + dr/2) || (r > x + EXPLOSION_AOE - dr/2)) continue;
    
    float arg = (sq(x) - sq(EXPLOSION_AOE) + sq(r)) / (2.0 * x * r);
    float theta = acos(arg);
    
    if ((x == 0) || (abs(arg) > 1)) theta = PI;


    if ((alternatingColors) && (int(r / dr) % 2 == 0)) stroke(color(164, 20, 20, INNER_RADIUS/r * 255));
    else stroke(color(196, 52, 36, INNER_RADIUS/r * 255));
    arc(0, 0, r*2, r*2, 0, theta);
    arc(0, 0, r*2, r*2, -theta, 0);

    //println(arg + ", " + theta);
    // Probability to get hit in this differential area = 
    //       P(correct angle)    *  P(this radius)
    pSum += (2 * theta / TWO_PI) * (dr / (OUTER_RADIUS - INNER_RADIUS));
  }
  strokeCap(ROUND);

  probabilities[x] = pSum;
  maxProbability = max(maxProbability, pSum);

  drawProbabilities();
}

void mouseClicked()
{
  automove = !automove;
}


void drawProbabilities()
{
  stroke(color(196, 52, 36, 200 / displayScale));
  resetMatrix();
  translate(width/2, height / 4);
  scale(1 / displayScale);
  strokeWeight(displayScale);
  translate(midOffset, EXPLOSION_AOE);
  float scale = 2 * EXPLOSION_AOE / maxProbability * heightReserver;

  for (int r = 0; r < OUTER_RADIUS + EXPLOSION_AOE; r++)
    if (probabilities[r] > 0)
      line(r, -displayScale, r, -probabilities[r] * scale);

  stroke(#A41414);
  line(x, -displayScale, x, -probabilities[x] * scale);
}

void drawDiagram()
{
  // Outer rectangle
  stroke(color(200, 200, 255));
  noFill();

  resetMatrix();
  strokeWeight(1);
  translate(width/2, height/4);
  scale(1 / displayScale);
  rectMode(CENTER);
  rect(0, 0, OUTER_RADIUS + EXPLOSION_AOE, 2 * EXPLOSION_AOE + 1);

  // Titles
  fill(color(255));
  textSize(14);
  stroke(color(200, 200, 255, 100));

  String t;

  resetMatrix();
  translate(width/2, height/4);
  // Cannot use scale() because that also makes text smaller
  translate(-(OUTER_RADIUS + EXPLOSION_AOE) / 2 / displayScale, EXPLOSION_AOE / displayScale);
  for (float i = 0; i <= diagramLabelCount; i++) 
  {
    pushMatrix();
    translate(0, -i / diagramLabelCount * 2 * EXPLOSION_AOE / displayScale);
    t = nf(i / diagramLabelCount * maxProbability / heightReserver * 100, 1, 4) + "%";
    t = t.replace(",", "."); // Stupid locales
    if (i > 0) text(t, -textWidth(t) - 7, textAscent() - (textAscent() + textDescent())/2);

    line(0, 0, (OUTER_RADIUS + EXPLOSION_AOE)  / displayScale, 0);
    popMatrix();
  }

  for (float i = 0; i <= diagramLabelCount; i++)
  {
    pushMatrix();
    translate(i / diagramLabelCount * (OUTER_RADIUS + EXPLOSION_AOE) / displayScale, 0);
    t = str(i / diagramLabelCount * (OUTER_RADIUS + EXPLOSION_AOE));
    t = t.replace(",", "."); // Stupid locales
    if (i > 0) text(t, -textWidth(t)/2, textAscent() + 1.5);

    line(0, 0, 0, -2 * EXPLOSION_AOE / displayScale);
    popMatrix();
  }
  t = "0";
  text(t, -textWidth(t) - 7, textAscent() + 1.5);
}

void drawRanges()
{
  // Draw coordinate system
  stroke(#6F7CFF);
  noFill();

  resetMatrix();
  translate(width/2, 3*height/4);
  scale(1 / displayScale);
  translate(midOffset, 0);

  strokeWeight(displayScale);
  line(-1.1 * (EXPLOSION_AOE), 0, 1.1 * (OUTER_RADIUS + 2 * EXPLOSION_AOE), 0);
  line(0, -EXPLOSION_AOE * 1.1, 0, EXPLOSION_AOE * 1.1);

  // Draw FF inner and outer boundary
  stroke(#2A39AF);
  strokeWeight(2 * displayScale);
  ellipse(0, 0, INNER_RADIUS*2, INNER_RADIUS*2);
  float tempAngle = asin(EXPLOSION_AOE * 1.1 / OUTER_RADIUS);
  arc(0, 0, OUTER_RADIUS*2, OUTER_RADIUS*2, -tempAngle, tempAngle);
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
