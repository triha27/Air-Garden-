import oscP5.*;
import netP5.*;


OscP5 osc;
float[][] note_x= new float [2][4];
float[][] note_y = new float [2][4];
int[][] pressed = new int [2][4];
Flower[][] flowers = new Flower[2][4];
MusicNote[][] musicNotes = new MusicNote[2][4];

void setup() {
  size(1020, 1080);
  osc = new OscP5(this, 8000);
  background(0);
  for ( int i = 0; i < 2; i++)
  {
    for(int j = 0; j < 4; j++)
    {
    note_x[i][j] = -1;
    note_y[i][j] = -1;
    pressed[i][j] = 0;
    }
  }
}

void draw() {
  background(0);

  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 4; j++) {
      Flower currentFlower = flowers[i][j];
      MusicNote currentNote = musicNotes[i][j]; 

      if (currentFlower != null) {
        currentFlower.update();
        currentFlower.display();

        if (currentFlower.state.equals("DEAD")) {
          flowers[i][j] = null;
        }
      }

      if(currentNote != null)
      {
        currentNote.update();

        if(currentNote.state.equals("DEAD"))
        {
          musicNotes[i][j] = null;
        }
      }
    }
  }
}


void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/pinch")) {
    int hand = msg.get(0).intValue();
    int finger = msg.get(1).intValue();
    int isPressed = msg.get(2).intValue();
    float x = msg.get(3).floatValue() * width;
    float y = msg.get(4).floatValue() * height;
    float z= msg.get(5).floatValue();

    if (isPressed == 1 && flowers[hand][finger] == null) {
      flowers[hand][finger] = new Flower(x, y, z, hand, finger);
    }

    if (isPressed == 0 && flowers[hand][finger] != null) {
      flowers[hand][finger].release();
    }

    if(isPressed == 1 && musicNotes[hand][finger] == null)
    {
      musicNotes[hand][finger] = new MusicNote(this, hand, finger);
      musicNotes[hand][finger].update();
    }
    if(isPressed == 0 && musicNotes[hand][finger] != null)
    {
      musicNotes[hand][finger].release();
    }
  }
}


