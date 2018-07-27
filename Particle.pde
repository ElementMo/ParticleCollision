class Particle 
{
  PVector pos, pOld;
  PVector vel;
  PVector acc;
  float mass;
  color displayColor;
  float fallRate;
  float splashSize = 1.0;
  int timeCount;

  Particle(float x, float y, float mass, color displayColor, float splashSize_) 
  {
    this.pos = new PVector(x, y);
    this.pOld = new PVector(pos.x, pos.y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.mass = mass;
    this.displayColor = displayColor;
    this.fallRate = map(this.mass, pMinMass, pMaxMass, 0.10, 0.20);
    this.timeCount = 0;
    this.splashSize = splashSize_;
  }

  void move() 
  {
    PVector gravity = new PVector(0, this.fallRate);
    this.acc.add(gravity);

    this.vel.add(this.acc);
    this.pos.add(this.vel);
    this.acc.mult(0);
  }

  boolean resolveCollisions(float splashVal, int splashAngle, float splashSize_) 
  {
    boolean hasCollision = false;

    for (int c = 0; c < 1; c++) {

      if (this.pos.y > height - 2) {
        PVector offset = new PVector(this.pos.x, this.pos.y);
        offset.sub(new PVector(this.pos.x, height));
        offset.normalize();
        offset.mult(5);
        this.pos.add(offset);

        float friction = splashVal;
        float dampening = map(this.mass, pMinMass, pMaxMass, 1, 0.8);
        float mag = this.vel.mag();

        float magAddition = min(5, 15);

        PVector bounce = new PVector(this.pos.x, this.pos.y);
        bounce.sub(new PVector(this.pos.x, height));
        bounce.normalize();
        bounce.mult((mag+magAddition)*friction*dampening);
        this.vel = bounce;

        if (this.mass > 3) {
          //this.mass = max(1, this.mass);

          for (int s = 0; s < splitCount; s++) {
            //float mass = max(2, this.mass-1);
            color displayColor = color(random(0, 360), 360, 360);

            Particle splash2 = new Particle(this.pos.x, this.pos.y, 2, color(254), splashSize_);
            splash2.vel = new PVector(this.vel.x, this.vel.y);
            splash2.vel.rotate(radians(random(-56, 58)));
            splash2.vel.mult(random(0.3, 0.4));
            particles.add(splash2);

            if (!Triggered) {
              Particle splash3 = new Particle(this.pos.x, this.pos.y, 2, color(random(150, 210), 360, 360), splashSize_);
              splash3.vel = new PVector(this.vel.x, this.vel.y);
              splash3.vel.rotate(radians(random(-30, 30)));
              splash3.vel.mult(random(0.3, 0.4));
              particles.add(splash3);
            }

            if (Triggered)
            {
              Particle splash = new Particle(this.pos.x, this.pos.y, 3, displayColor, splashSize_);
              splash.vel = new PVector(this.vel.x, this.vel.y);
              splash.vel.rotate(radians(random(-splashAngle, splashAngle)));
              splash.vel.mult(random(0.2, 0.8));
              particles.add(splash);
            }
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
    pg_A.strokeWeight(this.mass*splashSize);
    pg_A.stroke(displayColor);
    pg_A.line(this.pOld.x, this.pOld.y, this.pos.x, this.pos.y);
    //pg_A.point(this.pos.x, this.pos.y);

    pOld.set(pos);
    timeCount ++;
  }
}