
import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;
import processing.core.PApplet;
import processing.opengl.PGraphics2D;


DwPixelFlow context;
DwFilter filter;

PGraphics2D pg_A;


int spawnCount;
int splitCount = 10; //粒子炸开数量
int offsetY = 0;

float pMinMass = 2;
float pMaxMass = 4;
float waterfallSize = 1920;

boolean Triggered;

color displayColor;

ArrayList<Particle> particles = new ArrayList<Particle>();

void setup()
{
  fullScreen(P3D);
  colorMode(HSB, 360);
  background(0, 10);

  context = new DwPixelFlow(this);
  filter = new DwFilter(context);
  pg_A = (PGraphics2D) createGraphics(width, height, P2D);
  pg_A.strokeCap(SQUARE);
}

void draw()
{
  translate(0, -125, -50);
  rotateX(radians(25.0));
  pg_A.beginDraw();
  {
    //pg_A.background(0);

    pg_A.fill(0, 311);
    pg_A.noStroke();
    pg_A.rect(0, 0, width, height+20);

    pg_A.colorMode(HSB, 360);
    spawnCount = 2;      //下雨程度


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
      particles.add(new Particle(x, 0, mass, displayColor, 1.0));
    }


    for (int i = particles.size()-1; i > -1; i--) 
    {
      Particle p = particles.get(i);

      p.move();
      boolean hasCollision = false;


      if (Triggered)
      {
        hasCollision = p.resolveCollisions(0.6, 5, 2.0);  //彩色大粒子: 飞溅高度  飞溅角度  飞溅粒子大小
      } else
      {
        hasCollision = p.resolveCollisions(0.35, 40, 1.0);//小水花: 飞溅高度  飞溅角度  飞溅粒子大小
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


  //filter.bloom.param.mult   = map(mouseX, 0, width, 0, 2);
  //filter.bloom.param.radius = map(mouseY, 0, height, 0, 1);
  //print(filter.bloom.param.mult, "****");
  //println(filter.bloom.param.radius);

  filter.bloom.param.mult   = 1.6;  //光晕强度
  filter.bloom.param.radius = 1.2;  //光晕半径

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