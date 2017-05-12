#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    ofBackground(255);
    ofEnableAlphaBlending();
    ofSetVerticalSync(true);
    
    
    // Set sample rate and buffer size
    sampleRate = 44100;
    bufferSize = 512;
    
    
    // Set up the interface and load the "Gifs" as .mp4's
    interface.setupUI();
    interface.loadGifs();
    
    // Setup each synth voice with the parameters stated in the ofApp.h file, this are the parameters than are linked with the string variables that output the current settings
    // linking them here ensures default settings are reported correctly in the current settings. This also gives the patch a default, basic setting.
    for(int i = 0; i < 12; i++) {
        voice[i].setup();
        voice[i].setEnvelope(ampAttack, 100, 0.99, ampRelease);
        voice[i].setFilterEnvelope(filterAttack, 100, 0.99, filterRelease);
        voice[i].arpOnOff = false;
        voice[i].cutoff = filterCutoff;
        voice[i].resonance = filterRes;
        voice[i].arpOnOff = true;
        voice[i].arpMode = 1;
        voice[i].arpSpeed = ArpSpeed;
        voice[i].numOctaves = ArpOctaves;
        voice[i].VCF1Type = 0;
    }
    
    // Setup string variables for synth parameters
    setupStrings();
    
    
    // Initiate the serial connection between the controller and the program.
    gesture.setupSerial();
    
    // Maxim initiations
    ofxMaxiSettings::setup(sampleRate, 2, bufferSize);
    ofSoundStreamSetup(2, 2, this, sampleRate, bufferSize, 4);

    // Set all the gesture differences and record vector to nil, helps to avoid any miscalibrations or miscalcuations on the first gesture
    gesture.clearEverything();
    
}

//--------------------------------------------------------------
void ofApp::update(){

    // Retrieve the values from the controller
    gesture.valuesIn();
    
    // This function updates the state of both the blue and red buttons, switching booleans to either 'pressed' or 'released'
    gesture.buttonOn();
    
    // Works in conjunction with the buttonOn function to update the incoming data from the controller
    gesture.buttonEvent();
    
    // This is the main function that links the synth voices to the gestures. It's a pretty big function (see below) that takes decisions made by the gesture.cpp file
    // and translates them into the respective synth function
    gestureSynthLink();
    
//    cout << oscAdd << " " << oscSub << " " << osc2Pitch << endl;

 //   cout << gesture.record.size() << endl;
    
    // update a variable specific to the ofApp file that originates in the gesture.cpp file
    calibrationIndex = gesture.calibrationIndex;
    
    cout << gesture.bluePressed << " " << gesture.blueReleased << " " << gesture.redPressed << " " << gesture.redReleased << endl;
    

    
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    // DRAW THE INTERFACE!
    drawTitles();
    
    // Display the current synth settings at the buttom of the screen.
    displayCurrentSettings();
    
    if(gesture.bluePressed == true) {
        ofSetColor(0, 0, 255, 50);
        ofDrawCircle(20, 20, 5);
    }
    
    if(gesture.redPressed == true) {
        ofSetColor(255, 0, 0, 50);
        ofDrawCircle(980, 20, 5);
    }
    
    
}

void ofApp::audioOut(float * output, int bufferSize, int nChannels){
    
    
    // Audio IO buffer for loop
    for(int i = 0; i < bufferSize; i+=2) {
        
        
        // This is the pattern that allows the user to play with the synth settings when they don't want to/are unable to play the keys at the same time.
        patternCount = patternMaker.phasor(1.5, 0, 5);
        
        if(patternOn == true) {
            
            voice[0].midiNote = 63;
            voice[1].midiNote = 51;
            voice[2].midiNote = 55;
            voice[3].midiNote = 60;
            voice[4].midiNote = 58;
            
            // Trigger the pattern notes
            voice[patternCount].ADSR.trigger = 1;
            voice[patternCount].filterADSR.trigger = 1;
            
        }
        
        // Output the voiceplay function of each voice.
        output[i*nChannels    ] = 4*(voice[0].voicePlay() + voice[1].voicePlay() + voice[2].voicePlay() + voice[3].voicePlay() + voice[4].voicePlay() + voice[5].voicePlay() + voice[6].voicePlay() + voice[7].voicePlay() + voice[8].voicePlay() + voice[9].voicePlay() + voice[10].voicePlay() + voice[11].voicePlay());
        output[i*nChannels + 1] = 4*(voice[0].voicePlay() + voice[1].voicePlay() + voice[2].voicePlay() + voice[3].voicePlay() + voice[4].voicePlay() + voice[5].voicePlay() + voice[6].voicePlay() + voice[7].voicePlay() + voice[8].voicePlay() + voice[9].voicePlay() + voice[10].voicePlay() + voice[11].voicePlay());
        
        
        // Close the triggers of the pattern.
        if(patternOn == true) {
            
            voice[patternCount].ADSR.trigger = 0;
            voice[patternCount].filterADSR.trigger = 0;
            
        }
        
    }
    
}



