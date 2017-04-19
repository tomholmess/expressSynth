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
    
    int bufferSz = 22;
    char buffer[bufferSz];
    char* pEnd;
    char* pEndTwo;
    char* pEndThree;
    float xBuf, yBuf;
    int redBuff, blueBuff;
    
    for(int i = 0; i < bufferSz; i++) {
 
        buffer[i] = (char)adafruitOne.readByte();
        xBuf = strtof(buffer, &pEnd);
        yBuf = strtof(pEnd, &pEndTwo);
        blueBuff = strtof(pEndTwo, &pEndThree);
        redBuff = strtof(pEndThree, NULL);
        
    }
    
    if(xBuf != 0 && yBuf != 0 && xBuf > -30.0 && xBuf < 30.0 && yBuf > -30.0 && yBuf < 30.0) {

        xAccel = xBuf;
        yAccel = yBuf;
        blueButton = blueBuff;
        redButton = redBuff;
        

        
    }
    
    adafruitOne.flush();
    adafruitOne.drain();
    
}

void Gesture::buttonEvent() {
    
    blueBuf[blueI] = blueButton;
    blueI += 1;
    
    if(blueI == 15) {
        blueI = 0;
    }
    
    blueSum = blueBuf[0] + blueBuf[1] + blueBuf[2] + blueBuf[3] + blueBuf[4] + blueBuf[5] + blueBuf[6] + blueBuf[7] + blueBuf[8] + blueBuf[9] + blueBuf[10] + blueBuf[11] + blueBuf[12] + blueBuf[13] + blueBuf[14];
    
    blueReleased = false;
    
    currentBlue = blueSum;
    
    if(lastBlue != currentBlue) {
        if(currentBlue == 0) {
            blueReleased = true;
        }
    }

    lastBlue = currentBlue;

    redBuf[redI] = redButton;
    redI += 1;
    
    if(redI == 15) {
        redI = 0;
    }
    
    redSum = redBuf[0] + redBuf[1] + redBuf[2] + redBuf[3] + redBuf[4] + redBuf[5] + redBuf[6] + redBuf[7] + redBuf[8] + redBuf[9] + redBuf[10] + redBuf[11] + redBuf[12] + redBuf[13] + redBuf[14];
    
    redReleased = false;
    
    currentRed = redSum;
    
    if(lastRed != currentRed) {
        if(currentRed == 0) {
            redReleased = true;
        }
    }
    
    lastRed = currentRed;
}

bool Gesture::doublePress() {
    
    if(blueButton == 1 || redButton == 1) {
        doubleSig += 1;
    }
    if(blueReleased == true || redReleased == true) {
        if(doubleSig < 3) {
            doubleOn = true;
        }
    }
    doubleSig = 0;
    
    if(doubleOn == true) {
        
        if(blueButton == 1 || redButton == 1) {
            doubleSig += 1;
        }
        if(blueReleased == true || redReleased == true) {
            if(doubleSig < 3) {
                return true;
                cout << "boom" << endl;
            } else {
                return false;
            }
        }
    
    }
    
    doubleSig = 0;
    doubleOn = false;

    
}

float Gesture::lerpDifference(float first, float second, int amount) {
    
    float diff;
    if(second != first) {
        diff = second - first;
    } else {
        diff = 0;
    }
    
    float lerpDiff = diff / amount;
    return lerpDiff;
    
}

int Gesture::findMinimum(float in1, float in2, float in3, float in4, float in5, float in6) {
    int returnVal;
    
    if(in1 < in2 && in1 < in3 && in1 < in4 && in1 < in5 && in1 < in6) {
        returnVal = 1;
    }
    if(in2 < in1 && in2 < in3 && in2 < in4 && in2 < in5 && in2 < in6) {
        returnVal = 2;
    }
    if(in3 < in1 && in3 < in2 && in3 < in4 && in3 < in5 && in3 < in6) {
        returnVal = 3;
    }
    if(in4 < in1 && in4 < in2 && in4 < in3 && in4 < in5 && in4 < in6) {
        returnVal = 4;
    }
    if(in5 < in1 && in5 < in2 && in5 < in3 && in5 < in4 && in5 < in6) {
        returnVal = 5;
    }
    if(in6 < in1 && in6 < in2 && in6 < in3 && in6 < in4 && in6 < in5) {
        returnVal = 6;
    }
    
    return returnVal;
    
}

