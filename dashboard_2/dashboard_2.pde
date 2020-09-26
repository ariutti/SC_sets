import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

PFont f;
float size = 40;

Scrolling loudness;
Cake chroma;
ParticleSystem onset;
Lissajous flatness;
LogCursor centroid;


// SETUP ///////////////////////////////////////////////////////
void setup() 
{
  size(700,600);
  frameRate(25);
  
  // start oscP5, listening for incoming messages at port 12000 
  oscP5 = new OscP5(this, 15100);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("192.168.1.7", 13000);
  
  f = createFont("Courier", 24);
  textFont(f);
  
  //Scrolling: x, y, w, h, history, xTicks, yTicks
  loudness = new Scrolling(0,0, 700, 200, 60, 100, 5, 4);
  // Chroma: x, y, size
  chroma = new Cake(0, 200, 400);
  // Lissajous: x, y, size, trail dimension
  flatness = new Lissajous(400, 200, 200, 25);
  // ParticleSystem
  onset = new ParticleSystem(400, 400, 200 );
  //LogCursor: x, y, w, h, linMin, linMax, logMin, logMax 
  centroid = new LogCursor(600, 200,100, 400, 0.0, 1.0, 20, 24000 );
}


// DRAW ////////////////////////////////////////////////////////
void draw() 
{
  background(255);

  // updates
  onset.update();
  flatness.update();
  chroma.update();
  centroid.update();
 
  // displays
  loudness.display();
  chroma.display();
  flatness.display();
  onset.display();
  centroid.display();
}

void mousePressed() 
{
  onset.generate();
}

// OSC EVENT ///////////////////////////////////////////////////
void oscEvent(OscMessage theOscMessage) 
{
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //print(" typetag: "+theOscMessage.typetag());
  //println(" timetag: "+theOscMessage.timetag());
  //println( " - " + theOscMessage.get(0).floatValue() );
  float v = 0.0;
  int on = 5;
  if( theOscMessage.checkTypetag("f") ) {
    v = theOscMessage.get(0).floatValue();
  } else if (theOscMessage.checkTypetag("i")) {
    on = theOscMessage.get(0).intValue();
  }
  
  if(      theOscMessage.checkAddrPattern("/debug/C")==true) {
    chroma.newValue( 0, v );
  }
  else if (theOscMessage.checkAddrPattern("/debug/C#")==true) {
    chroma.newValue( 1, v );
  }
  else if (theOscMessage.checkAddrPattern("/debug/D")==true) {
    chroma.newValue( 2, v );
  }
  else if (theOscMessage.checkAddrPattern("/debug/D#")==true) {
    chroma.newValue( 3, v );
  }
  else if (theOscMessage.checkAddrPattern("/debug/E")==true) {
    chroma.newValue( 4, v );
  }
  else if (theOscMessage.checkAddrPattern("/debug/F")==true) {
    chroma.newValue( 5, v );
  }
  else if (theOscMessage.checkAddrPattern("/debug/G")==true) {
    chroma.newValue( 6, v );
  }
  else if (theOscMessage.checkAddrPattern("/debug/G#")==true) {
    chroma.newValue( 7, v );
  }
  else if (theOscMessage.checkAddrPattern("/debug/A")==true) {
    chroma.newValue( 8, v );
  }
  else if (theOscMessage.checkAddrPattern("/debug/A#")==true) {
    chroma.newValue( 9, v );
  }
  else if (theOscMessage.checkAddrPattern("/debug/G")==true) {
    chroma.newValue( 10, v );
  }
  else if (theOscMessage.checkAddrPattern("/debug/G#")==true) {
    chroma.newValue( 11, v );
  }
  else if (theOscMessage.checkAddrPattern("/debug/flat")==true) {
    flatness.changeFa( v );
  }
  else if (theOscMessage.checkAddrPattern("/debug/freq")==true) {
    //freq.changeValue( v );
  }
  //else if (theOscMessage.checkAddrPattern("/debug/hasFreq")==true) {
  //  hasFreq.changeValue( v );
  //}
  else if (theOscMessage.checkAddrPattern("/debug/centroid")==true) {
    centroid.changeValue( v );
  }
  else if (theOscMessage.checkAddrPattern("/debug/loud")==true) {
    loudness.update( v );
  }
  else if (theOscMessage.checkAddrPattern("/debug/onset")==true) {
    if( on == 1) {
      //println("onset: " + on);
      onset.generate();
    }
  }
}
