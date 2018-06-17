import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam cam;

int spawnCount;
int splitCount = 10;

float pMinMass = 3;
float pMaxMass = 6;
float waterfallSize = 1280;

boolean Triggered;

color displayColor;

ArrayList<Particle> particles = new ArrayList<Particle>();

void setup()
{
  size(1280, 720, P3D);
  colorMode(HSB, 360);

  background(0, 10);
  //cam = new PeasyCam(this, 620);
}

void draw()
{
  translate(2, -104);
  rotateX(radians(30.9));
  
  fill(0, 100);
  //noStroke();
  strokeCap(ROUND);
  rect(0, 0, width, height+20);
  
  colorMode(HSB, 360);
  spawnCount = 32;


  for (int num = 0; num < spawnCount; num ++)
  {
    float x = random(waterfallSize);
    float mass = random(pMinMass, pMaxMass);
    color displayColor;

    if ((particles.size() % 5) == 0)
    {
      displayColor = color(255, 255);
    } else
    {
      displayColor = color(random(180, 210), 255, 255, 255);
    }
    particles.add(new Particle(x, 0, mass, displayColor));
  }


  for (int i = particles.size()-1; i > -1; i--) 
  {
    Particle p = particles.get(i);

    p.move();
    boolean hasCollision = false;
    if (Triggered)
    {
      hasCollision = p.resolveCollisions();
    }
    p.display();

    if (p.pos.y > height) 
    {
      particles.remove(i);
    } 
    else if (hasCollision && p.deadTime() && Triggered) 
    {
      particles.remove(i);
    }
  }
}


boolean do_aabb_collision(float ax, float ay, float Ax, float Ay, float bx, float by, float Bx, float By)
{
  return !((Ax < bx) || (Bx < ax) || (Ay < by) || (By < ay));
}

void mousePressed()
{
  Triggered = true;
}
void mouseReleased()
{
  Triggered = false;
}