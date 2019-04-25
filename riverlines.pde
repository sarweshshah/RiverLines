int Strength = 40;
int v = 40;
float a = 0.01;
int max_no_of_particles = 800;

int t = 0;
float stepTime = 0.001;
ArrayList <Particle> particles = new ArrayList<Particle> ();
int currentParticle = 0;

boolean isTracing = true;

void setup() {
  fullScreen();
  //size(400, 400);
  
  background(0);

  //seting up particles
  for (int i = 0; i < max_no_of_particles; i++) {
    float valX = random(-width/2, width/2);
    float valY = random(-height/2, height/2);
    particles.add(new Particle(valX, valY, t, stepTime));
  }
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

  t += stepTime;

  for (int i = 0; i < particles.size(); i++) {
    Particle p = particles.get(i);
    p.update();
    p.display();

    if ( p.x > width/2 || p.y > height/2 || p.x < -width/2 || p.y < -height/2 || // particle goes out of the screen
      (pow(p.x + mouseX/2 - width/2, 2) + pow(p.y - mouseY/2 + height/2, 2)) < a) {
      particles.remove(i);
      currentParticle--;
      particles.add(new Particle(-width/2, random(-height/2, height/2), t, stepTime) );
    }
  }

  fill(60);
  stroke(0);

  if (mousePressed && a < 210) {
    a +=1;
  }
}

public void mouseClicked(MouseEvent evt) {
  if (evt.getCount() == 2)
  doubleClicked();
}

void doubleClicked() {
  if (a > 10) {
    a = 0.02;
  }
}
