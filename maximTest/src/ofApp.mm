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
    
    adafruit.setup(1, 9600);
    
    ofxMaxiSettings::setup(sampleRate, 2, bufferSize);
    ofSoundStreamSetup(2, 2, this, sampleRate, bufferSize, 4);
    
}

//--------------------------------------------------------------
void ofApp::update(){
    
    interface.drawGraphic();
    
// 10 and 13 are the ASCII values for new line and carriage return respectively
// I can see how this works in terms of splitting up an array of chars into their respective values
// Also I can no do the conversion from a char buffer to a float
// I just can't fill up a char[] with adafruit.readByte()!?!?
//
//    if ((char)adafruit.readByte() != 10 || (char)adafruit.readByte() != 13) {
//        char xAccel[] = "-2.31493945 -2.712 10.96";
    //   i.e. this doesnt work....
        // char xAccel[] = (char)adafruit.readByte();
    //  I've tried char xAccel[7] = (char)adafruit.readByte();
//        char* pEnd;
//        float xAcc, xAcc2;
//        xAcc = strtof(xAccel, &pEnd);
//        xAcc2 = strtof(pEnd, NULL);
//        cout << xAcc << " " << xAcc2 << endl;
//    }
    
    // This stopped everything from working entirely
//    while ((char)adafruit.readByte() != 10 || (char)adafruit.readByte() != 13) {
//        bufferIn.push_back(adafruit.readByte());
//    }
    
    // This is in conjunction with the above function and
//    if((char)adafruit.readByte() == 10 || (char)adafruit.readByte() == 13) {
//        string str(bufferIn.begin(), bufferIn.end());
//        char xAccel[] = (char)bufferIn;
//        
//    }
    

}

//--------------------------------------------------------------
void ofApp::draw(){

//    interface.drawGraphic();

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

void ofApp::audioOut(float * output, int bufferSize, int nChannels){
    
    for(int i = 0; i < bufferSize; i+=2) {
        
        output[i*nChannels    ] = voice[0].voicePlay() + voice[1].voicePlay() + voice[2].voicePlay() + voice[3].voicePlay();
        output[i*nChannels + 1] = voice[0].voicePlay() + voice[1].voicePlay() + voice[2].voicePlay() + voice[3].voicePlay();

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
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

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