vector< pair<float, float> > Gesture::shapeRecord(vector< pair<float, float> > shape) {
    
    shape.push_back(make_pair(xAccel, yAccel));
    
    return shape;
    
    shape.clear();
    
}

vector< pair<float, float> > Gesture::vectorNormalize(vector< pair<float, float> > vectorIn, int amount) {
    
    int vecInSize = vectorIn.size();
    
    vector< pair<float, float> > vecLerp;
    vector< pair<float, float> > finalVec;
    
    for(int i = 0; i < (vecInSize-1); i++) {
        float lerpXAmt = lerpDifference(vectorIn[i].first, vectorIn[i+1].first, amount);
        float lerpYAmt = lerpDifference(vectorIn[i].second, vectorIn[i+1].second, amount);
        for(int j = 0; j < amount; j++) {
            vecLerp.push_back(make_pair(vectorIn[i].first + (j * lerpXAmt), vectorIn[i].second + (j * lerpYAmt)));
        }
    }
    
    for(int i = 0; i < vecLerp.size(); i++) {
        if(i % (vecInSize-1) == 0) {
            finalVec.push_back(make_pair(vecLerp[i].first, vecLerp[i].second));
        }
    }
    
    return finalVec;
    
}

vector< pair<float, float> > Gesture::calibrate(vector< pair<float, float> > vecIn) {

    if(blueButton == 1) {
        vecIn = shapeRecord(vecIn);
    }
    
    if(blueReleased == true && vecIn.size() > 7) {
        vecIn = vectorNormalize(vecIn, NUM_VALUES);
        
    }
    
    return vecIn;

}



int Gesture::title() {
    
}

int Gesture::pairing() {
    
}

void Gesture::calibration() {
    
    if(calibrationIndex == 1) {
        sine = calibrate(sine);
    } else if (calibrationIndex == 2) {
        triangle = calibrate(triangle);
    } else if (calibrationIndex == 3) {
        square = calibrate(square);
    } else if (calibrationIndex == 4) {
        saw = calibrate(saw);
    } else if (calibrationIndex == 5) {
        arp = calibrate(arp);
    } else if (calibrationIndex == 6) {
        eight = calibrate(eight);
    } else if (calibrationIndex == 7) {
        FX = calibrate(FX);
    } else if (calibrationIndex == 8) {
        lineUp = calibrate(lineUp);
    } else if (calibrationIndex == 9) {
        lineDown = calibrate(lineDown);
    }
    
}

int Gesture::testing() {
    
    for(int i = 0; i < record.size(); i++) {
        sineDiff += abs(record[i].first - sine[i].first) + abs(record[i].second - sine[i].second);
        arpDiff += abs(record[i].first - arp[i].first) + abs(record[i].second - arp[i].second);
        squareDiff += abs(record[i].first - square[i].first) + abs(record[i].second - square[i].second);
        triangleDiff += abs(record[i].first - triangle[i].first) + abs(record[i].second - triangle[i].second);
        sawDiff += abs(record[i].first - saw[i].first) + abs(record[i].second - saw[i].second);
        FXDiff += abs(record[i].first - FX[i].first) + abs(record[i].second - FX[i].second);
        eightDiff += abs(record[i].first - eight[i].first) + abs(record[i].second - eight[i].second);
        luDiff += abs(record[i].first - lineUp[i].first) + abs(record[i].second - lineUp[i].second);
        ldDiff += abs(record[i].first - lineDown[i].first) + abs(record[i].second - lineDown[i].second);
    }
}

int Gesture::home() {
    
    
    for(int i = 0; i < record.size(); i++) {
        sineDiff += abs(record[i].first - sine[i].first) + abs(record[i].second - sine[i].second);
        triangleDiff += abs(record[i].first - triangle[i].first) + abs(record[i].second - triangle[i].second);
        squareDiff += abs(record[i].first - square[i].first) + abs(record[i].second - square[i].second);
        eightDiff += abs(record[i].first - eight[i].first) + abs(record[i].second - eight[i].second);
        arpDiff += abs(record[i].first - arp[i].first) + abs(record[i].second - arp[i].second);
        FXDiff += abs(record[i].first - FX[i].first) + abs(record[i].second - FX[i].second);
    }
    
    int returnValoo = findMinimum(sineDiff, triangleDiff, squareDiff, eightDiff, arpDiff, FXDiff);
    
    return returnValoo;
    
    returnValoo = 0;
    
}

