#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    ofBackground(255);
    ofEnableAlphaBlending();
    ofSetVerticalSync(true);
    
    sampleRate = 44100;
    bufferSize = 512;
    
    interface.setupUI();
    interface.loadGifs();
    
    for(int i = 0; i < 12; i++) {
        voice[i].setup();
        voice[i].setEnvelope(2000, 2000, 1.0, 2050);
    }
    
    gesture.setupSerial();
    
    ofxMaxiSettings::setup(sampleRate, 2, bufferSize);
    ofSoundStreamSetup(2, 2, this, sampleRate, bufferSize, 4);

    gesture.clearEverything();
    
}

//--------------------------------------------------------------
void ofApp::update(){
    
    gesture.valuesIn();
    
    gesture.buttonEvent();
    
    gestureSynthLink();
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    drawTitles();
    
}

void ofApp::audioOut(float * output, int bufferSize, int nChannels){
    
    for(int i = 0; i < bufferSize; i+=2) {
        
        output[i*nChannels    ] = voice[0].voicePlay();
        output[i*nChannels + 1] = voice[0].voicePlay();
        
    }
    
}



//--------------------------------------------------------------
void ofApp::keyPressed(int key){

    
    if (key == '1') {
        section = "title";
    }
    
    if(key == '2') {
        section = "instructions";
    }
    
    if(key == '3') {
        section = "calibration";
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
    
    if(key == 'p') {
        voice[0].pitch = 440;
        voice[0].ADSR.trigger = 1;
    }
    
}


//--------------------------------------------------------------
void ofApp::gestureSynthLink() {
  
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
        if(gesture.blueButton == 1) {
            gesture.record = gesture.shapeRecord(gesture.record);
            cout << gesture.record.size() << endl;
        }
        if(gesture.blueReleased == true && gesture.record.size() > 10) {
            gesture.record = gesture.vectorNormalize(gesture.record, gesture.NUM_VALUES);
            cout << gesture.record.size() << endl;
            
            int gestureReturn = 0;
            gestureReturn = gesture.home();
            
            cout << gestureReturn << " " << gesture.sineDiff << endl;
            
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
            gestureReturn = 0;
            gesture.clearEverything();
        }
        
    }
    
    if(section == "oscSelect") {
        if(gesture.blueButton == 1) {
            gesture.record = gesture.shapeRecord(gesture.record);
        } else if(gesture.blueReleased == true && gesture.record.size() > 10) {
            gesture.record = gesture.vectorNormalize(gesture.record, gesture.NUM_VALUES);
            
            int gestureReturn = 0;
            gestureReturn = gesture.oscSelect();
            
            if(oscCurrentControl == 1) {
                if(gestureReturn == 1) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveOne = 0;
                    }
                } else if(gestureReturn == 2) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveOne = 1;
                    }
                } else if(gestureReturn == 3) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveOne = 2;
                    }
                } else if(gestureReturn == 4) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveOne = 3;
                    }
                } else if(gestureReturn == 5) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveOne = 4;
                    }
                }
            }
            
            if(oscCurrentControl == 2) {
                if(gestureReturn == 1) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveTwo = 0;
                    }
                } else if(gestureReturn == 2) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveTwo = 1;
                    }
                } else if(gestureReturn == 3) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveTwo = 2;
                    }
                } else if(gestureReturn == 4) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveTwo = 3;
                    }
                } else if(gestureReturn == 5) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveTwo = 4;
                    }
                }
            }
            
            if(oscCurrentControl == 3) {
                if(gestureReturn == 1) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveThree = 0;
                    }
                } else if(gestureReturn == 2) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveThree = 1;
                    }
                } else if(gestureReturn == 3) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveThree = 2;
                    }
                } else if(gestureReturn == 4) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveThree = 3;
                    }
                } else if(gestureReturn == 5) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveThree = 4;
                    }
                }
            }
            
            if(oscCurrentControl == 4) {
                if(gestureReturn == 1) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveFour = 0;
                    }
                } else if(gestureReturn == 2) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveFour = 1;
                    }
                } else if(gestureReturn == 3) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveFour = 2;
                    }
                } else if(gestureReturn == 4) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveFour = 3;
                    }
                } else if(gestureReturn == 5) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveFour = 4;
                    }
                }
            }
            
            gestureReturn = 0;
            gesture.clearEverything();
            
        } else if(gesture.redReleased == true && gesture.record.size() <= 10) {
            section = "home";
        }
        
        
        
    }
    
    if(section == "oscControl") {
        if(gesture.blueButton == 1) {
            
            if(oscCurrentControl == 1) {
                oscPitch = gesture.control(oscPitch, gesture.blueButton, gesture.xAccel, 110, 8800, oscPitch/80);
            } else if(oscCurrentControl == 2) {
                osc2Pitch = gesture.control(osc2Pitch, gesture.blueButton, gesture.xAccel, 110, 8800, osc2Pitch/80);
            } else if(oscCurrentControl == 3) {
                osc3Pitch = gesture.control(osc3Pitch, gesture.blueButton, gesture.xAccel, 110, 8800, osc3Pitch/80);
            }else if(oscCurrentControl == 4) {
                osc4Pitch = gesture.control(osc4Pitch, gesture.blueButton, gesture.xAccel, 110, 8800, osc4Pitch/80);
            }
            
            oscAddSub = gesture.control(oscAddSub, gesture.blueButton, gesture.yAccel, -100, 100, 1.);
            
        }
        
        if(gesture.blueReleased == true && oscCounter > 8) {
            
            for(int i = 0; i < 12; i++) {
                if(oscCurrentControl == 2) {
                    voice[i].waveTwoPitch = osc2Pitch;
                } else if(oscCurrentControl == 3) {
                    voice[i].waveThreePitch = osc3Pitch;
                }else if(oscCurrentControl == 4) {
                    voice[i].waveFourPitch = osc4Pitch;
                }
            }
            
            if(oscAddSub < -10) {
                if(oscCurrentControl == 2) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveTwo = 5;
                    }
                    oscCurrentControl = 1;
                } else if(oscCurrentControl == 3) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveThree = 5;
                    }
                    oscCurrentControl = 2;
                } else if(oscCurrentControl == 4) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveFour = 5;
                    }
                    oscCurrentControl = 3;
                }
            }
        }
        
        if(gesture.redButton == 1) {
            
            oscCounter++;
            oscAddSub = gesture.control(oscAddSub, gesture.redButton, gesture.yAccel, -100, 100, 1.);
            
        }
        
        if(gesture.redReleased == true && oscCounter > 8) {
            
            if(oscAddSub > 10) {
                
                oscCounter = 0;
                
                if(oscCurrentControl == 1) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveTwo = 0;
                    }
                    oscCurrentControl = 2;
                    section = "oscSelect";
                }
                if(oscCurrentControl == 2) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveThree = 0;
                    }
                    oscCurrentControl = 3;
                    section = "oscSelect";
                }
                if(oscCurrentControl == 3) {
                    for(int i = 0; i < 12; i++) {
                        voice[i].waveFour = 0;
                    }
                    oscCurrentControl = 4;
                    section = "oscSelect";
                }
        
            }
            
        } else if(gesture.redReleased == true && oscCounter <= 8) {
            section = "oscSelect";
        }
    }
    
    if(section == "envelopeControl") {
        
        if(gesture.redButton == 1 || gesture.blueButton == 1) {
            ampCounter++;
            ampAttack = gesture.control(ampAttack, gesture.blueButton, gesture.xAccel, 50, 3000, 2.5);
            ampRelease = gesture.control(ampRelease, gesture.redButton, gesture.xAccel, 50, 3000, 2.5);
            
            
        }
        
        if(gesture.redReleased == true && ampCounter <= 8) {
            section = "home";
        } else if((gesture.redReleased == true || gesture.blueReleased == true) && ampCounter > 8) {
            for(int i = 0; i < 12; i++) {
                voice[i].setEnvelope(ampAttack, 0.99, 0.99, ampRelease);
            }
            ampCounter = 0;
        }
        
    }
    

    if(section == "filterSelect") {
        if(gesture.blueButton == 1) {
            gesture.record = gesture.shapeRecord(gesture.record);
        } else if(gesture.blueReleased == true) {
            gesture.record = gesture.vectorNormalize(gesture.record, gesture.NUM_VALUES);
            
            int gestureReturn = 0;
            gestureReturn = gesture.filterSelect();
            
            if(gestureReturn == 1) {
                for(int i = 0; i < 12; i++) {
                    voice[i].VCF1Type = 2;
                }
            } else if(gestureReturn == 2) {
                for(int i = 0; i < 12; i++) {
                    voice[i].VCF1Type = 3;
                }
            }
            
            section = "filterControl";
            
            gestureReturn = 0;
            gesture.clearEverything();
            
        }
        
        if(gesture.redButton == 1) {
            gesture.record = gesture.shapeRecord(gesture.record);
        } else if(gesture.redReleased == true && gesture.record.size() > 10) {
            gesture.record = gesture.vectorNormalize(gesture.record, gesture.NUM_VALUES);
            
            int gestureReturn = 0;
            gestureReturn = gesture.filterSelectRed();
            
            if(gestureReturn == 1) {
                for(int i = 0; i < 12; i++) {
                    voice[i].VCF1Type = 0;
                }
            } else if(gestureReturn == 2) {
                for(int i = 0; i < 12; i++) {
                    voice[i].VCF1Type = 1;
                }
            }
            
            section = "filterControl";
            
            gestureReturn = 0;
            gesture.clearEverything();
            
        } else if(gesture.redReleased == true && gesture.record.size() <= 10) {
            section = "home";
        }
       
    }
    
    if(section == "filterControl") {
        
        if(gesture.redButton == 1 || gesture.blueButton == 1) {
            filterCounter++;
            if(voice[0].VCF1Type == 2 || voice[0].VCF1Type == 3) {
                filterCutoff = gesture.control(filterCutoff, gesture.blueButton, gesture.xAccel, 0.01, 0.9999, 0.01);
                filterRes = gesture.control(filterRes, gesture.redButton, gesture.xAccel, 0.01, 0.9999, 0.01);
            } else if(voice[0].VCF1Type == 0 || voice[0].VCF1Type == 1) {
                filterCutoff = gesture.control(filterCutoff, gesture.blueButton, gesture.xAccel, 50, 10000, 2.5);
                filterRes = gesture.control(filterRes, gesture.redButton, gesture.xAccel, 50, 10000, 2.5);
            }
            
        }
        
        if(gesture.redReleased == true && filterCounter <= 8) {
            section = "filterSelect";
        } else if((gesture.redReleased == true || gesture.blueReleased == true) && filterCounter > 8) {
            for(int i = 0; i < 12; i++) {
                voice[i].setFilterEnvelope(filterAttack, 0.99, 0.99, filterRelease);
            }
            filterCounter = 0;
        }

        
    }
    
    
    if(section == "filterAutomation") {
    
        if(gesture.redButton == 1 || gesture.blueButton == 1) {
            filterCounter++;
            filterAttack = gesture.control(filterAttack, gesture.blueButton, gesture.xAccel, 50, 3000, 2.5);
            filterRelease = gesture.control(filterRelease, gesture.redButton, gesture.xAccel, 50, 3000, 2.5);
        }
        
        if(gesture.redReleased == true && filterCounter <= 8) {
            section = "filterSelect";
        } else if((gesture.redReleased == true || gesture.blueReleased == true) && filterCounter > 8) {
            for(int i = 0; i < 12; i++) {
                voice[i].setFilterEnvelope(filterAttack, 0.99, 0.99, filterRelease);
            }
            filterCounter = 0;
        }
        
    }
    

    
    if(section == "LFOSelect") {
        
        if(gesture.blueButton == 1) {
            gesture.record = gesture.shapeRecord(gesture.record);
        }
        if(gesture.blueReleased == true ) {
            gesture.record = gesture.vectorNormalize(gesture.record, gesture.NUM_VALUES);
            
            int gestureReturn = 0;
            gestureReturn = gesture.LFOSelect();
            
            if(gestureReturn == 1) {
                section = "LFOControl";
            }
        
            if(gestureReturn == 2) {
                section = "tremControl";
            }
            
            gestureReturn = 0;
            gesture.clearEverything();
            
        }
        
        if(gesture.redButton == 1) {
            gesture.record = gesture.shapeRecord(gesture.record);
        }
        if(gesture.redReleased == true) {
            gesture.record = gesture.vectorNormalize(gesture.record, gesture.NUM_VALUES);
            
            int gestureReturn = 0;
            gestureReturn = gesture.LFOSelectRed();
            
            if(gestureReturn == 1) {
                section = "portaControl";
            }
            
            gestureReturn = 0;
            gesture.clearEverything();
            
        }
        
    }

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

    if(key == 'p') {
        voice[0].ADSR.trigger = 0;
    }
    
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

//--------------------------------------------------------------
void ofApp::drawTitles() {
    if(section == "title") {
        interface.title();
    }
    if(section == "instructions") {
        interface.instructions();
    }
    if(section == "calibration") {
        interface.calibration();
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
