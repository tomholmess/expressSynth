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
    cutoff = 0.5;
    resonance = 5.;
    LFOSpeed = 4.;
    LFODepth = 0.;
    TremSpeed = 3.;
    TremDepth = 0.;
    waveOne = 3;
    waveTwo = 3;
    waveThree = 3;
    waveFour = 3;
    VCF1Type = 2;
    VCF2Type = 2;
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
    } else if (waveOne == 3) { VCO1Out = VCO1.sawn(pitch + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    }
    
    if(waveTwo == 0) { VCO2Out = VCO2.sinewave((waveTwoPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveTwo == 1) { VCO2Out = VCO2.triangle((waveTwoPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveTwo == 2) { VCO2Out = VCO2.square((waveTwoPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveTwo == 3) { VCO2Out = VCO2.sawn((waveTwoPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveTwo == 4) { VCO2Out = 0;
    }
    
    if(waveThree == 0) { VCO3Out = VCO3.sinewave((waveThreePitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveThree == 1) { VCO3Out = VCO3.triangle((waveThreePitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveThree == 2) { VCO3Out = VCO3.square((waveThreePitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveThree == 3) { VCO3Out = VCO3.sawn((waveThreePitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveThree == 4) { VCO3Out = 0;
    }
    
    if(waveFour == 0) { VCO4Out = VCO4.sinewave((waveFourPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveFour == 1) { VCO4Out = VCO4.triangle((waveFourPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveFour == 2) { VCO4Out = VCO4.square((waveFourPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveFour == 3) { VCO4Out = VCO4.sawn((waveFourPitch*pitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveFour == 4) { VCO4Out = 0;
    }
    
    VCOOut = (VCO1Out + VCO2Out + VCO3Out + VCO4Out)*0.25;
    
    if(VCF1Type == 0) { VCF1Out = VCF1.bandpass(VCOOut, cutoff, resonance);
    } else if (VCF1Type == 1) { VCF1Out = VCF1.lores(VCOOut, cutoff, resonance);
    } else if (VCF1Type == 2) { VCF1Out = VCF1.hipass(VCOOut, cutoff);
    } else if (VCF1Type == 3) { VCF1Out = VCF1.lopass(VCOOut, cutoff);
    }
    
    // VCF filter = VCF envelope yeah mate
    
    
    voiceOut = ADSROut * VCF1Out;
    
    return voiceOut;
    
}

