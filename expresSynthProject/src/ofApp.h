#pragma once

#include "ofMain.h"
#include "ofxMaxim.h"
#include "SynthVoice.h"
#include "Interface.h"
#include "Gesture.h"
#include "ofxMidi.h"


class ofApp : public ofBaseApp{
    
public:
    void setup();
    void update();
    void draw();
    void drawTitles();
    
    void keyPressed(int key);
    void keyReleased(int key);
    void mouseMoved(int x, int y );
    void mouseDragged(int x, int y, int button);
    void mousePressed(int x, int y, int button);
    void mouseReleased(int x, int y, int button);
    void mouseEntered(int x, int y);
    void mouseExited(int x, int y);
    void windowResized(int w, int h);
    void dragEvent(ofDragInfo dragInfo);
    void gotMessage(ofMessage msg);
    
    void gestureSynthLink();
    void displayCurrentSettings();
    void setupStrings();
    
    void audioOut(float * output, int bufferSize, int nChannels);
    
    
    // Sound
    SynthVoice voice[12];
    int bufferSize, sampleRate, initialBufferSize;
    bool patternOn = false;
    maxiOsc patternMaker;
    int patternCount;
    
    // ML and Gesture Recognition
    Gesture gesture;
    int calibrationIndex = 1;

    
    int blueBuf[8];
    int blueI = 0;
    int blueSum;
    
    // Text and GUI
    Interface interface;
    string section = "title";
    int secMove = 0;
    string osc1type, osc2type, osc3type, osc4type, osc2semi, osc3semi, osc4semi, ampAttck, ampRelse, filterTyp, cutoff, res, filterAttck, filterRlse, filterSstn, lfospd, lfodpth, portaspd, portadpth, tremspd, tremdpth, arptyp, arpspd, arpoctves, chorusspd, chorusdpth, delaytme, delayfb, reverbamt;
    
    ofSerial adafruit;
    vector<char> bufferIn;

    // Synth Variable Inits
    float ampAttack = 1000, ampRelease = 1000, oscPitch = 0., osc2Pitch = 0., osc3Pitch = 0., osc4Pitch = 0., oscAdd = 0, oscSub = 0, filterAttack = 1000., filterRelease = 1000., filterSustain = 0.9, filterCutoff = 3000, filterRes = 10, LFOSpeed = 0., LFODepth = 0., PortaSpeed = 0., TremSpeed = 0., TremDepth = 0., ArpSpeed = 0., ArpOctaves = 0., ChorusSpeed, ChorusDepth, DelayTime, DelayFB, ReverbAmount;
    
    int oscCurrentControl = 1;

    int ampCounter = 0, oscCounter = 0, filterCounter = 0, LFOCounter = 0, PortaCounter = 0, TremCounter = 0, ArpCounter = 0, FXCounter = 0;
    
};



