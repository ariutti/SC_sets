class Lissajous
{
  PVector pos;
  float size;
  
  float t0, dt; // time (seconds)
  float x, y = 0.0;

  float A;
  float fA = 0.137;
  float phiA = 0.0;
  
  float B;
  float fB = 1;
  float phiB = 0.0;
  
  Trail trail;
  
  Lissajous(float _x, float _y, float _size, int _trailDimension)
  {
    pos = new PVector(_x, _y);
    size = _size;
    A = size*0.5*0.9;
    B = size*0.5*0.9;
    t0 = millis() * 0.001;
    trail = new Trail(0, 0, _trailDimension);  
  }
  
  void update()
  {
    dt = millis() * 0.001 - t0;
    x = size*0.5 + A*sin( phiA + 2 * PI * fA * dt);
    y = size*0.5 + B*sin( phiB + 2 * PI * fB * dt);
    trail.update(x, y);
  }
  
  
  void display()
  {
    pushMatrix();
    translate( pos.x, pos.y );
    
    // bounding box
    //strokeWeight(1);
    //fill(255);
    //rect(0,0, size, size);
    
    
    trail.display();
    popMatrix();
  }
  
  void changeFa( float _newValue )
  {
    float t = millis() * 0.001;
    // calculate the phase for the current sinusoid
    dt = t - t0;
    phiA = (phiA + 2*PI*fA*dt) % (2*PI);
    phiB = (phiB + 2*PI*fB*dt) % (2*PI);
  
    // define the new 't0' which is the
    // new reference for upcoming sinusoid
    t0 = t;
    // Finally, set the new frequency    
    fA = _newValue * _newValue * _newValue * 100;
  }
  
  void changeFb( float _newValue )
  {
    float t = millis() * 0.001;
    // calculate the phase for the current sinusoid
    dt = t - t0;
    phiA = (phiA + 2*PI*fA*dt) % (2*PI);
    phiB = (phiB + 2*PI*fB*dt) % (2*PI);
  
    // define the new 't0' which is the
    // new reference for upcoming sinusoid
    t0 = t;
    // Finally, set the new frequency    
    fB = _newValue * _newValue * _newValue * 100;
  }
}