import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;
import processing.core.PApplet;
import processing.opengl.PGraphics2D;


DwPixelFlow context;
DwFilter filter;

PGraphics2D pg_A;

PeasyCam cam;

int spawnCount;
int splitCount = 9;
int offsetY = 0;

float pMinMass = 2;
float pMaxMass = 4;
float waterfallSize = 1024;

boolean Triggered;

color displayColor;

ArrayList<Particle> particles = new ArrayList<Particle>();

void setup()
{
  size(1280, 720, P3D);
  colorMode(HSB, 360);
  background(0, 10);

  context = new DwPixelFlow(this);
  filter = new DwFilter(context);
  pg_A = (PGraphics2D) createGraphics(width, height, P2D);
  pg_A.strokeCap(SQUARE);
  //cam = new PeasyCam(this, 620);
}

void draw()
{
  translate(110, -110, 30);
  rotateX(radians(21.0));
  pg_A.beginDraw();
  {
    //pg_A.background(0);

    pg_A.fill(0, 292);
    pg_A.noStroke();
    pg_A.rect(0, 0, width, height+20);

    pg_A.colorMode(HSB, 360);
    spawnCount = 3;


    for (int num = 0; num < spawnCount; num ++)
    {
      float x = random(waterfallSize);
      float mass = random(pMinMass, pMaxMass);
      color displayColor;

      if ((particles.size() % 5) == 0)
      {
        displayColor = color(126, 263);
      } else
      {
        displayColor = color(random(180, 210), 255, 255, 255);
      }
      particles.add(new Particle(x, 0, mass, displayColor, 0.8));
    }


    for (int i = particles.size()-1; i > -1; i--) 
    {
      Particle p = particles.get(i);

      p.move();
      boolean hasCollision = false;


      if (Triggered)
      {
        hasCollision = p.resolveCollisions(0.53, 5, 1.8);
      } else
      {
        hasCollision = p.resolveCollisions(0.24, 40, 0.8);
      }
      p.display();

      if (p.pos.y > height) 
      {
        particles.remove(i);
      } else if (hasCollision && p.deadTime()) 
      {
        particles.remove(i);
      }
    }
  }
  pg_A.endDraw();


  filter.bloom.param.mult   = map(mouseX, 0, width, 0, 2);
  filter.bloom.param.radius = map(mouseY, 0, height, 0, 1);

  filter.bloom.apply(pg_A);

  image(pg_A, 0, 0);
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