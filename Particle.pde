class Particle 
{

  PVector pos, pOld;
  PVector vel;
  PVector acc;
  float mass;
  color displayColor;
  float fallRate;
  int timeCount;

  Particle(float x, float y, float mass, color displayColor) 
  {
    this.pos = new PVector(x, y);
    pOld = new PVector(pos.x, pos.y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.mass = mass;
    this.displayColor = displayColor;
    this.fallRate = map(this.mass, pMinMass, pMaxMass, 0.03, 0.07);
    this.timeCount = 0;
  }

  void move() 
  {
    PVector gravity = new PVector(0, this.fallRate);
    this.acc.add(gravity);

    this.vel.add(this.acc);
    this.pos.add(this.vel);
    this.acc.mult(0);
  }

  boolean resolveCollisions() 
  {
    boolean hasCollision = false;

    for (int c = 0; c < 1; c++) {

      if (this.pos.y > height - 2) {
        PVector offset = new PVector(this.pos.x, this.pos.y);
        offset.sub(new PVector(this.pos.x, height));
        offset.normalize();
        offset.mult(5);
        this.pos.add(offset);

        float friction = 0.26;
        float dampening = map(this.mass, pMinMass, pMaxMass, 1, 0.8);
        float mag = this.vel.mag();

        float magAddition = min(5, 15);

        PVector bounce = new PVector(this.pos.x, this.pos.y);
        bounce.sub(new PVector(this.pos.x, height));
        bounce.normalize();
        bounce.mult((mag+magAddition)*friction*dampening);
        this.vel = bounce;

        if (this.mass > 5) {
          //this.mass = max(1, this.mass);

          for (int s = 0; s < splitCount; s++) {
            //float mass = max(2, this.mass-1);
            color displayColor = color(random(130, 200), 360, 360, 360);

            Particle splash = new Particle(this.pos.x, this.pos.y, 5, displayColor);
            Particle splash2 = new Particle(this.pos.x, this.pos.y, 3, color(340));

            splash.vel = new PVector(this.vel.x, this.vel.y);
            splash.vel.rotate(radians(random(-40, 40)));
            splash.vel.mult(random(0.3, 0.8));

            splash2.vel = new PVector(this.vel.x, this.vel.y);
            splash2.vel.rotate(radians(random(-40, 40)));
            splash2.vel.mult(random(0.3, 0.5));

            particles.add(splash);
            particles.add(splash2);
          }
        }

        hasCollision = true;

        break;
      }
    }

    return hasCollision;
  }

  boolean deadTime()
  {
    if (timeCount > 10)
    {
      return true;
    } else return false;
  }

  void display() 
  {
    strokeWeight(this.mass);
    stroke(displayColor);
    line(this.pOld.x, this.pOld.y, this.pos.x, this.pos.y);
    pOld.set(pos);
    timeCount ++;
  }
}