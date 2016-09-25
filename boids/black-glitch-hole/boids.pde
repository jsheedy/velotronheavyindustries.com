int n = 500;
int width=500;
int height=500;

PVector COM(Boid t) {
    PVector com = new PVector(0,0);
    int count = 0;
    for (int i = 0; i < n; i = i+1) {
        Boid other = boids[i];
        if (other == t) {
          continue; 
        }
        PVector diff = PVector.sub(other.position, t.position);
//        if (diff.mag() < width/4) {
          com.add(other.position);
          count += 1;
//        }
    }
    com.div(count);
    return com;
}
PVector separation(Boid t) {
    PVector acc = new PVector(0,0);
    for (int i = 0; i < n; i = i+1) {
        Boid other = boids[i];
        if (other == t) {
          continue; 
        }
        PVector diff = PVector.sub(t.position, other.position);
//        if (diff.mag() < width/2) {
          diff.mult(1/diff.mag());
          acc.add(diff);
//        }
    }
    acc.limit(10);
    return acc;
}
PVector alignment(Boid t) {
    PVector acc = new PVector(0,0);
    for (int i = 0; i < n; i = i+1) {
        // calc distance
        Boid other = boids[i];
        PVector diff = PVector.sub(other.velocity, t.velocity);
        if ((other == t)) {
          continue; 
        }
        acc.add(diff);
    }
    acc.limit(10);
    return acc;
}


class Boid {
    PVector position = new PVector(0,0);
    PVector velocity = new PVector(0,0);
    PVector acc = new PVector(0,0);
    
    Boid() {
    }


    void update() {
      position.add(velocity);
      
      if (position.x <= 1 || position.x >= width) {
        velocity.x *= -1;
        position.x += velocity.x;
      }
      else if (position.y <= 0 || position.y >= height) {
        velocity.y *= -1;
        position.y += velocity.y;
      }

        PVector com = COM(this);
        PVector diff = PVector.sub(com, this.position);
        PVector sep = separation(this);
        PVector align = alignment(this);
        
//        diff.mult(4.0 * mouseX / width);
//        sep.mult(4.0 * mouseY / height);
//        align.mult(4.0 * mouseY / height);
sep.mult(.05);
align.mult(5);
diff.limit(5);

   velocity.add(diff);
        velocity.add(sep);
        velocity.add(align);
//        velocity.normalize();
          velocity.limit(10);
      
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
    background(0,0,0);
    for (int i = 0; i < n; i = i+1) {
        Boid b = boids[i];
        b.update();
//        point(b.position.x, b.position.y);
        rect(b.position.x, b.position.y, 2,2);

    }
}

