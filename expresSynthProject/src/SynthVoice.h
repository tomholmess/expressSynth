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
    maxiOsc VCO1, VCO2, VCO3, VCO4, LFO, Trem, Chorus, arpPhasor;
    maxiDelayline delay, reverb;
    
    double VCO1Out, VCO2Out, VCO3Out, VCO4Out, VCOOut, LFOOut, VCF1Out, VCF2Out, ADSROut, FilterADSROut, TremOut, voiceOut, chorusOut, delayOut, reverbOut, midiNote, frequency;
    
    double cutoff, resonance, LFOSpeed = 1., LFODepth, TremSpeed, TremDepth, PortaSpeed, arpSpeed;
    int waveOne, waveTwo, waveThree, waveFour, VCF1Type, VCF2Type;
    int waveTwoPitch, waveThreePitch, waveFourPitch, arpAddition;
    
    int arpMode;
    bool arpOnOff;
    int numOctaves;
    bool up = true, down = false;
    
    int fifths[21] = {0, 3, 5, 7, 9, 12, 15, 17, 19, 21, 24, 27, 29, 31, 33, 36, 39, 41, 43, 45, 48};
    
    double voicePlay();
    void setEnvelope(double attack, double decay, double sustain, double release);
    void setFilterEnvelope(double attack, double decay, double sustain, double release);
    
    double midiToFrequency(int n);
    
    void setup();
    
    SynthVoice();
};

#endif /* SynthVoice_h */
