//
//  SynthVoice.cpp
//  maximTest
//
//  Created by Tom Holmes on 27/02/2017.
//
//

#include "synthvoice.h"

SynthVoice::SynthVoice(){
    
}

void SynthVoice::setup() {
    cutoff = 0.7;
    resonance = 5.;
    LFOSpeed = 0;
    LFODepth = 0.;
    TremSpeed = 2.;
    TremDepth = 0;
    waveOne = 0;
    waveTwo = 5;
    waveThree = 5;
    waveFour = 5;
    VCF1Type = 3;
    waveTwoPitch = 1;
    waveThreePitch = 1;
    waveFourPitch = 1;
}

void SynthVoice::setEnvelope(double attack, double decay, double sustain, double release) {
    ADSR.setAttack(attack);
    ADSR.setDecay(decay);
    ADSR.setSustain(sustain);
    ADSR.setRelease(release);
}

void SynthVoice::setFilterEnvelope(double attack, double decay, double sustain, double release) {
    filterADSR.setAttack(attack);
    filterADSR.setDecay(decay);
    filterADSR.setSustain(sustain);
    filterADSR.setRelease(release);
}

double SynthVoice::voicePlay() {
    ADSROut = ADSR.adsr(1., ADSR.trigger);
    
    LFOOut = 1. - (((1. + LFO.sinewave(LFOSpeed))/2.)*LFODepth);
    
    if(waveOne == 0) { VCO1Out = VCO1.sinewave(pitch + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveOne == 1) { VCO1Out = VCO1.triangle(pitch + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveOne == 2) { VCO1Out = VCO1.square(pitch + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveOne == 3) { VCO1Out = VCO1.saw(pitch + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveOne == 4) { VCO1Out = VCO1.noise() * LFOOut;
    }
    
    if(waveTwo == 0) { VCO2Out = VCO2.sinewave((waveTwoPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveTwo == 1) { VCO2Out = VCO2.triangle((waveTwoPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveTwo == 2) { VCO2Out = VCO2.square((waveTwoPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveTwo == 3) { VCO2Out = VCO2.saw((waveTwoPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveOne == 4) { VCO2Out = VCO2.noise() * LFOOut;
    }else if (waveTwo == 5) { VCO2Out = 0;
    }
    
    if(waveThree == 0) { VCO3Out = VCO3.sinewave((waveThreePitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveThree == 1) { VCO3Out = VCO3.triangle((waveThreePitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveThree == 2) { VCO3Out = VCO3.square((waveThreePitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveThree == 3) { VCO3Out = VCO3.saw((waveThreePitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveOne == 4) { VCO3Out = VCO3.noise() * LFOOut;
    }else if (waveThree == 5) { VCO3Out = 0;
    }
    
    if(waveFour == 0) { VCO4Out = VCO4.sinewave((waveFourPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveFour == 1) { VCO4Out = VCO4.triangle((waveFourPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveFour == 2) { VCO4Out = VCO4.square((waveFourPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveFour == 3) { VCO4Out = VCO4.saw((waveFourPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveOne == 4) { VCO4Out = VCO4.noise() * LFOOut;
    }else if (waveFour == 5) { VCO4Out = 0;
    }
    
    VCOOut = (VCO1Out + VCO2Out + VCO3Out + VCO4Out)*0.25;
    
    // Lores / hires - cutoff is in Hz
    if(VCF1Type == 0) { VCF1Out = VCF1.lores(VCOOut, ofMap(ofGetMouseX(), 0, ofGetWidth(), 50, 3000), ofMap(ofGetMouseY(), 0, ofGetHeight(), 1.01, 100));
    } else if (VCF1Type == 1) { VCF1Out = VCF1.hires(VCOOut, ofMap(ofGetMouseX(), 0, ofGetWidth(), 50, 3000), ofMap(ofGetMouseY(), 0, ofGetHeight(), 1.01, 100));
        // HP / LP, cutoff is 0 - 1
    } else if (VCF1Type == 2) { VCF1Out = VCF1.hipass(VCOOut, ofMap(ofGetMouseX(), 0, ofGetWidth(), 0.01, 0.999));
    } else if (VCF1Type == 3) { VCF1Out = VCF1.lopass(VCOOut, ofMap(ofGetMouseX(), 0, ofGetWidth(), 0.01, 0.999));
    } else {
        VCF1Out = VCF1.lopass(VCOOut, 0.99999);
    }
    
    
    // VCF filter = VCF envelope yeah mate
    voiceOut = ADSROut * VCF1Out;
    
    return voiceOut;
    
}

