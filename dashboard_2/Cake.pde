class Cake
{
  PVector pos;
  float size;
  int NSLICES = 12;
  PieSlice[] slices;
  float angle;
  
  float rotationAngle = 0.0;
  float rotationSpeed = 0.1;
  
  String[] noteNames = {"C","C#","D","D#","E","F","F#","G","G#","A","A#","B"};
  
  Cake(float _x, float _y, float _size)
  {
    pos = new PVector(_x, _y);
    size = _size;
    angle = (2.0*PI) / NSLICES;
    slices = new PieSlice[NSLICES];
    for(int i=0; i<NSLICES; i++)
    {
      float startAngle = angle * i;
      slices[i] = new PieSlice(0.0, 0.0, size*0.9, startAngle, angle, i, noteNames[i]);
    }
  }
  
  void update()
  {
    for(int i=0; i<NSLICES; i++)
    {
      slices[i].update();
    } 
  }
  
  void newValue( int _sliceNumber, float _value )
  {
    slices[_sliceNumber].newValue(_value);
  }
    
  void display()
  {
    // update angle
    rotationAngle = (rotationAngle + rotationSpeed) % 360;
    
    pushStyle();
    pushMatrix();
    
    translate( pos.x, pos.y );
    
    // bounding box
    //strokeWeight(1);
    //fill(255);
    //rect(0,0, size, size);
    
    translate(size*0.5, size*0.5);
    
    pushMatrix();
    rotate( radians(rotationAngle) );
    
    
    pushMatrix();
    for(int i=0; i<NSLICES; i++)
    {
      slices[i].display();
    }
    popMatrix();
    
    pushMatrix();
    for(int i=0; i<NSLICES; i++)
    {
      rotate(angle);
      strokeWeight(3);
      colorMode(RGB);
      stroke(255);
      line(0.0, 0.0, size*0.5*0.9, 0.0);
    }
    popMatrix();
    popMatrix();
    
    for(int i=0; i<NSLICES; i++)
    {
      float x = size*0.9*0.4 * cos(angle*(i+0.5) + radians(rotationAngle));
      float y = size*0.9*0.4 * sin(angle*(i+0.5) + radians(rotationAngle));
      fill(0);
      textAlign(CENTER);
      text(slices[i].name,x, y); 
    }
   
    popMatrix();
    
    
    
    popStyle();
  } 
}