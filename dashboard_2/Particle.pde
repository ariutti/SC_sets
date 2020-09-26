class Particle
{
  // the particle position
  PVector pos;
  float angle; // radians
  float SIZE;
  
  // timing variables 
  float t0, t, dt;
  float lifetime; // how much time the particle will live (seconds)
  boolean alive;
  float speed; // expansion speed (pixels/sec)
  
  // other variables concerning graphics
  color c = color( 0 );
  float r;
  float alpha;
  float weight;
  
  // variable to add some noise offset to the
  // overall movement of the particle
  float posThrill;
  float angleThrill;
  
  Particle( float _SIZE, float _lifetime, float _speed, float _posThrill, float _angleThrill )
  {
    pos = new PVector(0, 0);
    angle = 0.0;
    SIZE = _SIZE;
    
    t0 = t = millis() * 0.001;
    dt = t - t0;
    lifetime = _lifetime;
    // As soon as we create the new
    // particle, set it to alive.
    alive = true;
    speed = _speed;
    
    r = 0.0;
    alpha = 255.0;
    weight = 1.0;
    posThrill = _posThrill;
    angleThrill = _angleThrill;
  }
  
  void update()
  {
    if(alive)
    {
      t = millis() * 0.001;
      dt = t-t0;
      if( dt > lifetime )
      {
        // the particle is died
        alive = false;
      }
      else
      {
        // the particle is alive and it is growing
        float ctrl = dt / lifetime;
        r     = speed*dt;
        alpha = 255.0 - sqrt(ctrl)*255.0;
        //weight= 1.0 + ctrl*ctrl*32.0;
        weight= 1.0;
        
        float dx = ctrl*ctrl*posThrill*random(-1.0, 1.0);
        float dy = ctrl*ctrl*posThrill*random(-1.0, 1.0);
        pos.add( new PVector(dx, dy) ); 
        angle = ctrl*ctrl*angleThrill*sin( 3*dt );
      }
    }
  }
  
  
  void display()
  {
    if( alive )
    {
      pushMatrix();
      pushStyle();
      noFill();
      strokeWeight( weight );
      stroke(c, alpha);
      translate( pos.x, pos.y );
      rotate( angle );
      ellipse(pos.x, pos.y, SIZE+r, SIZE+r);
      //rect(0.0, 0.0, SIZE+r, SIZE+r); 
      popStyle();
      popMatrix();
    }
  }
  
  
  boolean isAlive()
  {
    return alive;
  }
}