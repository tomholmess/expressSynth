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

// Set initial synth settings, a basic sine tone with a single oscillator.

void SynthVoice::setup() {
    cutoff = 3000;
    resonance = 10.;
    LFOSpeed = 0;
    LFODepth = 0.;
    TremSpeed = 0;
    TremDepth = 0;
    waveOne = 0;
    waveTwo = 2;
    waveThree = 3;
    waveFour = 0;
    VCF1Type = 0;
    waveTwoPitch = 7;
    waveThreePitch = 12;
    waveFourPitch = 0;
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


// Function to turn MIDI notes into their corresponding frequency in hertz.
double SynthVoice::midiToFrequency(int n) {
    
    if (n >= 0 && n <= 129) {
        double frequency = 440.0 * pow(2.0, (n - 69.0)/12.0);
        return frequency;
    }
    
}

// Double returning voiceplay function. This function features all of the DSP for the synth engine.
double SynthVoice::voicePlay() {
    
    // Implementation of the three arpeggiator modes, up, down and up/down using a phasor oscillator.
    if(arpOnOff == true) {
        if(arpMode == 1) {
            if(numOctaves == 1) {
                arpAddition = fifths[(int)arpPhasor.phasor(arpSpeed, 1, 6)];
            } else if(numOctaves == 2) {
                arpAddition = fifths[(int)arpPhasor.phasor(arpSpeed/2., 1, 11)];
            } else if(numOctaves == 3) {
                arpAddition = fifths[(int)arpPhasor.phasor(arpSpeed/3., 1, 16)];
            }else if(numOctaves == 4) {
                arpAddition = fifths[(int)arpPhasor.phasor(arpSpeed/4., 1, 21)];
            }
        } else if(arpMode == 2) {
            if(numOctaves == 1) {
                arpAddition = 12 - fifths[(int)arpPhasor.phasor(arpSpeed, 0, 5)];
            } else if(numOctaves == 2) {
                arpAddition = 24 - fifths[(int)arpPhasor.phasor(arpSpeed/2., 0, 10)];
            } else if(numOctaves == 3) {
                arpAddition = 36 - fifths[(int)arpPhasor.phasor(arpSpeed/3., 0, 15)];
            }else if(numOctaves == 4) {
                arpAddition = 48 - fifths[(int)arpPhasor.phasor(arpSpeed/4., 0, 20)];
            }
        } else if(arpMode == 3) {
            if(numOctaves == 1) {
                if(arpAddition == 0) {
                    up = true;
                    down = false;
                } else if(arpAddition == 12) {
                    up = false;
                    down = true;
                }
                if(up == true) {
                    arpAddition = fifths[(int)arpPhasor.phasor(arpSpeed, 0, 6)];
                }
                if(down == true) {
                    arpAddition = 12 - fifths[(int)arpPhasor.phasor(arpSpeed, 0, 6)];
                }
            } else if(numOctaves == 2) {
                if(arpAddition == 0) {
                    up = true;
                    down = false;
                } else if(arpAddition == 24) {
                    up = false;
                    down = true;
                }
                if(up == true) {
                    arpAddition = fifths[(int)arpPhasor.phasor(arpSpeed/2., 0, 11)];
                }
                if(down == true) {
                    arpAddition = 24 - fifths[(int)arpPhasor.phasor(arpSpeed/2., 0, 11)];
                }
            } else if(numOctaves == 3) {
                if(arpAddition == 0) {
                    up = true;
                    down = false;
                } else if(arpAddition == 36) {
                    up = false;
                    down = true;
                }
                if(up == true) {
                    arpAddition = fifths[(int)arpPhasor.phasor(arpSpeed/3., 0, 16)];
                }
                if(down == true) {
                    arpAddition = 36 - fifths[(int)arpPhasor.phasor(arpSpeed/3., 0, 16)];
                }
            } else if(numOctaves == 4) {
                if(arpAddition == 0) {
                    up = true;
                    down = false;
                } else if(arpAddition == 48) {
                    up = false;
                    down = true;
                }
                if(up == true) {
                    arpAddition = fifths[(int)arpPhasor.phasor(arpSpeed/4., 0, 21)];
                }
                if(down == true) {
                    arpAddition = 48 - fifths[(int)arpPhasor.phasor(arpSpeed/4., 0, 21)];
                }
            }
            
        } else {
            arpAddition = 0;
        }
    }
    
   
    // LFO with speed and depth
    LFOOut = 1. - (((1. + LFO.sinewave(LFOSpeed))/2.)*LFODepth);
    
    
    // Four oscillators with 5 type options each, sine, triangle, square, saw and noise, oscillators two, three and four also have a sixth, off, option.
    // Each oscillator takes the MIDI note, adds the arpeggiator addition, adds the tremolo oscillator at the speed and depth, converts it to the using the miditofrequency
    // function and multiplies it by the LFO out.
    if(waveOne == 0) { VCO1Out = VCO1.sinewave(midiToFrequency(midiNote + arpAddition) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveOne == 1) { VCO1Out = VCO1.triangle(midiToFrequency(midiNote + arpAddition) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveOne == 2) { VCO1Out = VCO1.square(midiToFrequency(midiNote + arpAddition) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveOne == 3) { VCO1Out = VCO1.saw(midiToFrequency(midiNote + arpAddition) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveOne == 4) { VCO1Out = VCO1.noise() * LFOOut;
    }
    
    if(waveTwo == 0) { VCO2Out = VCO2.sinewave((midiToFrequency(midiNote + arpAddition + waveTwoPitch)) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveTwo == 1) { VCO2Out = VCO2.triangle((midiToFrequency(midiNote + arpAddition + waveTwoPitch)) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveTwo == 2) { VCO2Out = VCO2.square((midiToFrequency(midiNote + arpAddition + waveTwoPitch)) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveTwo == 3) { VCO2Out = VCO2.saw((midiToFrequency(midiNote + arpAddition + waveTwoPitch)) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveOne == 4) { VCO2Out = VCO2.noise() * LFOOut;
    }else if (waveTwo == 5) { VCO2Out = 0;
    }
    
    if(waveThree == 0) { VCO3Out = VCO3.sinewave((midiToFrequency(midiNote + arpAddition + waveThreePitch)) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveThree == 1) { VCO3Out = VCO3.triangle((midiToFrequency(midiNote + arpAddition + waveThreePitch)) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveThree == 2) { VCO3Out = VCO3.square((midiToFrequency(midiNote + arpAddition + waveThreePitch)) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveThree == 3) { VCO3Out = VCO3.saw((midiToFrequency(midiNote + arpAddition + waveThreePitch)) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveOne == 4) { VCO3Out = VCO3.noise() * LFOOut;
    }else if (waveThree == 5) { VCO3Out = 0;
    }
    
    if(waveFour == 0) { VCO4Out = VCO4.sinewave((midiToFrequency(midiNote + arpAddition + waveFourPitch)) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveFour == 1) { VCO4Out = VCO4.triangle((midiToFrequency(midiNote + arpAddition) + waveFourPitch) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveFour == 2) { VCO4Out = VCO4.square((midiToFrequency(midiNote + arpAddition + waveFourPitch)) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveFour == 3) { VCO4Out = VCO4.saw((midiToFrequency(midiNote + arpAddition + waveFourPitch)) + (Trem.sinebuf(TremSpeed)*TremDepth)) * LFOOut;
    } else if (waveOne == 4) { VCO4Out = VCO4.noise() * LFOOut;
    }else if (waveFour == 5) { VCO4Out = 0;
    }
    
    // Sum the four oscillators and divide by four.
    VCOOut = (VCO1Out + VCO2Out + VCO3Out + VCO4Out)*0.25;
    
    // Delay out.
    delayOut = delay.dl(VCOOut, 100, 0.4);
    
    
    // Multiply the oscillator out by the cutoff times the filterADSR output.
    // Lores / hires - cutoff is in Hz
    if(VCF1Type == 0) { VCF1Out = VCF1.lores(delayOut, cutoff*FilterADSROut, resonance);
    } else if (VCF1Type == 1) { VCF1Out = VCF1.hires(delayOut, cutoff*FilterADSROut, resonance);
        // HP / LP, cutoff is 0 - 1
    } else if (VCF1Type == 2) { VCF1Out = VCF1.hipass(delayOut, cutoff*FilterADSROut);
    } else if (VCF1Type == 3) { VCF1Out = VCF1.lopass(delayOut, cutoff*FilterADSROut);
    } else {
        VCF1Out = VCF1.lopass(VCOOut, 0.99999);
    }
    
    ADSROut = ADSR.adsr(1., ADSR.trigger);
    FilterADSROut = filterADSR.adsr(1., filterADSR.trigger);
    
    // VCF filter = VCF envelope yeah mate
    voiceOut = ADSROut * VCF1Out;
    
    return voiceOut;
    
}

