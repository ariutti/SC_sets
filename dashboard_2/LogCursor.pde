class LogCursor 
{
 
  Animator_Line al;
  
  float linMin;
  float linMax;
  float logMin;
  float logMax;
  
  float K, C;
  
  // ranges
  float normalized; // normalized range ( 0 - 1 )
  float lin;        // linear range (linMin - linMax )
  float log;        // logarithmic (logMin - logMax)
  PVector gRange;   // graphical range (0.0, size*0.8)
  
  // Cursor Geometry
  PVector gPos;
  float w, h;
  boolean bHorizontal = true;
  // bounding box geometry
  PVector pos;
  PVector size;
  // bottom of the cursor scale
  PVector bottom;

  // aspects
  color cCursor= color(120);
  color cRail  = color(0);
  color cBox   = color(255);
  color cText  = color(0);

  // CONTRUCTOR ////////////////////////////////////////////////////////
  LogCursor(float _x, float _y, float _w, float _h, float _linMin, float _linMax, float _logMin, float _logMax) {
    linMin = _linMin; 
    linMax = _linMax;
    logMin = _logMin;
    logMax = _logMax;
    
    al = new Animator_Line (1000);
    
    K = (linMax - linMin) / (log10(logMax)-log10(logMin));
    C = linMin - K*log10(logMin);
    //println("K: "+K+"; C: "+C+";");
    
    // bounding boxn
    pos = new PVector(_x, _y);
    size = new PVector(_w, _h);
    if( size.x>size.y )
    {
      // the cursor is an horizontal one
      bHorizontal = true;
      bottom = new PVector(size.x*0.1, size.y*0.5);
      gRange = new PVector(size.x*0.8, 0);
      h = size.y * 0.6;
      w = size.x * 0.025; 
    }
    else
    {
      // the cursor is an vertical one
      bHorizontal = false;
      bottom = new PVector(size.x*0.5, size.y*0.9 );
      gRange = new PVector(0, size.y*0.8);
      h = size.x * 0.6;
      w = size.y * 0.025; 
    }
    gPos = new PVector(0, 0);
    calculateLinLog(0.0);
  }
  
  // DISPLAY ///////////////////////////////////////////////////////////
  void display() 
  {
    float x, y;
    
    pushStyle();
    pushMatrix();
    translate( pos.x, pos.y );
    
    // bounding box
    //stroke(cCursor);
    //fill(cBox);
    //rect(0, 0, size.x, size.y);
    
    // rail
    stroke(cRail);
    strokeWeight(3);
    x = bottom.x;
    y = bottom.y;
    
    float x2, y2;
    if(bHorizontal) {
      x2 = bottom.x + gRange.x;
      y2 = bottom.y + gRange.y;
      pushStyle();
      fill(cText);
      text( lin, x, y-12);
      text( log + " Hz", x, y+12);
      popStyle();
    }
    else
    {
      x2 = bottom.x + gRange.x;
      y2 = bottom.y - gRange.y;

    }
    line(x, y, x2, y2);
    
    translate( bottom.x, bottom.y);
    
    // cursor
    stroke(cCursor);
    strokeWeight( w );
    
    if(bHorizontal)
    {
      //x = pos.x+bottom.x+gRange.x*lin;
      x = gPos.x;
      y = 0.0;
      line(x, y-h*0.5, x, y+h*0.5);  
    }
    else
    {
      x = 0.0;
      y = -gPos.y;
      line(x-h*0.5, y, x+h*0.5, y); 
      pushStyle();
      fill( cText );
      textSize(12);
      textAlign(RIGHT);
      //text( lin, x-h, y-12);
      text( nf(log,1, 2) + " Hz", x-h*0.5, y+24);
      popStyle();
    }
    //println(gPos.x + " " + gPos.y);
    popMatrix();
    popStyle();
  }
  
  // DRAG //////////////////////////////////////////////////////////////
  void drag(float _x, float _y) {
    if(_x<pos.x || _x>pos.x+size.x || _y<pos.y || _y>pos.y+size.y)
      return;
      
    if(bHorizontal)
    {
      gPos.x = constrain(_x - pos.x - bottom.x, 0.0, gRange.x);
      gPos.y = 0;
      normalized = map(gPos.x, 0.0, gRange.x, 0.0, 1.0);
    }
    else
    {
      gPos.x = 0;
      gPos.y = constrain(-_y + pos.y + bottom.y, 0.0, gRange.y);
      normalized = map(gPos.y, 0.0, gRange.y, 0.0, 1.0);
    }
    
    calculateLinLog( normalized );
    
    // DEBUG
    //print( "norm: " + getNorm() + ", " );
    //print( "lin: " + getLin() +", " );
    //print( "log: " + getLog() +";" ); 
    //println();
  }
  
  // OTHERS ////////////////////////////////////////////////////////////
  void calculateLinLog(float _normalized)
  {
    lin = map(constrain(_normalized, 0.0, 1.0), 0.0, 1.0, linMin, linMax);
    log = pow( 10, (lin - C)/K );
  }
  
  float getNorm() { return normalized; }
  float getLin() { return lin; }
  float getLog() { return log; }
  
  float getLinFromLog( float _logarithm)
  {
    // prevent _logarith from beeing zero!
    if(_logarithm <=0 ) _logarithm=0.00001;
    return log10(_logarithm)*K + C;
  }
  
  void changeValue( float _v)
  {
    float tmp = getLinFromLog( _v );
    al.trigger( tmp, 1000);
    log = _v;
  }
  
  void update()
  {
    al.update();
    lin = al.getY();
    lin=constrain(lin, 0.0, 1.0);
    gPos.x = 0.0;
    gPos.y = gRange.y*lin;
  }
  
}

float log10 (float x) {
  return (log(x) / log(10));
}
