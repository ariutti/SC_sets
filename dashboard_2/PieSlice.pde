class PieSlice
{
  PVector pos;
  PVector dir;
  float size;
  int id;
  String name;
  float angle, startAngle, endAngle;
  
  Animator_AR ar;
  
  float value;
  
  // colo utility
  float sat, hue, bri;
  
  PieSlice(float _x, float _y, float _size, float _startAngle, float _angle, int _id, String _name)
  {
    pos = new PVector(_x, _y);
    
    size = _size;
    id = _id;
    name = _name;
    angle = _angle;
    startAngle = _startAngle;
    endAngle = startAngle + angle;
    
    dir = new PVector(1.0, 0.0);
    dir.mult( size*0.5*0.8 );
    dir.rotate( startAngle + angle*0.5);
    
    ar = new Animator_AR(10, 5000);
    
    hue = map(id, 0, 12, 0, 360);
    sat = 5;
    bri = 100;
  }
  
  void update()
  {
    ar.update();
    float y = ar.getY();
    sat = 5 + value * y * 95;
  }
  
  void newValue(float _value)
  {
    value = _value;
    ar.trigger();
  }
  
  void display()
  {
    pushMatrix();
    pushStyle();
    
    translate( pos.x, pos.y );
    noStroke();
    colorMode(HSB, 360, 100, 100);
    fill(hue, sat, bri);
    arc(0, 0, size, size, startAngle, endAngle, PIE);
    
    //fill(0);
    //textAlign(CENTER);
    //text(name, dir.x, dir.y); 
    
    
    popStyle();
    popMatrix();
  }  
}