//--------------------------------------------------------------
void ofApp::keyPressed(int key){

    
    // Key inputs for manually switching between sections
    if (key == '1') {
        section = "title";
    }
    
    if(key == '2') {
        section = "instructions";
    }
    
    if(key == '3') {
        section = "calibration";
        // Clear all of the shape vectors if recalibrating to ensure the vectors are reset before re-recording
        gesture.sine.clear();
        gesture.lineUp.clear();
        gesture.triangle.clear();
        gesture.FX.clear();
        gesture.lineDown.clear();
        gesture.eight.clear();
        gesture.arp.clear();
        gesture.square.clear();
        gesture.saw.clear();
    }
    
    if (key == '4') {
        section = "home";
    }
    if (key == '5') {
        if(section == "oscSelect") {
            section = "oscControl";
        } else {
            section = "oscSelect";
        }
    }
    if (key == '6') {
        section = "envelopeControl";
    }
    if (key == '7') {
        if(section == "filterSelect") {
            section = "filterControl";
        } else if(section == "filterControl") {
            section = "filterAutomation";
        } else {
            section = "filterSelect";
        }
        
    }
    if (key == '8') {
        if(section == "LFOSelect") {
            section = "LFOControl";
        } else if(section == "LFOControl") {
            section = "portaControl";
        } else if(section == "portaControl") {
            section = "tremControl";
        } else if(section == "tremControl") {
            section = "LFOSelect";
        } else {
            section = "LFOSelect";
        }
    }
    if (key == '9') {
        if(section == "arpSelect") {
            section = "arpControl";
        } else {
            section = "arpSelect";
        }
    }
    if (key == '0') {
        if(section == "FXSelect") {
            section = "chorusControl";
        } else if(section == "chorusControl") {
            section = "delayControl";
        } else if(section == "delayControl") {
            section = "reverbControl";
        } else if(section == "reverbControl") {
            section = "FXSelect";
        } else {
            section = "FXSelect";
        }
    }
    
    
    // Note, amp envelope and filter envelope triggers for keyboard control
    if(key == 'a') {
        voice[0].midiNote = 60;
        voice[0].ADSR.trigger = 1;
        voice[0].filterADSR.trigger = 1;
    }
    
    
    if(key == 'w') {
        voice[1].midiNote = 61;
        voice[1].ADSR.trigger = 1;
        voice[1].filterADSR.trigger = 1;
    }
    
    if(key == 's') {
        voice[2].midiNote = 62;
        voice[2].ADSR.trigger = 1;
        voice[2].filterADSR.trigger = 1;
    }
    
    if(key == 'e') {
        voice[3].midiNote = 63;
        voice[3].ADSR.trigger = 1;
        voice[3].filterADSR.trigger = 1;
    }
    
    if(key == 'd') {
        voice[4].midiNote = 64;
        voice[4].ADSR.trigger = 1;
        voice[4].filterADSR.trigger = 1;
    }
    
    if(key == 'f') {
        voice[5].midiNote = 65;
        voice[5].ADSR.trigger = 1;
        voice[5].filterADSR.trigger = 1;
    }
    
    if(key == 't') {
        voice[6].midiNote = 66;
        voice[6].ADSR.trigger = 1;
        voice[6].filterADSR.trigger = 1;
    }
    
    if(key == 'g') {
        voice[7].midiNote = 67;
        voice[7].ADSR.trigger = 1;
        voice[7].filterADSR.trigger = 1;
    }
    
    if(key == 'y') {
        voice[8].midiNote = 68;
        voice[8].ADSR.trigger = 1;
        voice[8].filterADSR.trigger = 1;
    }
    
    if(key == 'h') {
        voice[9].midiNote = 69;
        voice[9].ADSR.trigger = 1;
        voice[9].filterADSR.trigger = 1;
    }
    
    if(key == 'u') {
        voice[10].midiNote = 70;
        voice[10].ADSR.trigger = 1;
        voice[10].filterADSR.trigger = 1;
    }
    
    if(key == 'j') {
        voice[11].midiNote = 71;
        voice[11].ADSR.trigger = 1;
        voice[11].filterADSR.trigger = 1;
    }
    
    if(key == 'k') {
        voice[11].midiNote = 72;
        voice[11].ADSR.trigger = 1;
        voice[11].filterADSR.trigger = 1;
    }
    
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){
    
    
    // Pattern on/off
    if(key == 'z') {
        if(patternOn == true) {
            patternOn = false;
        } else {
            patternOn = true;
        }
    }

    
    if(key == 'x') {
        gesture.adafruitOne.flush();
        gesture.adafruitOne.drain();
    }
    
    // Off triggers for keyboard control
    if(key == 'a') {
        voice[0].ADSR.trigger = 0;
        voice[0].filterADSR.trigger = 0;
    }
    
    
    if(key == 'w') {
        voice[1].ADSR.trigger = 0;
        voice[1].filterADSR.trigger = 0;
    }
    
    if(key == 's') {
        voice[2].ADSR.trigger = 0;
        voice[2].filterADSR.trigger = 0;
    }
    
    if(key == 'e') {
        voice[3].ADSR.trigger = 0;
        voice[3].filterADSR.trigger = 0;
    }
    
    if(key == 'd') {
        voice[4].ADSR.trigger = 0;
        voice[4].filterADSR.trigger = 0;
    }
    
    if(key == 'f') {
        voice[5].ADSR.trigger = 0;
        voice[5].filterADSR.trigger = 0;
    }
    
    if(key == 't') {
        voice[6].ADSR.trigger = 0;
        voice[6].filterADSR.trigger = 0;
    }
    
    if(key == 'g') {
        voice[7].ADSR.trigger = 0;
        voice[7].filterADSR.trigger = 0;
    }
    
    if(key == 'y') {
        voice[8].ADSR.trigger = 0;
        voice[8].filterADSR.trigger = 0;
    }
    
    if(key == 'h') {
        voice[9].ADSR.trigger = 0;
        voice[9].filterADSR.trigger = 0;
    }
    
    if(key == 'u') {
        voice[10].ADSR.trigger = 0;
        voice[10].filterADSR.trigger = 0;
    }
    
    if(key == 'j') {
        voice[11].ADSR.trigger = 0;
        voice[11].filterADSR.trigger = 0;
    }
    
    if(key == 'k') {
        voice[11].ADSR.trigger = 0;
        voice[11].filterADSR.trigger = 0;
    }
    
    // PRESS SPACE TO CONTINUE!
    if(section == "calibration") {
        if(key == ' ') {
            gesture.calibrationIndex += 1;
        }
    }
    
    if(section == "instructions") {
        if(key == ' ') {
            section = "calibration";
        }
    }
    
    if(section == "title") {
        if(key == ' ') {
            section = "instructions";
        }
    }
    
}


