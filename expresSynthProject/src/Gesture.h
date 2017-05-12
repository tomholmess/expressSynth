//
//  Interface.hpp
//  maximTest
//
//  Created by Tom Holmes on 16/03/2017.
//
//

#pragma once

#ifndef Gesture_h
#define Gesture_h

#include "ofMain.h"
#include "ofxMaxim.h"

class Gesture {
    
public:
    
    int NUM_VALUES = 50;
    
    void setupSerial();
    ofSerial adafruitOne;
    float xAccel, yAccel;
    int redButton, blueButton;
    int lastBlue, currentBlue, lastRed, currentRed;
    
    int blueBuf[15];
    int blueI = 0;
    int blueSum = 0;
    
    int redBuf[15];
    int redI = 0;
    int redSum;
    
    int blueCounter = 0;
    int redCounter = 0;
    
    bool bluePressed = false, blueReleased = false, redPressed = false, redReleased = false;
    
    int calibrationIndex = 1;
    
    double control(double featureIn, int buttonIn, double valueIn, double lowerThres, double upperThres, float scale);
    
    void valuesIn();
    
    void buttonOn();
    
    void buttonEvent();


    vector< pair<float, float> > calibrate(vector< pair<float, float> > vecIn);
    
    vector< pair<float, float> > shapeRecord(vector< pair<float, float> > shape);
    
    vector< pair<float, float> > vectorNormalize(vector< pair<float, float> > vectorIn, int amount);
    
    float lerpDifference(float first, float second, int amount);
    
    int findMinimum(float in1, float in2, float in3, float in4, float in5, float in6);
    
    void clearEverything();
    
    float sineDiff, arpDiff, circleDiff, squareDiff, triangleDiff, sawDiff, FXDiff, bandpassDiff, eightDiff, luDiff, ldDiff;
    
    
    
    maxiOsc timer;
    
    vector< pair<float, float> > record;
    
    vector< pair<float, float> > sine;
    vector< pair<float, float> > arp;
    vector< pair<float, float> > square;
    vector< pair<float, float> > triangle;
    vector< pair<float, float> > saw;
    vector< pair<float, float> > FX;
    vector< pair<float, float> > eight;
    vector< pair<float, float> > lineUp;
    vector< pair<float, float> > lineDown;
        
//    int testing();
    
    void calibration();
    int home();
    int oscSelect();
    int filterSelect();
    int filterSelectRed();
    int LFOSelect();
    int LFOSelectRed();
    int arpSelect();
    int arpSelectRed();
    int FXSelect();
    
    Gesture();
    
};

#endif /* Gesture_h */
