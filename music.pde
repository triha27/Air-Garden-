import processing.sound.*;

class MusicNote {
  SinOsc[] oscs;
  float baseFreq;
  int hand;
  int finger;
  String state = "ALIVE";
  float amp = 0.0;
  float targetAmp = 0.25;  // Lower target to avoid any clipping
  float[] harmonicRatios = {1.0, 2.0, 3.0, 4.0};
  float[] harmonicAmps = {1.0, 0.5, 0.25, 0.125};

float[][] musicalScale = {
  {261.63, 293.66, 329.63, 392.00},  // C4, D4, E4, G4
  {440.00, 523.25, 587.33, 659.25}   // A4, C5, D5, E5
};

  MusicNote(PApplet app, int hand_, int finger_) {
    oscs = new SinOsc[4];
    hand = hand_;
    finger = finger_;
    baseFreq = musicalScale[hand][finger];

     // Fundamental + overtones

    for( int i = 0; i < oscs.length; i++)
    {
      oscs[i] = new SinOsc(app);
      oscs[i].freq(baseFreq * harmonicRatios[i]);
      oscs[i].amp(0);
      oscs[i].play();
    }
  }

  void update() {
    if (state.equals("ALIVE")) {
      if (amp < targetAmp) {
        amp += 0.01;  // Slower, smoother attack
        if (amp > targetAmp) {
          amp = targetAmp;  // Cap it exactly once
        }
      }
    }

    if (state.equals("DYING")) {
      amp -= 0.01;  
      if (amp <= 0) {
        amp = 0;
        state = "DEAD";
        for (SinOsc osc : oscs) {
          osc.stop();
        }
      }
    }

    
    for (int i = 0; i < oscs.length; i++) {
      oscs[i].amp(amp * harmonicAmps[i] / 2.0);
    }
  }

  void release() {
    state = "DYING";
  }

  void stop() {
  for (SinOsc osc : oscs) {
      osc.stop();
    }
  }
}