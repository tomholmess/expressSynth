//
//  Gesture.c
//  maximTest
//
//  Created by Tom Holmes on 22/03/2017.
//
//

#include "Gesture.h"
#include "ofApp.h"
#include "SynthVoice.h"

Gesture::Gesture() {
    
}

void Gesture::setupSerial() {
    adafruitOne.setup(1, 9600);
}

void Gesture::valuesIn() {

    int bufferSz = 16;
    char buffer[bufferSz];
    char* pEnd;
    float xBuf, yBuf;
    
    for(int i = 0; i < bufferSz; i++) {
        
        buffer[i] = (char)adafruitOne.readByte();
        xBuf = strtof(buffer, &pEnd);
        yBuf = strtof(pEnd, NULL);
    
    }
    
    if(xBuf != 0 && yBuf != 0 && xBuf > -20.0 && xBuf < 20.0 && yBuf > -20.0 && yBuf < 20.0) {
        
        xAccel = xBuf;
        yAccel = yBuf;
        adafruitOne.flush();
        
    }
    
}

double Gesture::lerpDifference(float first, float second, int amount) {
    
    double diff;
    if(second != first) {
        diff = second - first;
    } else {
        diff = 0;
    }
    
    float lerpDiff = diff / amount;
    return lerpDiff;
    
}

void Gesture::vectorRecord() {
    
    recordInit.push_back(make_pair(xAccel, yAccel));

}

void Gesture::sineRecord() {
    
    sineInit.push_back(make_pair(xAccel, yAccel));
    
}

void Gesture::arpRecord() {
    
    arpInit.push_back(make_pair(xAccel, yAccel));
    
}

void Gesture::circleRecord() {
    
    circleInit.push_back(make_pair(xAccel, yAccel));
    
}

void Gesture::vectorNormalize(vector< pair<float, float> > vectorIn, vector< pair<float, float> > vectorOut, vector< pair<float, float> > finalVec, int amount) {
    cout << endl;
    cout << endl;
    
//    for(int i = 0; i < record.size(); ++i) {
//        sineDifference = sineDifference + abs(record[i].first - sine[i].first) + abs(record[i].second - sine[i].second);
//        arpDifference = arpDifference + abs(record[i].first - arp[i].first) + abs(record[i].second - arp[i].second);
//        circleDifference = circleDifference + abs(record[i].first - circle[i].first) + abs(record[i].second - circle[i].second);
//    }
//    
//    record.clear();
    
    int vecInSize = vectorIn.size();
    
    for(int i = 0; i < (vecInSize-1); i++) {
        float lerpXAmt = lerpDifference(vectorIn[i].first, vectorIn[i+1].first, amount);
        float lerpYAmt = lerpDifference(vectorIn[i].second, vectorIn[i+1].second, amount);
        for(int j = 0; j < amount; j++) {
            vectorOut.push_back(make_pair(vectorIn[i].first + (j * lerpXAmt), vectorIn[i].second + (j * lerpYAmt)));
        }
    }
    
    for(int i = 0; i < vectorOut.size(); i++) {
        if(i % vectorIn.size() == 0) {
            finalVec.push_back(make_pair(vectorOut[i].first, vectorOut[i].second));
        }
    }
    
    for(int i = 0; i < finalVec.size(); i++) {
 //       cout << finalVec[i].first << " " << finalVec[i].second << endl;
    }
    
}

void Gesture::vectorCompare(vector< pair<float, float> > recordIn, vector< pair<float, float> > COMP1) {
    
    float inOne;
    
    for(int i = 0; i < recordIn.size(); i++) {
        inOne = inOne + abs(recordIn[i].first - COMP1[i].first) + abs(recordIn[i].first - COMP1[i].second);
    }
    
    cout << inOne << endl;
    
}









