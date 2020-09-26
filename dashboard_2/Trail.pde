class Trail 
{
  PVector pos;
  PVector[] history;
  int nHistory;
  int index;
  
  Trail(float _x, float _y, int _nHistory)
  {
    pos = new PVector(_x, _y);
    nHistory = _nHistory;
    history = new PVector[nHistory];
    for(int i=0; i<nHistory; i++)
    {
      history[i] = new PVector(pos.x, pos.y);
    }
    index = 0;
  }
  
  void update(float _x, float _y) 
  {
    history[index].set( _x, _y);
    index += 1;
    index %= nHistory;
  }
  
  
  void display()
  {
    int secondToLast = (index+1) % nHistory;
    
    for(int i=0; i<nHistory-1; i++)
    {
      int start = (index + i) % nHistory;
      int end = (secondToLast + i) % nHistory;
      
      float b = map(i, 0, nHistory-2, 255, 0);
      stroke( b );
      line( history[start].x, history[start].y,  history[end].x, history[end].y );
    }
    
  }
}