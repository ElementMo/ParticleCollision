import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam cam;

int spawnCount = 10;
int splitCount = 3;

float pMinMass = 0.5;
float pMaxMass = 5;
float cMinMass = 10;
float cMaxMass = 150;

float waterfallSize = 1280;

color displayColor;

ArrayList<Particle> particles = new ArrayList<Particle>();
ArrayList<Collision> collisions = new ArrayList<Collision>();

void setup()
{
  size(1280, 720, P3D);
  colorMode(HSB, 360);

  for (int i = 0; i < 1; i++) {
    collisions.add(new Collision(640, 700, 100));
  }
  background(0, 10);
  cam = new PeasyCam(this, 400);
}

void draw()
{
  translate(-width/2, -height/2);
  fill(0, 50);
  noStroke();

  rect(0, 0, width, height);
  colorMode(HSB, 360);



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
      displayColor = color(random(180, 210), 255, 255);
    }
    particles.add(new Particle(x, 0, mass, displayColor));
  }
  colorMode(RGB, 255);

  for (int i = collisions.size()-1; i > 1; i --)
  {
    Collision col = collisions.get(i);

    col.display();
  }

  for (int i = particles.size()-1; i > -1; i--) 
  {
    Particle p = particles.get(i);

    p.move();

    boolean hasCollision = p.resolveCollisions();

    p.display();

    if (p.pos.y > height) 
    {
      particles.remove(i);
    } else if (hasCollision && p.vel.mag() < 0.5) 
    {
      particles.remove(i);
    }
  }
}


boolean do_aabb_collision(float ax, float ay, float Ax, float Ay, float bx, float by, float Bx, float By)
{
  return !((Ax < bx) || (Bx < ax) || (Ay < by) || (By < ay));
}