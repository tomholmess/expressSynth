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
    
    const static int NUM_VALUES = 15;
    
    void setupSerial();
    
    void vectorRecord();
    void sineRecord();
    void arpRecord();
    void circleRecord();
    
    void valuesIn();
    void vectorNormalize(vector< pair<float, float> > vectorIn, vector< pair<float, float> > vectorOut, vector< pair<float, float> > finalVec, int amount);
    
    void vectorCompare(vector< pair<float, float> > recordIn, vector< pair<float, float> > COMP1);
    
    double lerpDifference(float first, float second, int amount);
    
    ofSerial adafruitOne;
    
    float xAccel, yAccel;
    
    maxiOsc timer;
    
    vector< pair<float, float> > recordInit;
    vector< pair<float, float> > sineInit;
    vector< pair<float, float> > arpInit;
    vector< pair<float, float> > circleInit;
    
    vector< pair<float, float> > recordLerp;
    vector< pair<float, float> > sineLerp;
    vector< pair<float, float> > arpLerp;
    vector< pair<float, float> > circleLerp;
    
    vector< pair<float, float> > recordFinal;
    vector< pair<float, float> > sineFinal;
    vector< pair<float, float> > arpFinal;
    vector< pair<float, float> > circleFinal;

    Gesture();
    
};

#endif /* Gesture_h */