//--------------------------------------------------------------
void ofApp::gestureSynthLink() {

    // As stated earlier this function is the link gesture the decisions made in the gesture.cpp file and the corresponding synth controls in the synthvoice.cpp files
    
    // Most of the "sections", ie home, oscillator control (oscControl), filterSelect etc feature similar code, usually comprising of identifying which button is being pressed,
    // followed by utilisation of the gesture.shaperecord function to push back the record gesture, then going to a choice between gesture recognition and outcome or step back
    // ,stepping back a section occuring only when the redbutton is pressed for a period less than 50 pushbacks on a record or 25 ticks on a counter. This allows the user to
    // move back a section by tapping the redbutton; pressing for longer either records a gesture or changes one of the control parameters, ie amp release.
    
    // As stated in the final project report, the gesture element of this project is split into two sections
    
    // 1. Selection Gestures ---- Gestures that are compared against the calibrated gestures to make selections, ie which waveform, or which filter or arp mode to use
    
    // 2. Control Gestures ---- These gestures do not compare against a database, but use the accelerometers raw and immediate data to control parameters
    
    // Splitting into these two allows immediate control of parameters, rather than waiting for gesture recognition. Immediate control of parameters gives a more natural feel
    // than performing a movement, followed by a pause, then by a change in the parameter. Its immediate like twisting a knob on a hardware synth!
    
    // For selection gestures, the record vector is pushing back with the values currently backing received, one the button is released and determined to be long enough,
    // it's passed into the vector normalization function to eliminate time variance and then compared with the other calibrated shapes. Once thats done another function
    // in the gesture section determines which shape has the smallest Euclidian distance to the one just performed, returns this, and then is mapped to the corresponding synth
    // function
    
    if(section == "calibration") {
        gesture.calibration();

        if(gesture.calibrationIndex > 9) {
            section = "home";
        }
    }
    
    if(section == "instructions") {
//        if(gesture.blueReleased == true) {
//            section = "calibration";
//        } else if(gesture.redReleased == true) {
//            section = "title";
//        }
    }
    
    if(section == "title") {


    }
    
    if(section == "home") {
        if(gesture.bluePressed == true) {
            
            // Push back the record vector when the bluebutton is pressed
            gesture.record = gesture.shapeRecord(gesture.record);
        }
        
        if(gesture.blueReleased == true && gesture.record.size() > 50) {
            
            
            // Normalize the size of the vector so it has the same amount of values as the calibrated shapes
            gesture.record = gesture.vectorNormalize(gesture.record, gesture.NUM_VALUES);
            
            // set a gesturereturn variable to the value of the smallest difference using the gesture.home function (see gesture section)
            int gestureReturn = 0;
            gestureReturn = gesture.home();
            
            cout << gesture.sineDiff << " " << gesture.triangleDiff << " " << gesture.squareDiff << " " << gesture.eightDiff << " " << gesture.sawDiff << " " << gesture.FXDiff << endl;
            
            // change section according to the closest shape.
            if(gestureReturn == 1) {
                section = "oscSelect";
            } else if(gestureReturn == 2) {
                section = "envelopeControl";
            } else if(gestureReturn == 3) {
                section = "filterSelect";
            } else if(gestureReturn == 4) {
                section = "LFOSelect";
            } else if(gestureReturn == 5) {
                section = "arpSelect";
            } else if(gestureReturn == 6) {
                section = "FXSelect";
            }
            // once done set the gesturereturn to 0 and reset all of the differences as well as the record vector, so they are 0 when they are used again
            gestureReturn = 0;
            gesture.clearEverything();
        }
        
    }
    
    if(section == "oscSelect") {
        
        if(gesture.bluePressed == true || gesture.redPressed == true) {
            // Push back the record vector if either blue or red are pressed
            gesture.record = gesture.shapeRecord(gesture.record);
        }
        
        if(gesture.blueReleased == true) {
            // only if the vector is greater than 50 should it normalizing and proceed with gesture matching and differencing. This allow quick pressed of the redbutton
            // to be used to go back and not allow recording and matching of a vector which would result in a change of section in the wrong way
            gesture.record = gesture.vectorNormalize(gesture.record, gesture.NUM_VALUES);
            
            int gestureReturn = 0;
            gestureReturn = gesture.oscSelect();
            cout << gestureReturn << endl;
            if(oscCurrentControl == 1) {
                if(gestureReturn == 1) {
                    // depending on the gesture return value and the current oscillator that is being controller (oscCurrentControl), change the waveform of the wave.
                    // also, set the string name to the corresponding wave name for output on the screen in the current settings section
                    for(int i = 0; i < 12; i++) {
                        // set each voice's first oscillator to sinewave
                        voice[i].waveOne = 0;
                        // set the current setting string to sine.
                        osc1type = "Sine";
                    }
                } else if(gestureReturn == 2) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveOne = 1;
                        osc1type = "Triangle";
                    }
                } else if(gestureReturn == 3) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveOne = 2;
                        osc1type = "Square";
                    }
                } else if(gestureReturn == 4) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveOne = 3;
                        osc1type = "Sawtooth";
                    }
                } else if(gestureReturn == 5) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveOne = 4;
                        osc1type = "Noise";
                    }
                }
            }
            
            // FROM HERE ON EACH OF THESE SECTIONS IN THE GESTURESYNTHLINK FUNCTION EMPLOY THE SAME METHODS AS EXPLAINED ABOVE
            
            if(oscCurrentControl == 2) {
                if(gestureReturn == 1) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveTwo = 0;
                        osc2type = "Sine";
                    }
                } else if(gestureReturn == 2) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveTwo = 1;
                        osc2type = "Triangle";
                    }
                } else if(gestureReturn == 3) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveTwo = 2;
                        osc2type = "Square";
                    }
                } else if(gestureReturn == 4) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveTwo = 3;
                        osc2type = "Sawtooth";
                    }
                } else if(gestureReturn == 5) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveTwo = 4;
                        osc2type = "Noise";
                    }
                }
            }
            
            if(oscCurrentControl == 3) {
                if(gestureReturn == 1) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveThree = 0;
                        osc3type = "Sine";
                    }
                } else if(gestureReturn == 2) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveThree = 1;
                        osc3type = "Triangle";
                    }
                } else if(gestureReturn == 3) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveThree = 2;
                        osc3type = "Square";
                    }
                } else if(gestureReturn == 4) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveThree = 3;
                        osc3type = "Sawtooth";
                    }
                } else if(gestureReturn == 5) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveThree = 4;
                        osc3type = "Noise";
                    }
                }
            }
            
            if(oscCurrentControl == 4) {
                if(gestureReturn == 1) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveFour = 0;
                        osc4type = "Sine";
                    }
                } else if(gestureReturn == 2) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveFour = 1;
                        osc4type = "Triangle";
                    }
                } else if(gestureReturn == 3) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveFour = 2;
                        osc4type = "Square";
                    }
                } else if(gestureReturn == 4) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveFour = 3;
                        osc4type = "Sawtooth";
                    }
                } else if(gestureReturn == 5) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveFour = 4;
                        osc4type = "Noise";
                    }
                }
            }
            
            section = "oscControl";
            gestureReturn = 0;
            gesture.clearEverything();
            
        }
        
        // Move back to the home section if the redbutton is released.
        if(gesture.redReleased == true) {
            section = "home";
            gesture.clearEverything();
        }
        

        
    }
    
    if(section == "oscControl") {
        if(gesture.bluePressed == true) {
            
            
            /// Control Gesture Implementation
            
            // The control gestures use the gesture.control function, which takes the parameter being controlled, the button, and direction of acceleration, upper and lower limits
            // and a scaling as arguments so the function can be used for all control gestures.
            if(oscCurrentControl == 2) {
                osc2Pitch = (int)gesture.control(osc2Pitch, gesture.bluePressed, gesture.xAccel, 0, 48, 0.05);
                osc2semi = ofToString(osc2Pitch);
            } else if(oscCurrentControl == 3) {
                osc3Pitch = (int)gesture.control(osc3Pitch, gesture.blueButton, gesture.xAccel, 0, 48, 0.05);
                osc3semi = ofToString(osc3Pitch);
            }else if(oscCurrentControl == 4) {
                osc4Pitch = (int)gesture.control(osc4Pitch, gesture.blueButton, gesture.xAccel, 0, 48, 0.05);
                osc4semi = ofToString(osc4Pitch);
            }
            
            oscAdd = gesture.control(oscAdd, gesture.blueButton, -gesture.yAccel, 0, 100, 0.25);
            
            cout << oscAdd << endl;
            

        }
        
        if(gesture.blueReleased == true) {
            
            for(int i = 0; i < 12; i++) {
                if(oscCurrentControl == 2) {
                    voice[i].waveTwoPitch = osc2Pitch;
                    osc2semi = ofToString(osc2Pitch);
                } else if(oscCurrentControl == 3) {
                    voice[i].waveThreePitch = osc3Pitch;
                    osc3semi = ofToString(osc3Pitch);
                }else if(oscCurrentControl == 4) {
                    voice[i].waveFourPitch = osc4Pitch;
                    osc4semi = ofToString(osc4Pitch);
                }
            }
            
            if(oscAdd > 10) {
                
                if(oscCurrentControl == 2) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveTwo = 5;
                        osc2semi = "Off";
                    }
                    oscCurrentControl = 1;
                    section = "oscSelect";
                    
                } else if(oscCurrentControl == 3) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveThree = 5;
                        osc3semi = "Off";
                    }
                    oscCurrentControl = 2;
                    section = "oscSelect";
                    
                } else if(oscCurrentControl == 4) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveFour = 5;
                        osc3semi = "Off";
                    }
                    oscCurrentControl = 3;
                    section = "oscSelect";
                }
                oscAdd = 0;
            }
            
        }
        
        if(gesture.redPressed == true) {
            
            oscCounter++;
            oscSub = gesture.control(oscSub, gesture.redButton, gesture.yAccel, 0, 100, 0.25);
            cout << oscSub << endl;
        }
        
        if(gesture.redReleased == true && oscCounter <= 25) {
            section = "oscSelect";
            oscCounter = 0;
        } else if(gesture.redReleased == true && oscCounter >= 25) {
            
            oscCounter = 0;
            
            if(oscSub > 10) {
                
                if(oscCurrentControl == 1) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveTwo = 0;
                        osc2type = "Sine";
                    }
                    oscCurrentControl = 2;
                    section = "oscSelect";
                }
                if(oscCurrentControl == 2) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveThree = 0;
                        osc3type = "Sine";
                    }
                    oscCurrentControl = 3;
                    section = "oscSelect";
                }
                if(oscCurrentControl == 3) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveFour = 0;
                        osc4type = "Sine";
                        
                    }
                    oscCurrentControl = 4;
                    section = "oscSelect";
                }
                
                oscSub = 0;
        
            }
            
        }
    }
    
    if(section == "envelopeControl") {
        
        if(gesture.redPressed == true || gesture.bluePressed == true) {
            ampCounter++;
            ampAttack = gesture.control(ampAttack, gesture.blueButton, gesture.xAccel, 50, 3000, 2.5);
            ampRelease = gesture.control(ampRelease, gesture.redButton, -gesture.xAccel, 50, 3000, 2.5);
        
        }
        
        if(gesture.redReleased == true && ampCounter <= 25) {
            section = "home";
            ampCounter = 0;
        } else if((gesture.redReleased == true || gesture.blueReleased == true) && ampCounter > 25) {
            for(int i = 0; i < 12; i++) {
                voice[i].setEnvelope(ampAttack, 0.99, 0.99, ampRelease);
            }
            ampAttck = ofToString(ampAttack);
            ampRelse = ofToString(ampRelease);
            ampCounter = 0;
        }
        
    }
    

    if(section == "filterSelect") {
        if(gesture.bluePressed == true) {
            gesture.record = gesture.shapeRecord(gesture.record);
            cout << "recording..." << endl;
        }
        
        if(gesture.blueReleased == true) {
            gesture.record = gesture.vectorNormalize(gesture.record, gesture.NUM_VALUES);
            
            cout << "finished..." << endl;
            int gestureReturn = 0;
            gestureReturn = gesture.filterSelect();
        
            
            if(gestureReturn == 1) {
                for(int i = 0; i < 12; i++) {
                    // Reset the cutoff as maxim's cutoff values for lo and hi pass are between 0 and 1, whereas for lores/hires they're in hertz.
                    voice[i].cutoff = 0.6;
                    voice[i].VCF1Type = 2;
                    filterTyp = "Hipass";
                    section = "filterControl";
                }
            }
            
            if(gestureReturn == 2) {
                for(int i = 0; i < 12; i++) {
                    voice[i].cutoff = 0.6;
                    voice[i].VCF1Type = 3;
                    filterTyp = "Lopass";
                    section = "filterControl";
                }
            }
            
            
            
            gestureReturn = 0;
            gesture.clearEverything();
            
        }
        
        if(gesture.redPressed == true) {
            gesture.record = gesture.shapeRecord(gesture.record);
            filterCounter++;
            cout << filterCounter << endl;
        }
        
        if(gesture.redReleased == true && filterCounter > 30) {
            gesture.record = gesture.vectorNormalize(gesture.record, gesture.NUM_VALUES);
            
            int gestureReturn = 0;
            gestureReturn = gesture.filterSelectRed();
            
            if(gestureReturn == 1) {
                for(int i = 0; i < 12; i++) {
                    filterCutoff = 2000;
                    filterRes = 5;
                    voice[i].VCF1Type = 0;
                    voice[i].cutoff = filterCutoff;
                    voice[i].resonance = filterRes;
                    filterTyp = "Lores";
                    cutoff = ofToString(filterCutoff);
                    res = ofToString(filterRes);
                    section = "filterControl";

                }
            }
            
            if(gestureReturn == 2) {
                for(int i = 0; i < 12; i++) {
                    filterCutoff = 2000;
                    filterRes = 5;
                    voice[i].VCF1Type = 1;
                    voice[i].cutoff = filterCutoff;
                    voice[i].resonance = filterRes;
                    filterTyp = "Hires";
                    cutoff = ofToString(filterCutoff);
                    res = ofToString(filterRes);
                    section = "filterControl";
                    
                }
            }
            
            if(gestureReturn == 3) {
                section = "filterAutomation";
            }
            
            
            
            gestureReturn = 0;
            gesture.clearEverything();
            
        } else if(gesture.redReleased == true && filterCounter <= 30) {
            section = "home";
            gesture.clearEverything();
        }
        
        
       
    }
    
    if(section == "filterControl") {
        
        if(gesture.redPressed == true || gesture.bluePressed == true) {
            filterCounter++;
            cout << filterCounter << endl;
            if(voice[0].VCF1Type == 2 || voice[0].VCF1Type == 3) {
                filterCutoff = gesture.control(filterCutoff, gesture.blueButton, gesture.xAccel, 0.01, 0.9999, 0.01);
            } else if(voice[0].VCF1Type == 0 || voice[0].VCF1Type == 1) {
                cout << gesture.xAccel << endl;
                filterCutoff = gesture.control(filterCutoff, gesture.blueButton, -gesture.xAccel, 50, 10000, 2.5);
                filterRes = gesture.control(filterRes, gesture.redButton, -gesture.xAccel, 2, 100, 0.1);
            }
            
        }
        
        if(gesture.redReleased == true && filterCounter <= 25) {
            section = "filterSelect";
            filterCounter = 0;
        }
        
        if((gesture.redReleased == true || gesture.blueReleased == true) && filterCounter > 25) {
            for(int i = 0; i < 12; i++) {
                
                
                voice[i].cutoff = filterCutoff;
                voice[i].resonance = filterRes;
                
                cutoff = ofToString(filterCutoff);
                res = ofToString(filterRes);
                
            }
            filterCounter = 0;
        }

        
    }
    
    
    if(section == "filterAutomation") {
    
        if(gesture.redPressed == true || gesture.bluePressed == true) {
            filterCounter++;
            filterAttack = gesture.control(filterAttack, gesture.blueButton, -gesture.xAccel, 50, 3000, 3);
            filterRelease = gesture.control(filterRelease, gesture.redButton, -gesture.xAccel, 50, 5000, 3);
            filterSustain = gesture.control(filterSustain, gesture.blueButton, -gesture.yAccel, 0.01, 0.999, 0.1);
        }
        
        if((gesture.redReleased == true || gesture.blueReleased == true) && filterCounter > 25) {
            for(int i = 0; i < 12; i++) {
                voice[i].setFilterEnvelope(filterAttack, 1000, filterSustain, filterRelease);
                filterAttck = ofToString(filterAttack);
                filterRlse = ofToString(filterRelease);
                filterSstn = ofToString(filterSustain);
            }
            filterCounter = 0;
        } else if(gesture.redReleased == true && filterCounter <= 25) {
            section = "filterSelect";
            filterCounter = 0;
        }
        
    }
    

    
    if(section == "LFOSelect") {
    
        
        if(gesture.bluePressed == true) {
            gesture.record = gesture.shapeRecord(gesture.record);
            LFOCounter++;
        }
        
        if(gesture.blueReleased == true) {
            gesture.record = gesture.vectorNormalize(gesture.record, gesture.NUM_VALUES);
            
            int gestureReturn = 0;
            gestureReturn = gesture.LFOSelect();
            
            if(gestureReturn == 1) {
                section = "LFOControl";
            }
            
            if(gestureReturn == 2) {
                section = "portaControl";
            }
        
            if(gestureReturn == 3) {
                section = "tremControl";
            }
            
            gestureReturn = 0;
            gesture.clearEverything();
            
        }
        
        if(gesture.redReleased == true) {
            section = "home";
            gesture.clearEverything();
            
        }
    
    }
    
    if(section == "LFOControl") {
        
        if(gesture.bluePressed == true || gesture.redPressed == true) {
            LFOCounter++;
            cout << LFOCounter << endl;
            LFOSpeed = gesture.control(LFOSpeed, gesture.blueButton, -gesture.xAccel, 0, 20.0, 0.05);
            LFODepth = gesture.control(LFODepth, gesture.redButton, -gesture.xAccel, 0, 1.0, 0.001);
            
        }
        
        if((gesture.blueReleased == true || gesture.redReleased == true) && LFOCounter > 25) {
            for(int i = 0; i < 12; i++) {
                voice[i].LFOSpeed = LFOSpeed;
                voice[i].LFODepth = LFODepth;
                lfospd = ofToString(LFOSpeed);
                lfodpth = ofToString(LFODepth);
                LFOCounter = 0;
                
            }

        } else if(gesture.redReleased == true && LFOCounter <= 25) {
            section = "LFOSelect";
            
        }
        
        
        
    }
    
    if(section == "portaControl") {
        
        if(gesture.bluePressed == true) {
            PortaSpeed = gesture.control(TremSpeed, gesture.blueButton, gesture.xAccel, 0, 20.0, 0.1);
        }
        
        if(gesture.redPressed == true) {
            PortaCounter++;
        }
        
        if(gesture.blueReleased == true && PortaCounter > 25) {
            for(int i = 0; i < 12; i++) {
                voice[i].PortaSpeed = PortaSpeed;
                portaspd = ofToString(PortaSpeed);
                PortaCounter = 0;
            }
            
        } else if(gesture.redReleased == true && PortaCounter <= 25) {
            section = "LFOSelect";
            PortaCounter = 0;
            
        }

        
        
    }
    
    if(section == "tremControl") {
        
        if(gesture.bluePressed == true || gesture.redPressed == true) {
            TremCounter++;
            cout << TremCounter << endl;
            TremSpeed = gesture.control(TremSpeed, gesture.blueButton, -gesture.xAccel, 0, 100, 0.2);
            TremDepth = gesture.control(TremDepth, gesture.redButton, -gesture.xAccel, 0, 100, 0.2);
            
        }

        if((gesture.blueReleased == true || gesture.redReleased) && TremCounter > 25) {
            for(int i = 0; i < 12; i++) {
                voice[i].TremSpeed = TremSpeed;
                voice[i].TremDepth = TremDepth;
                tremspd = ofToString(TremSpeed);
                tremdpth = ofToString(TremDepth);
                TremCounter = 0;
            }
        
        } else if(gesture.redReleased == true && TremCounter <= 25) {
            section = "LFOSelect";
            TremCounter = 0;
            
        }
        
        
    }
    
    
    if(section == "arpSelect") {
    
        if(gesture.bluePressed == true) {
            gesture.record = gesture.shapeRecord(gesture.record);
        }
        
        if(gesture.blueReleased == true) {
            gesture.record = gesture.vectorNormalize(gesture.record, gesture.NUM_VALUES);
            
            int gestureReturn = 0;
            gestureReturn = gesture.arpSelect();
            
            if(gestureReturn == 1) {
                for(int i = 0; i < 12; i++) {
                    voice[i].arpMode = 1;
                }
            }
            
            if(gestureReturn == 2) {
                for(int i = 0; i < 12; i++) {
                    voice[i].arpMode = 2;
                }
            
            }
            
            section = "arpControl";
            gestureReturn = 0;
            gesture.clearEverything();
        }
        
        
        if(gesture.redPressed == true) {
            gesture.record = gesture.shapeRecord(gesture.record);
            ArpCounter++;
            cout << ArpCounter << endl;
        }
        
        if(gesture.redReleased == true && ArpCounter > 30) {
            gesture.record = gesture.vectorNormalize(gesture.record, gesture.NUM_VALUES);
            
            int gestureReturn = 0;
            gestureReturn = gesture.arpSelectRed();
            
            if(gestureReturn == 1) {
                for(int i = 0; i < 12; i++) {
                    voice[i].arpMode = 3;
                    
                }
            }
            section = "arpControl";
            
            gestureReturn = 0;
            gesture.clearEverything();
            
        }
        
        if(gesture.redReleased == true && ArpCounter <= 30) {
            section = "home";
            gesture.clearEverything();

            
        }

        
    }
        
        
    
    
    
    if(section == "arpControl") {
        
        if(gesture.bluePressed == true) {
            ArpSpeed = gesture.control(ArpSpeed, gesture.blueButton, -gesture.xAccel, 0, 10, 0.02);
        }
        
        if(gesture.redPressed == true) {
            ArpCounter++;
            ArpOctaves = (int)gesture.control(ArpOctaves, gesture.redButton, -gesture.xAccel, 1, 4, 0.002);
        }
        
        if(gesture.blueReleased == true) {
            for(int i = 0; i < 12; i++) {
                voice[i].arpSpeed = ArpSpeed;
                arpspd = ofToString(ArpSpeed);
            }
        }
        
        if(gesture.redReleased == true && ArpCounter > 25) {
            for(int i = 0; i < 12; i++) {
                voice[i].numOctaves = ArpOctaves;
                arpoctves = ofToString(ArpOctaves);
                ArpCounter = 0;
            }
        } else if(gesture.redReleased == true && ArpCounter <= 25) {
            section = "arpSelect";
            ArpCounter = 0;
        }
        
        
        
    }
    
    
    if(section == "FXSelect") {
        
        if(gesture.redReleased == true) {
            section = "home";
        }
        
    }
    
    
    if(section == "chorusControl") {
        
        
        
    }
    
    
    if(section == "delayControl") {
        
        
        
    }
    
    
    if(section == "reverbControl") {
     
        
        
    }

}



