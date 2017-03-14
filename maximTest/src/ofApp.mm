#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    ofBackground(255);
    ofEnableAlphaBlending();
    ofSetVerticalSync(true);
    
    sampleRate = 44100;
    bufferSize = 512;
    
    arp.loadMovie("movies/arpGif.mp4");
    circle.loadMovie("movies/circleGif.mp4");
    sine.loadMovie("movies/sineGif.mp4");
    singleUp.loadMovie("movies/singleUpGif.mp4");
    square.loadMovie("movies/squareGif.mp4");
    triangle.loadMovie("movies/triangleGif.mp4");
    
    arp.play();
    circle.play();
    sine.play();
    singleUp.play();
    square.play();
    triangle.play();
    
    titleText.loadFont("Engcomica.otf", 96);
    headerText.loadFont("Engcomica.otf", 42);
    normalText.loadFont("Engcomica.otf", 32);
    smallText.loadFont("Engcomica.otf", 22);
    verySmallText.loadFont("Engcomica.otf", 16);
    
    bluetooth.setup;
    
    ofxMaxiSettings::setup(sampleRate, 2, bufferSize);
    ofSoundStreamSetup(2, 2, this, sampleRate, bufferSize, 4);
    
}

//--------------------------------------------------------------
void ofApp::update(){
    
    xIn = [bluetooth xAccel];
    cout << xIn << endl;
    
    arp.update();
    circle.update();
    sine.update();
    singleUp.update();
    square.update();
    triangle.update();
    
    
}

//--------------------------------------------------------------
void ofApp::draw(){

    ofSetColor(255, 255, 255);
    arp.draw(60, 400, videoX, videoY);
    circle.draw(210, 400, videoX, videoY);
    sine.draw(360, 400, videoX, videoY);
    singleUp.draw(510, 400, videoX, videoY);
    square.draw(660, 400, videoX, videoY);
    triangle.draw(810, 400, videoX, videoY);
    
    ofSetColor(0);
    string title = "expresSynth";
    titleText.drawString(title, ofGetWidth()/2 - (titleText.stringWidth(title)/2), ofGetHeight()/2);
    string intro = "A 16 Voice Quad VCO Gestural Wireless Synth Extravaganza";
    smallText.drawString(intro, ofGetWidth()/2 - (smallText.stringWidth(intro)/2), 360);
    string clickToStart = "clickToBegin";
    verySmallText.drawString(clickToStart, ofGetWidth()/2 - (verySmallText.stringWidth(clickToStart)/2), 570);
    
}

void ofApp::audioOut(float * output, int bufferSize, int nChannels){
    
    for(int i = 0; i < bufferSize; i+=2) {
        
        output[i*nChannels    ] = voice[0].voicePlay() + voice[1].voicePlay() + voice[2].voicePlay() + voice[3].voicePlay();
        output[i*nChannels + 1] = voice[0].voicePlay() + voice[1].voicePlay() + voice[2].voicePlay() + voice[3].voicePlay();

    }
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

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
