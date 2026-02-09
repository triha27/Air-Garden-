class Flower {
  PVector position;
  float scaleFactor;
  float rotation = 0;
  float alpha = 80;
  String state = "ALIVE";
  int hand;
  int finger;

  float[][] red = {{75, 235, 64, 230},{255, 100, 194, 230}};
  float[][] green = {{255, 73, 255, 55}, {255, 255, 143, 17}};
  float[][] blue = {{255, 84, 107, 205},{ 0, 136, 230, 147}};
  int[][] randomize = {{1, 1, 2, 0},{ 1, 1, 1, 0}};

  Flower(float x, float y, float z, int hand_, int finger_) {
    position = new PVector(x, y);
    scaleFactor = z;
    hand = hand_;
    finger = finger_;
  }

  void release() {
    state = "DYING";
  }

  void update() {
    if (state.equals("ALIVE")) {
      rotation += 0.02;
    }

    if (state.equals("DYING")) {
      scaleFactor += 0.01;
      alpha -= 2;

      if (alpha <= 0) {
        state = "DEAD";
      }
    }
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    scale(scaleFactor);
    System.out.println("hand" + hand);
    System.out.println("finger" + finger);
    for (int i = 10; i < 2000; i += 10) {
      fill((randomize[hand][finger] == 0 ? random(255) : red[hand][finger]), (randomize[hand][finger] == 1 ? random(255): green[hand][finger]), (randomize[hand][finger] == 2? random(255): blue[hand][finger]), alpha);
      noStroke();

      beginShape();
      vertex(0, 0);
      bezierVertex(80, 0, 80, i, i, 75);
      bezierVertex(50, i, i, 25, 30, 20);
      endShape();
      rotate(rotation);
    }

    popMatrix();
  }
}
