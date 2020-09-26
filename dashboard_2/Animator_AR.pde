class Animator_AR
{
  int t1, t2; // t attack, t release
  int dt;     // delta time
  int st;     // start time

  // states
  final int QUIET   = -1;
  final int ATTACK  =  0;
  final int RELEASE =  1;
  int state;

  float y;

  Animator_AR ( int t_1, int t_2 ) {
    t1 = t_1>0.0?t_1:10;
    t2 = t_2>0.0?t_2:500;
    state = QUIET;
    //println("t1: " + t1 + "; t2: " + t2 + ";");
  }

  void update() {
    //println( state );
    if( state == ATTACK ) {
      dt = millis() - st;
      y = (1.0*dt)/t1;
      if( y > 1.0 ) {
        y = 1.0;
        st = millis();
        state = RELEASE;
      }
    } else if ( state == RELEASE ) {
      dt = millis() - st;
      y = 1.0 - (1.0*dt/t2);
      if( y < 0.0 ) {
        y = 0.0;
        state = QUIET;
      }
    }
  }

  void trigger() {
    st = millis();
    state = ATTACK;
  }

  float getY() {
    return y;
  }
}