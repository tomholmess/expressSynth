//
//  SynthVoice.hpp
//  maximTest
//
//  Created by Tom Holmes on 27/02/2017.
//
//

#pragma once

#ifndef SynthVoice_h
#define SynthVoice_h

#include "ofMain.h"
#include "ofxMaxim.h"

class SynthVoice {
    
public:
    
    maxiEnv ADSR, filterADSR;
    maxiFilter VCF1, VCF2;
    maxiOsc VCO1, VCO2, VCO3, VCO4, LFO, Trem;
    
    double VCO1Out, VCO2Out, VCO3Out, VCO4Out, VCOOut, LFOOut, VCF1Out, VCF2Out, ADSROut, TremOut, pitch, voiceOut;
    
    double A, D, S, R, cutoff, resonance, filterA, filterD, filterS, filterR, LFOSpeed = 1., LFODepth, TremSpeed, TremDepth;
    int waveOne, waveTwo, waveThree, waveFour, VCF1Type, VCF2Type;
    int waveTwoPitch, waveThreePitch, waveFourPitch;
    
    double voicePlay();
    void setEnvelope(double attack, double decay, double sustain, double release);
    void setup();
    
    SynthVoice();
};

#endif /* SynthVoice_h */
