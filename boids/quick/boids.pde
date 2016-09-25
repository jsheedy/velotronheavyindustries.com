int n = 50;
int width=800;
int height=800;

PVector COM(Boid t) {
    PVector acc = new PVector(0,0);
    for (int i = 0; i < n; i = i+1) {
        // calc distance
        Boid other = boids[i];
        if (other == t) {
          continue; 
        }
        PVector diff = PVector.sub(other.position, t.position);
//        float f = 1 / diff.magSq();
        diff.normalize();
//        diff.mult(f);
        acc.add(diff);
    }
    acc.normalize();
    acc.mult(.5);
    return acc;
}
PVector separation(Boid t) {
    PVector acc = new PVector(0,0);
    for (int i = 0; i < n; i = i+1) {
        Boid other = boids[i];
        if (other == t) {
          continue; 
        }
        PVector diff = PVector.sub(t.position, other.position);
        float f = 10 / diff.magSq();
        diff.normalize();
        diff.mult(f);
        acc.add(diff);
    }
    acc.normalize();
    acc.mult(.4);
    return acc;
}
PVector alignment(Boid t) {
    PVector acc = new PVector(0,0);
    for (int i = 0; i < n; i = i+1) {
        // calc distance
        Boid other = boids[i];
        PVector diff = PVector.sub(other.velocity, t.velocity);
//        float f = 1 / diff.magSq();
        diff.normalize();
//        diff.mult(f);
        acc.add(diff);
    }
    acc.normalize();
    acc.mult(.1);
    return acc;
}


class Boid {
    PVector position = new PVector(0,0);
    PVector velocity = new PVector(0,0);
    PVector acc = new PVector(0,0);
    
    Boid() {
    }

//    void bump() {
//       x += random(-6,6)
//       y += random(-6,6)
//    }
    void update() {
//
      position.add(velocity);
      if (position.x <= 0 || position.x >= width) {
        velocity.x *= -1;
      }
      if (position.y <= 0 || position.y >= height) {
        velocity.y *= -1;
      }
      
      PVector com = COM(this);
      PVector sep = separation(this);
      PVector align = alignment(this);
      velocity.add(com);
      velocity.add(sep);
      velocity.add(align);

//      velocity.normalize();
    }


}

Boid[] boids = new Boid[n];

void setup()
{
  size(width, height);
  background(0);
  fill(255);
  stroke(255);
  //noLoop();
    for (int i = 0; i < n; i = i+1) {

      boids[i] = new Boid();
      boids[i].position.x = random(0,width);
      boids[i].position.y = random(0,height);
      boids[i].velocity.x = random(1);
      boids[i].velocity.y = random(1);
    }
    loop();
}

void draw(){

    for (int i = 0; i < n; i = i+1) {
        Boid b = boids[i];
        b.update();
        point(b.position.x, b.position.y);

    }
}

