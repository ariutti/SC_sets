class ParticleSystem
{
  ArrayList<Particle> pl;
  PVector pos;
  float size;
  
  ParticleSystem( float _x, float _y, float _size )
  {
    pos = new PVector( _x, _y );
    size = _size;
    pl = new ArrayList<Particle>();
  }
  
  void update()
  {
    for(int i = 0; i < pl.size(); ) 
    {
      pl.get(i).update();
      if( !pl.get(i).isAlive() )
        pl.remove(i);
      else
        i++;
    }
  }
  
  void display()
  {
    pushMatrix();
    pushStyle();
    translate( pos.x, pos.y );
    
    // bounding box
    //strokeWeight(1);
    //fill(255);
    //rect(0,0, size, size);
    
    translate(size*0.5, size*0.5);
    
    for(int i = 0; i < pl.size(); i++) 
    {
      pl.get(i).display();
    }
    popStyle();
    popMatrix();
  }
  
  void generate()
  {
    // each particle needs to know:
    // 0) its size;
    // 1) how much to live (seconds);
    // 2) how fast it might expand (pixles/seconds);
    // 3) the thrill amount for the position offset;
    // 4) the thrill amount for the angle rotation;
    Particle p = new Particle( size*0.2, 6, 50, 5, 0.25*PI );
    pl.add( p );
  }
  
  void reset() {
    pl.clear();
  }
}