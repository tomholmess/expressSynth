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
    
    gesture.setupSerial();
    
    ofxMaxiSettings::setup(sampleRate, 2, bufferSize);
    ofSoundStreamSetup(2, 2, this, sampleRate, bufferSize, 4);
    
}

//--------------------------------------------------------------
void ofApp::update(){
    
    gesture.valuesIn();
    
}

//--------------------------------------------------------------
void ofApp::draw(){

    drawTitles();
    
}

void ofApp::audioOut(float * output, int bufferSize, int nChannels){
    
    for(int i = 0; i < bufferSize; i+=2) {
        
    }
    
}

void ofApp::drawTitles() {
    if(section == "title") {
        interface.title();
    }
    
    if(section == "pairing") {
        interface.pairing();
    }
    
    if(section == "main") {
        interface.main();
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

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    if (key == '1') {
        section = "title";
    }
    if (key == '2') {
        section = "pairing";
    }
    if (key == '3') {
        section = "main";
    }
    if (key == '4') {
        if(section == "oscSelect") {
            section = "oscControl";
        } else {
            section = "oscSelect";
        }
    }
    if (key == '5') {
        section = "envelopeControl";
    }
    if (key == '6') {
        if(section == "filterSelect") {
            section = "filterControl";
        } else {
            section = "filterSelect";
        }
    }
    if (key == '7') {
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
    if (key == '8') {
        if(section == "arpSelect") {
            section = "arpControl";
        } else {
            section = "arpSelect";
        }
    }
    if (key == '9') {
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
    
    if(key == 'r') {
        gesture.vectorRecord();
    }
    
    if(key == 'a') {
        gesture.arpRecord();
    }
    
    if(key == 's') {
        gesture.sineRecord();
    }
    
    if(key == 'c') {
        gesture.circleRecord();
    }
    
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){
    if(key == 'r') {
        gesture.vectorNormalize(gesture.recordInit, gesture.recordLerp, gesture.recordFinal, gesture.NUM_VALUES);
    }
    
    if(key == 'a') {
        gesture.vectorNormalize(gesture.arpInit, gesture.arpLerp, gesture.arpFinal, gesture.NUM_VALUES);
    }
    
    if(key == 's') {
        gesture.vectorNormalize(gesture.sineInit, gesture.sineLerp, gesture.sineFinal, gesture.NUM_VALUES);
    }
    
    if(key == 'c') {
        gesture.vectorNormalize(gesture.circleInit, gesture.circleLerp, gesture.circleFinal, gesture.NUM_VALUES);
    }
    
    if(key == 'm') {
        gesture.vectorCompare(gesture.recordFinal, gesture.circleFinal);
    }
    
    if(key == 'b') {

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