int Gesture::oscSelect() {
    
    for(int i = 0; i < record.size(); i++) {
        sineDiff += abs(record[i].first - sine[i].first) + abs(record[i].second - sine[i].second);
        triangleDiff += abs(record[i].first - triangle[i].first) + abs(record[i].second - triangle[i].second);
        squareDiff += abs(record[i].first - square[i].first) + abs(record[i].second - square[i].second);
        sawDiff += abs(record[i].first - saw[i].first) + abs(record[i].second - saw[i].second);
        eightDiff += abs(record[i].first - eight[i].first) + abs(record[i].second - eight[i].second);
    }
    
    int returnValoo = findMinimum(sineDiff, triangleDiff, squareDiff, sawDiff, eightDiff, 3000000000);
    
    return returnValoo;
    
    returnValoo = 0;
    
}

void Gesture::oscControl() {
    
    
    
}

void Gesture::envelopeControl() {
    
}

int Gesture::filterSelect() {
    
    for(int i = 0; i < record.size(); i++) {
        luDiff += abs(record[i].first - lineUp[i].first) + abs(record[i].second - lineUp[i].first);
        ldDiff += abs(record[i].first - lineDown[i].first) + abs(record[i].second - lineDown[i].first);
    }
    
    int returnValoo = findMinimum(luDiff, ldDiff, 10000, 10000, 10000, 10000);
    
    return returnValoo;
    
    returnValoo = 0;
    
}

int Gesture::filterSelectRed() {
    
    for(int i = 0; i < record.size(); i++) {
        triangleDiff += abs(record[i].first - triangle[i].first) + abs(record[i].second - triangle[i].second);
        FXDiff += abs(record[i].first - FX[i].first) + abs(record[i].second - FX[i].second);
        sineDiff += abs(record[i].first - sine[i].first) + abs(record[i].second - sine[i].second);
    }
    
    int returnValoo = findMinimum(triangleDiff, FXDiff, sineDiff, 10000, 10000, 10000);
    
    return returnValoo;
    
    returnValoo = 0;
    
}

void Gesture::filterControl() {
    
}

int Gesture::LFOSelect() {
    
    for(int i = 0; i < record.size(); i++) {
        sineDiff += abs(record[i].first - sine[i].first) + abs(record[i].second - sine[i].second);
        FXDiff += abs(record[i].first - FX[i].first) + abs(record[i].second - FX[i].second);
    }
    
    int returnValoo = findMinimum(sineDiff, FXDiff, 10000, 10000, 10000, 10000);
    
    return returnValoo;
    
    returnValoo = 0;
    
}

int Gesture::LFOSelectRed() {
    
    for(int i = 0; i < record.size(); i++) {
        arpDiff += abs(record[i].first - arp[i].first) + abs(record[i].second - arp[i].second);
    }
    
    int returnValoo = findMinimum(arpDiff, 10000, 10000, 10000, 10000, 10000);
    
    return returnValoo;
    
    returnValoo = 0;
    
    
}

void Gesture::LFOControl() {
    
}

void Gesture::portaControl() {
    
}

void Gesture::tremControl() {
    
}

int Gesture::arpSelect() {
    
}

void Gesture::arpControl() {
    
}

int Gesture::FXSelect() {
    
}

void Gesture::chorusControl() {
    
}

void Gesture::delayControl() {
    
}

void Gesture::reverbControl() {
    
}

double Gesture::control(double featureIn, int buttonIn, double valueIn, double lowerThres, double upperThres, float scale) {
    
    if(buttonIn != 0) {
        
        if(valueIn < -5) {
            featureIn -= (2*abs(valueIn)*scale);
        }
        
        if(valueIn > 5) {
            featureIn += (2*abs(valueIn)*scale);
        }
    }
    
    if(featureIn < lowerThres) {
        featureIn = lowerThres;
    }
    if(featureIn > upperThres) {
        featureIn = upperThres;
    }
    
    return featureIn;
    
}

void Gesture::clearEverything() {
    
    sineDiff = 0.0;
    squareDiff = 0.0;
    triangleDiff = 0.0;
    FXDiff = 0.0;
    luDiff = 0.0;
    ldDiff = 0.0;
    bandpassDiff = 0.0;
    eightDiff = 0.0;
    arpDiff = 0.0;
    sawDiff = 0.0;
    circleDiff = 0.0;
    record.clear();
    
}