//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){
    
}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){
    
}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){
    
}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){
    
}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){
    
}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){
    
}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){
    
}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){
    
}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){
    
}
// Draw current settings, depending on the section. 
void ofApp::displayCurrentSettings() {

    ofSetColor(255, 240);
    int height = ofGetHeight()-5;
    
    if(section == "home") {
        ofDrawBitmapString("expresSynth Home", 100, height);
    }
    
    if(section == "oscSelect" || section == "oscControl") {

        
        string osc1 = "Osc 1: " + osc1type;
        ofDrawBitmapString(osc1, 20, height);
 
        string osc2 = "Osc 2: " + osc2type + " Pitch: " + osc2semi;
        ofDrawBitmapString(osc2, 160, height);
        
        string osc3 = "Osc 3: " + osc3type + " Pitch: " + osc3semi;
        ofDrawBitmapString(osc3, 445, height);
        
        string osc4 = "Osc 4: " + osc4type + " Pitch: " + osc4semi;
        ofDrawBitmapString(osc4, 730, height);
    }
    
    if(section == "envelopeControl") {
        
        string atck = "Amp Attack: " + ampAttck;
        ofDrawBitmapString(atck, 195, height);
        
        string rlse = "Amp Release: " + ampRelse;
        ofDrawBitmapString(rlse, 695, height);
        
    }
    
    if(section == "filterSelect" || section == "filterControl" || section == "filterAutomation") {
        
        string typ = "Filter Type: " + filterTyp;
        ofDrawBitmapString(typ, 95, height);
        
        string ctf = "Cutoff: " + cutoff;
        ofDrawBitmapString(ctf, 265, height);
        
        string rs = "Resonance: " + res;
        ofDrawBitmapString(rs, 380, height);
        
        string atata = "Attack: " + filterAttck;
        ofDrawBitmapString(atata, 505, height);
        
        string release = "Release: " + filterRlse;
        ofDrawBitmapString(release, 630, height);
        
        string sustain = "Sustain: " + filterSstn;
        ofDrawBitmapString(sustain, 760, height);
        
    }
    
    if(section == "LFOControl") {
        string lfos = "LFO Speed: " + lfospd + " Hz.";
        ofDrawBitmapString(lfos, 195, height);
        
        string lfod = "LFO Depth: " + lfodpth;
        ofDrawBitmapString(lfod, 695, height);
    }
    
    if(section == "portaControl") {
        string portas = "Portamento Speed: " + portaspd;
        ofDrawBitmapString(portas, 430, height);
    }
    
    if(section == "tremControl") {
        string trems = "Tremolo Speed: " + tremspd + " Hz.";
        ofDrawBitmapString(trems, 195, height);
        
        string tremd = "Tremolo Depth: " + tremdpth + " Hz.";
        ofDrawBitmapString(tremd, 695, height);
    }
    
    if(section == "arpSelect" || section == "arpControl") {
        string arpspf = "Arpeggiator Speed: " + arpspd + " Hz.";
        ofDrawBitmapString(arpspf, 100, height);
        
        string aprmd = "Arpeggiator Mode: " + arptyp;
        ofDrawBitmapString(aprmd, 430, height);
        
        string arpdehrg = "Arpeggiator Octaves: " + arpoctves;
        ofDrawBitmapString(arpdehrg, 735, height);
    }
    
    
}

