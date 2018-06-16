class Particle 
{

  PVector pos, pOld;
  PVector vel;
  PVector acc;
  float mass;
  color displayColor;
  float fallRate;

  Particle(float x, float y, float mass, color displayColor) 
  {
    this.pos = new PVector(x, y);
    pOld = new PVector(pos.x, pos.y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.mass = mass;
    this.displayColor = displayColor;
    this.fallRate = map(this.mass, pMinMass, pMaxMass, 0.03, 0.07);
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

    for (int c = 0; c < collisions.size(); c++) {
      Collision col = collisions.get(c);

      float distance = dist(this.pos.x, this.pos.y, col.pos.x, col.pos.y);

      if (distance < col.mass/2) {
        PVector offset = new PVector(this.pos.x, this.pos.y);
        offset.sub(col.pos);
        offset.normalize();
        offset.mult(col.mass/2-distance);
        this.pos.add(offset);

        float friction = 0.3;
        float dampening = map(this.mass, pMinMass, pMaxMass, 1, 0.8);
        float mag = this.vel.mag();

        float magAddition = min(col.mass/2-distance, 15);

        PVector bounce = new PVector(this.pos.x, this.pos.y);
        bounce.sub(col.pos);
        bounce.normalize();
        bounce.mult((mag+magAddition)*friction*dampening);
        this.vel = bounce;

        if (this.mass > 2) {
          this.mass = max(1, this.mass-2);

          for (int s = 0; s < splitCount; s++) {
            float mass = max(1, this.mass-1)*2;
            color displayColor = color(255, 200);

            Particle splash = new Particle(this.pos.x, this.pos.y, mass, displayColor);

            splash.vel = new PVector(this.vel.x, this.vel.y);
            splash.vel.rotate(radians(random(-45, 45)));
            splash.vel.mult(random(0.6, 0.9));

            particles.add(splash);
          }
        }

        hasCollision = true;

        break;
      }
    }

    return hasCollision;
  }

  void display() 
  {

    strokeWeight(this.mass);
    stroke(displayColor);
    line(this.pOld.x, this.pOld.y, this.pos.x, this.pos.y);
    pOld.set(pos);
  }
}