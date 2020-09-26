class Scrolling
{
  // Upper left corner of the entire graph
  PVector pos;
  // size of the graph 
  // (distance between UL and LR corners)
  PVector size;
  // size of the drawing (w/o margins)
  PVector range;
  // actual data values ranges
  PVector realRange;
  // position of the graph origin 
  PVector graphOrigin;
  
  float[] history;
  int nHistory;
  
  // this index is pointing to the 
  // last added element in hisotry
  int index;
  
  // a value to keep track of the color
  float alpha = 255;
  // and weigth of the graph
  float weight;
  
  // ticks utilities
  int xTicks, yTicks; 
  float xTicksMargin, yTicksMargin;
  
  // CONSTRUCTOR ///////////////////////////////////////////////////////////////
  Scrolling(float _x, float _y, float _w, float _h, int _nHistory, float _yRealRange, int _xTicks, int _yTicks)
  {
    pos = new PVector(_x, _y);
    size = new PVector(_w, _h);
    nHistory = _nHistory;
    
    xTicks = _xTicks;
    yTicks = _yTicks;
    
    graphOrigin= new PVector(size.x*0.1, size.y*0.9);
    range = new PVector(size.x*0.8, size.y*0.8);
    realRange = new PVector(nHistory, _yRealRange);
    
    xTicksMargin = yTicksMargin = min( size.x * 0.05, size.y * 0.05);
    
    history = new float[ nHistory ];
    for(int i=0; i<nHistory; i++) {
      history[i] = 0.0;
    }
  }
  
  // UPDATE ////////////////////////////////////////////////////////////////////
  void update(float _x)
  {
    history[ index ] = _x;
    index = (index+1) % nHistory;
  }
  
  // DISPLAY ///////////////////////////////////////////////////////////////////
  void display()
  {
    pushStyle();
    pushMatrix();
    
    strokeWeight(1);
    
    translate(pos.x, pos.y);
    
    // bounding box
    //fill(255);
    //rect(0,0,size.x, size.y);
    
    translate(graphOrigin.x, graphOrigin.y);
    
    fill(0);
    stroke(120);
    displayAxes();
    
    stroke(200);
    fill(0);
    displayTicks();
    
    // we start counting from the last element back to the
    // most recent (the last added to the history buffer)
    for(int i=0; i<nHistory; i++)
    {
      // x position scaled on range
      float xStart = (range.x/nHistory) * (nHistory-1-i);
      // same for the y position
      float yStart = (history[(index+i)%nHistory ]/realRange.y) * range.y;
      
      // don't draw the last line
      // (between the first and the last point in the graph)
      if(i != nHistory-1) {
        float xEnd = (nHistory-i-2) * (range.x/nHistory);
        float yEnd = (history[(index+i+1)%nHistory ]/realRange.y) * range.y;
        alpha = map(i, 0, nHistory-1, 0.0, 255.0);
        weight= map(i, 0, nHistory-1, 1, 5);
        strokeWeight(weight);
        stroke(0, alpha);
        line(xStart, -yStart, xEnd,-yEnd);
      }
      //ellipse( xStart, -yStart, 5, 5);
    }
   
    popMatrix();
    popStyle();
  }
  
  // UTILITY ///////////////////////////////////////////////////////////////////
  void displayAxes()
  {
    textAlign(RIGHT);
    textSize(10);
    
    // x axis
    line(0,0, 0, -range.y);
    text("0", 0.0, yTicksMargin);
    text(realRange.x, range.x, yTicksMargin);
    
    // y axis
    line(0,0, range.x, 0);
    text("0", -xTicksMargin, 0);
    text(realRange.y, -xTicksMargin, -range.y);
  }
  
  void displayTicks()
  {
    float xSpacing = range.x / (xTicks + 1);
    float ySpacing = range.y / (yTicks + 1);
    
    float xRealSpacing = realRange.x / (xTicks + 1);
    float yRealSpacing = realRange.y / (yTicks + 1);
    
    textAlign(RIGHT);
    
    // x Ticks
    for(int i=0; i<xTicks; i++)
    {
      line(xSpacing*(1+i), 0, xSpacing*(1+i), -range.y);
      //float legend = xRealSpacing*(1+i);
      //text(legend, xSpacing*(1+i), yTicksMargin);
    }
    
    // y Ticks
    for(int j=0; j<yTicks; j++)
    {
      line(0, -ySpacing*(1+j), range.x, -ySpacing*(1+j));
      float legend = yRealSpacing*(1+j);
      text(legend, -xTicksMargin, -ySpacing*(1+j));
    }
    
  }
}