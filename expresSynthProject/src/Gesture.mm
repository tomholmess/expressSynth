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


// Setup the serial connection on the 9600 baud.
void Gesture::setupSerial() {
    adafruitOne.setup(1, 9600);
}

void Gesture::valuesIn() {
    
    // I had a lot of help from Mick Grierson on this function, thank you Mick!
    
    // Assign buffer size to 22. This figure is the amount of character being send by the controller, as specified in the Arduino IDE code.
    int bufferSz = 22;
    // Create a char buffer of that size
    char buffer[bufferSz];
    // Create pointers to the end each reading
    char* pEnd;
    char* pEndTwo;
    char* pEndThree;
    float xBuf, yBuf;
    int redBuff, blueBuff;
    
    for(int i = 0; i < bufferSz; i++) {
 
        // Fill up the buffer with the incoming characters
        buffer[i] = (char)adafruitOne.readByte();
        // Split the incoming data into parts, namely X acceleration, Y acceleration and 1 or 0 for blue and red button on/off
        xBuf = strtof(buffer, &pEnd);
        yBuf = strtof(pEnd, &pEndTwo);
        blueBuff = strtof(pEndTwo, &pEndThree);
        redBuff = strtof(pEndThree, NULL);
        
    }
    
    if(xBuf != 0 && yBuf != 0 && xBuf > -30.0 && xBuf < 30.0 && yBuf > -30.0 && yBuf < 30.0) {

        xAccel = 2*xBuf;
        yAccel = yBuf;
        blueButton = blueBuff;
        redButton = redBuff;
        

        
    }
    
    // Flush and drain the buffer to clear it once each reading has been completed.
    adafruitOne.flush();
    adafruitOne.drain();
    
}

void Gesture::buttonOn() {
    
    // The button on/off readings were at times intermittent, giving up to 8 0's when the button was pressed. This would stop the vectors being pushback
    // during gesture recording, giving inaccurate recordings. To stop this I added booleans for pressed and released. Using a counter, when the button is pressed,
    // the boolean is true until 15 0's have been recorded, signalling that the button has actually been released. Setting the gestures to record until a button released
    // boolean is set to true stops the recordings from stopping if a few intermittent 0's accidentally come through.
    if(blueButton == 1) {
        blueCounter += 1;
    }
    
    if(blueCounter == 0) {
        bluePressed = false;
    }
    if(blueCounter > 0) {
        bluePressed = true;
    }
    

    if(redButton == 1) {
        redCounter += 1;
    }
    
    if(redCounter == 0) {
        redPressed = false;
    }
    if(redCounter > 0) {
        redPressed = true;
    }
}

void Gesture::buttonEvent() {
    // This function waits for 15 0's before declaring that a button has been released.
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
            blueCounter = 0;
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
            redCounter = 0;
            redReleased = true;
        }
    }
    
    lastRed = currentRed;
}

// Linear Interpolation function, gives the increments between values given any specified start number, end number and amount of sections.

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

// This function finds the minimum of up to 6 values. 6 is the most gestures to be compared at anyone point.

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

// Push back the vector of pairs.

vector< pair<float, float> > Gesture::shapeRecord(vector< pair<float, float> > shape) {
    
    shape.push_back(make_pair(xAccel, yAccel));
    
    return shape;
    
    shape.clear();
    
}

// Vector normalization function. Takes a vector of pairs of any given amount and returns a vector of pairs of a chosen amount, linearly interpolating between the values to give
// a scaled, time invariant result.

vector< pair<float, float> > Gesture::vectorNormalize(vector< pair<float, float> > vectorIn, int amount) {
    
    // Determine the size of the incoming vector
    int vecInSize = vectorIn.size();
    
    
    vector< pair<float, float> > vecLerp;
    vector< pair<float, float> > finalVec;
    
    // For each value in the incoming vector, take the size of the desired vector and calculate the value of the increments between the consecutive points.
    // Once thats complete, push back a vector of the original pairs of values with the number of increments in between. This gives a vector the length of the original
    // multiplied by the desired sizes. Ie if the incoming vector is 47 pairs of values and we want a vector of 40 pairs, it creates a vector 1880 values, containing the original
    // values and 40 linearly interpolated values inbetween each of the original values.


    for(int i = 0; i < (vecInSize-1); i++) {
        float lerpXAmt = lerpDifference(vectorIn[i].first, vectorIn[i+1].first, amount);
        float lerpYAmt = lerpDifference(vectorIn[i].second, vectorIn[i+1].second, amount);
        for(int j = 0; j < amount; j++) {
            vecLerp.push_back(make_pair(vectorIn[i].first + (j * lerpXAmt), vectorIn[i].second + (j * lerpYAmt)));
        }
    }
    
    // Once we have that vector we can go through the vector of 1880, selecting every 47th pair of values (the size of the original vector) to give us a vector of 40 pairs.
    for(int i = 0; i < vecLerp.size(); i++) {
        if(i % (vecInSize-1) == 0) {
            finalVec.push_back(make_pair(vecLerp[i].first, vecLerp[i].second));
        }
    }
    
    return finalVec;
    
}

vector< pair<float, float> > Gesture::calibrate(vector< pair<float, float> > vecIn) {

    if(bluePressed == true) {
        vecIn = shapeRecord(vecIn);
    }
    
    if(blueReleased == true && vecIn.size() > 7) {
        vecIn = vectorNormalize(vecIn, NUM_VALUES);
        
    }
    
    return vecIn;

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


int Gesture::home() {
    
    // These functions calculates the summed Euclidean distance between all of the points in the vectors that needed to be compared for each section.
    // By totalling the absolute value of the difference between the X and Y values for each of the normalized points between the recorded shape vector and each
    // calibrated, pre-recorded shape vector give you the differences between each, the findminimum then returns the smallest distance, giving you a
    // nearest shape result.
    
    // Each section of the synth has a function, in which is are the calculations and comparisons between the active shapes in that section.
    
    for(int i = 0; i < record.size(); i++) {
        sineDiff += abs(record[i].first - sine[i].first) + abs(record[i].second - sine[i].second);
        triangleDiff += abs(record[i].first - triangle[i].first) + abs(record[i].second - triangle[i].second);
        squareDiff += abs(record[i].first - square[i].first) + abs(record[i].second - square[i].second);
        eightDiff += abs(record[i].first - eight[i].first) + abs(record[i].second - eight[i].second);
        sawDiff += abs(record[i].first - saw[i].first) + abs(record[i].second - saw[i].second);
        FXDiff += abs(record[i].first - FX[i].first) + abs(record[i].second - FX[i].second);
    }
    
    int returnValoo = findMinimum(sineDiff, triangleDiff, squareDiff, eightDiff, sawDiff, FXDiff);
    
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

int Gesture::LFOSelect() {
    
    for(int i = 0; i < record.size(); i++) {
        sineDiff += abs(record[i].first - sine[i].first) + abs(record[i].second - sine[i].second);
        squareDiff += abs(record[i].first - square[i].first) + abs(record[i].second - square[i].second);
        FXDiff += abs(record[i].first - FX[i].first) + abs(record[i].second - FX[i].second);
    }
    
    int returnValoo = findMinimum(sineDiff, squareDiff, FXDiff, 10000, 10000, 10000);
    
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

int Gesture::arpSelect() {
    
    
    
}

int Gesture::arpSelectRed() {
    
}

int Gesture::FXSelect() {
    
}

// Control gesture function. Takes the chosen button and acceleration value, scales the acceleration values and adds/subtracts to the chosen feature in, returning
// the updated value.

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

// Reset all differences and clear the record vector. This function is called after every gesture recognition sequence.

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








