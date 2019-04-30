float a = 0.01;
int max_no_of_particles = 800;

float stepTime = 0.001;
ArrayList <Particle> particles = new ArrayList<Particle> ();
int currentParticle = 0;
boolean isTracing = true;

KinectController kinectController;

void setup() {
  fullScreen(P3D);
  background(0);

  //seting up particles
  for (int i = 0; i < max_no_of_particles; i++) {
    float valX = random(-width/2, width/2);
    float valY = random(-height/2, height/2);
    particles.add(new Particle(valX, valY, stepTime));
  }

  kinectController = new KinectController(false); // Change boolean to hide/show Kinect window
  noCursor();
}

void draw() {    
  translate(width/2, height/2);

  if (isTracing == true) {
    fill(0, 6);
  } else {
    fill(0, 100);
  }

  stroke(0);
  strokeWeight(2);
  rect(-width/2, -height/2, width, height);

  for (int i = 0; i < particles.size(); i++) {
    Particle p = particles.get(i);
    p.update();
    p.display();

    if ( p.x > width/2 || p.y > height/2 || p.x < -width/2 || p.y < -height/2 || // particle goes out of the screen
      (pow(p.x + kinectController.mappedX/2 - width/2, 2) + pow(p.y - kinectController.mappedY/2 + height/2, 2)) < a) {
      particles.remove(i);
      currentParticle--;
      particles.add(new Particle(-width/2, random(-height/2, height/2), stepTime) );
    }
  }

  fill(60);
  stroke(0);

  if (mousePressed) {
    a = 210;
  }

  kinectController.update();
}

public void mouseClicked(MouseEvent evt) {
  if (evt.getCount() == 2) {
    a = 0.02;
  }
}

float Q (float x, float y) {
  float mappedX = kinectController.mappedX;
  float mappedY = kinectController.mappedY;
  return fieldStrength * ((-2 * (a * a) * (x + mappedX - width/2) * (y - mappedY + height/2))
    / pow((pow(x + mappedX - width/2, 2) + pow(y - mappedY + height/2, 2)), 2));
}

float P(float x, float y) {
  float mappedX = kinectController.mappedX;
  float mappedY = kinectController.mappedY;
  return fieldStrength * (1 - ((a*a) * (pow(x + mappedX - width/2, 2) - pow(y - mappedY + height/2, 2)))
    / pow((pow(x + mappedX - width/2, 2) + pow(y - mappedY + height/2, 2)), 2));
}
