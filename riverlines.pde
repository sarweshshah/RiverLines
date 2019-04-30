import codeanticode.syphon.*;
import java.util.List;
import org.openkinect.processing.*;

Kinect2 kinect2;
SyphonServer server;

float kinMinThresh = 900;
float kinMaxThresh = 1940;
PImage img;

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
  fullScreen(P3D);
  //size(400, 400);

  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();

  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);

  background(0);

  //seting up particles
  for (int i = 0; i < max_no_of_particles; i++) {
    float valX = random(-width/2, width/2);
    float valY = random(-height/2, height/2);
    particles.add(new Particle(valX, valY, t, stepTime));
  }

  server = new SyphonServer(this, "RiverLines");
}

void draw() {    
  translate(width/2, height/2);
  //rotate(radians(90));

  img.loadPixels();

  // Get the raw depth as array of integers
  int[] depth = kinect2.getRawDepth();

  float sumX = 0;
  float sumY = 0;
  float totalPixels = 0;

  for (int x = 0; x < kinect2.depthWidth; x++) {
    for (int y = 0; y < kinect2.depthHeight; y++) {      
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];

      if (d > kinMinThresh && d < kinMaxThresh) {
        img.pixels[offset] = color(255, 0, 150);
        sumX += x;
        sumY += y;
        totalPixels++;
      } else {
        img.pixels[offset] = color(51);
      }
    }
  }

  img.updatePixels();
  image(img, 0, 0);

  float avgX = sumX / totalPixels;
  float avgY = sumY / totalPixels;
  float mappedX = 0; 
  float mappedY = 0;

  fill(150, 0, 255);

  if (totalPixels >= 400) {
    mappedX = map(avgX, 0, kinect2.depthWidth, -width/2, width/2);
    mappedY = map(avgY, 0, kinect2.depthHeight, -height/2, height/2);

    ellipse(avgX, avgY, 15, 15);
    ellipse(mappedX, mappedY, 15, 15);
  }

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

  if (mousePressed) {
    a = 210;
  }
}

public void mouseClicked(MouseEvent evt) {
  if (evt.getCount() == 2) {
    a = 0.02;
  }
}
