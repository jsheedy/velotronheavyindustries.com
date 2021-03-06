
//import controlP5.*;

int n = 800;
int width=500;
int height=500;


PVector COM(Boid t) {
  PVector coms = null;
  int count = 0;
  for (int i = 0; i < n; i = i+1) {
    Boid other = boids[i];

    PVector com = new PVector();
    PVector.sub(other.position, t.position, com);
    float mag = com.mag();
    if (mag > n/3.4444) { 
      continue;
    }
    if (coms == null) {
      coms = other.position;
    } else {
      coms.add(other.position);
    }
    count += 1;
    if (count > 2) {
      break;
    }
  }
  if (coms == null ) {
    return null;
  } else {

    coms.div(count);
    PVector diff = PVector.sub(coms, t.position);
    diff.limit(n/2);
    //      line(t.position.x, t.position.y, t.position.x+diff.x, t.position.y +diff.y); 
    return diff;
  }
}
PVector separation(Boid t) {
  PVector acc = new PVector(0, 0);
  for (int i = 0; i < n; i = i+1) {
    Boid other = boids[i];
    PVector diff = PVector.sub(t.position, other.position);
    float mag = diff.mag();
    if (other == t || mag > n/10) {
      continue;
    }
    acc.add(diff);
  }
  acc.limit(2);
  return acc;
}
PVector alignment(Boid t) {
  PVector acc = null;
  int count=0;
  for (int i = 0; i < n; i = i+1) {
    // calc distance
    Boid other = boids[i];
    PVector diff = PVector.add(other.velocity, t.velocity);
    float mag = diff.mag();
    if ((other == t) || (mag > n/5.0)) {
      continue;
    }
    if (acc == null) {
      acc = diff;
    } else {
      acc.add(diff);
      count = count + 1;
      if (count > 4) {
        break;
      }
    }
  }
  if (acc == null) {
    return null;
  } else {

    acc.limit(2);
    return acc;
  }
}


class Boid {
  PVector position = new PVector(0, 0);
  PVector velocity = new PVector(0, 0);

  Boid() {
  }


  void update() {
    position.add(velocity);
    //      
    if (position.x <= 1 || position.x >= width) {
      velocity.x *= -1;
      position.x += velocity.x;
    } else if (position.y <= 0 || position.y >= height) {
      velocity.y *= -1;
      position.y += velocity.y;
    }

    PVector com = COM(this);
    if (com != null) {
      com.mult(.035);
      velocity.add(com);
    }


    PVector sep = separation(this);
    sep.mult(1.4842);
    velocity.add(sep);

    PVector align = alignment(this);
    if (align != null) {
      align.mult(0.7);
      velocity.add(align);
    }
    velocity.limit(10);
    //        line(this.position.x, this.position.y, this.position.x + sep.x, this.position.y + sep.y);
  }
}

Boid[] boids = new Boid[n];

void setup()
{
  size(width, height);
  fill(255);
  stroke(255);
  for (int i = 0; i < n; i = i+1) {

    boids[i] = new Boid();
    boids[i].position.x = random(0, width);
    boids[i].position.y = random(0, height);
    boids[i].velocity.x = random(-1, 1);
    boids[i].velocity.y = random(-1, 1);
  }
  frameRate(30);
  loop();
}

void draw() {
  background(0, 0, 0);
  for (int i = 0; i < n; i = i+1) {
    Boid b = boids[i];
    b.update();
    rect(b.position.x, b.position.y, 2, 2);
  }
}

