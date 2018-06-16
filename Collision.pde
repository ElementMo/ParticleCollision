class Collision 
{

  public PVector pos;
  float mass;

  Collision(float x, float y, float mass) {
    
    this.pos = new PVector(x, y);
    this.mass = mass;
  }

  void display() 
  {
    ellipse(pos.x, pos.y, 20, 20);
  }
}