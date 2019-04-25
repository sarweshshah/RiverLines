//Define particles and how they are moved with Runge–Kutta method of 4th degree.
class Particle {
  float x;
  float y;
  float time; 
  float speed; // speed of the particle
  float radius;
  float r, g, b, opacity;
  float j1, k1, j2, k2, j3, k3, j4, k4;
  
  Particle(float _x, float _y, float _t, float _h) {
    this.x = _x;
    this.y = _y;
    this.time = _t;
    this.radius = random(3, 4);
    this.speed = _h;
    this.opacity = random(199, 200);
    this.r = random(10);
    this.g = random(164, 255);
    this.b = random(255);
  }

  void update() {
    this.k1 = P(this.x, this.y);
    this.j1 = Q(this.x, this.y);
    
    this.k2 = P(this.x + 1/2 * this.speed * this.k1, this.y + 1/2 * this.speed * this.j1);
    this.j2 = Q(this.x + 1/2 * this.speed * this.k1, this.y + 1/2 * this.speed * this.j1);
    
    this.k3 = P(this.x + 1/2 * this.speed * this.k2, this.y + 1/2 * this.speed * this.j2);
    this.j3 = Q(this.x + 1/2 * this.speed * this.k2, this.y + 1/2 * this.speed * this.j2);
    
    this.k4 = P(this.x + this.speed * this.k3, this.y + this.speed * this.j3);
    this.j4 = Q(this.x + this.speed * this.k3, this.y + this.speed * this.j3);
    
    this.x = this.x + this.speed/6 *(this.k1 + 2 * this.k2 + 2 * this.k3 + this.k4);
    this.y = this.y + this.speed/6 *(this.j1 + 2 * this.j2 + 2 * this.j3 + this.j4);
    
    this.time += this.speed;
  }

  void display() {
    fill(this.r, this.b, this.g, this.opacity);
    noStroke();
    ellipse(-this.x, this.y, 2 * this.radius, 2 * this.radius);
  }
}

float Q (float x, float y) { 
  return Strength * ((-2*v*(a*a)*(x+mouseX-width/2)*(y-mouseY+height/2))/((pow( x + mouseX-width/2, 2) + pow( y - mouseY+height/2, 2))*(pow( x + mouseX-width/2, 2)+pow( y - mouseY+height/2, 2))) );
}

float P(float x, float y) { 
  return Strength * ( v - (v*(a*a)*(pow( x + mouseX-width/2, 2)-pow( y - mouseY+height/2, 2)))/((pow( x + mouseX-width/2, 2)+pow( y - mouseY+height/2, 2))*(pow( x + mouseX-width/2, 2)+pow( y - mouseY+height/2, 2)))  );
}