//--------------------------------------------------------------
void ofApp::drawTitles() {
    if(section == "title") {
        interface.title();
    }
    if(section == "instructions") {
        interface.instructions();
    }
    if(section == "calibration") {
        if(calibrationIndex == 1) {
            interface.calibration(1, 0, 0, 0, 0, 0, 0, 0, 0);
        } else if(calibrationIndex == 2) {
            interface.calibration(0, 1, 0, 0, 0, 0, 0, 0, 0);
        } else if(calibrationIndex == 3) {
            interface.calibration(0, 0, 1, 0, 0, 0, 0, 0, 0);
        } else if(calibrationIndex == 4) {
            interface.calibration(0, 0, 0, 1, 0, 0, 0, 0, 0);
        } else if(calibrationIndex == 5) {
            interface.calibration(0, 0, 0, 0, 1, 0, 0, 0, 0);
        } else if(calibrationIndex == 6) {
            interface.calibration(0, 0, 0, 0, 0, 1, 0, 0, 0);
        } else if(calibrationIndex == 7) {
            interface.calibration(0, 0, 0, 0, 0, 0, 1, 0, 0);
        } else if(calibrationIndex == 8) {
            interface.calibration(0, 0, 0, 0, 0, 0, 0, 1, 0);
        } else if(calibrationIndex == 9) {
            interface.calibration(0, 0, 0, 0, 0, 0, 0, 0, 1);
        }
    }
    if(section == "home") {
        interface.homeSec();
    }
    if(section == "oscSelect") {
        interface.oscSelect();
    }
    if(section == "oscControl") {
        interface.oscControl();
    }
    if(section == "envelopeControl") {
        interface.envelopeControl();
    }
    if(section == "filterSelect") {
        interface.filterSelect();
    }
    if(section == "filterControl") {
        interface.filterControl();
    }
    if(section == "filterAutomation") {
        interface.filterAutomation();
    }
    if(section == "LFOSelect") {
        interface.LFOSelect();
    }
    if(section == "LFOControl") {
        interface.LFOControl();
    }
    if(section == "portaControl") {
        interface.portaControl();
    }
    if(section == "tremControl") {
        interface.tremControl();
    }
    if(section == "arpSelect") {
        interface.arpSelect();
    }
    if(section == "arpControl") {
        interface.arpControl();
    }
    if(section == "FXSelect") {
        interface.FXSelect();
    }
    if(section == "chorusControl") {
        interface.chorusControl();
    }
    if(section == "delayControl") {
        interface.delayControl();
    }
    if(section == "reverbControl") {
        interface.reverbControl();
    }
}

void ofApp::setupStrings() {
    
    osc1type = "Sine";
    osc2type = "Off";
    osc3type = "Off";
    osc4type = "Off";
    osc2semi = "0";
    osc3semi = "0";
    osc4semi = "0";
    ampAttck = "1000";
    ampRelse = "1000";
    filterTyp = "Lores";
    cutoff = ofToString(filterCutoff);
    res = ofToString(filterRes);
    filterAttck = ofToString(filterAttack);
    filterRlse = ofToString(filterRelease);
    filterSstn = ofToString(filterSustain);
    lfospd = ofToString(LFOSpeed);
    lfodpth = ofToString(LFODepth);
    portaspd = ofToString(PortaSpeed);
    tremspd = ofToString(TremSpeed);
    tremdpth = ofToString(TremDepth);
    arptyp = "Up";
    arpspd = ofToString(ArpSpeed);
    arpoctves = ofToString(ArpOctaves);
    chorusspd = "0";
    chorusdpth = "0";
    delaytme = "0";
    delayfb = "0";
    reverbamt = "0";
    
}
