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
    
    void audioOut(float * output, int bufferSize, int nChannels);
    
    
    // Sound
    SynthVoice voice[12];
    int bufferSize, sampleRate, initialBufferSize;
    maxiOsc test;
    
    // ML and Gesture Recognition
    Gesture gesture;
 //   int calibrationIndex = 0;

    int blueBuf[8];
    int blueI = 0;
    int blueSum;
    
    // Text and GUI
    Interface interface;
    string section = "title";
    int secMove = 0;
    
    ofSerial adafruit;
    vector<char> bufferIn;

    // Synth Variable Inita
    float ampAttack = 1000, ampRelease = 1000, oscPitch = 1., osc2Pitch = 1., osc3Pitch = 1., osc4Pitch = 1., oscAddSub = 0, filterAttack = 1000., filterRelease = 1000., filterCutoff, filterRes, LFOSpeed, LFODepth, PortaSpeed, TremSpeed, TremDepth, ArpSpeed, ArpOctaves, ChorusSpeed, ChorusDepth, DelayTime, DelayFB, ReverbAmount;
    
    int oscCurrentControl = 1;

    int ampCounter = 0, oscCounter = 0, filterCounter = 0, LFOCounter = 0, PortaCounter = 0, TremCounter = 0, ArpCounter = 0, FXCounter = 0;
    
};



