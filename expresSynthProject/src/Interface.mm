//
//  Interface.mm
//  maximTest
//
//  Created by Tom Holmes on 16/03/2017.
//
//

#include "Interface.h"
#include "ofApp.h"
#include "SynthVoice.h"

Interface::Interface() {
    
}

void Interface::setupUI() {
    // Load fonts
    titleText.loadFont("Engcomica.otf", 96);
    headerText.loadFont("Engcomica.otf", 42);
    normalText.loadFont("Engcomica.otf", 32);
    smallText.loadFont("Engcomica.otf", 20);
    verySmallText.loadFont("Engcomica.otf", 16);
    
}

void Interface::loadGifs() {
    // Load Gif movies
    triangle.loadMovie("movies/triangleGif.mp4");
    sine.loadMovie("movies/sineGif.mp4");
    saw.loadMovie("movies/sawGif.mp4");
    arp.loadMovie("movies/arpGif.mp4");
    lineUp.loadMovie("movies/lineUpGif.mp4");
    lineDown.loadMovie("movies/lineDownGif.mp4");
    FX.loadMovie("movies/FXGif.mp4");
    singleLR.loadMovie("movies/singleLRControl.mp4");
    singleUp.loadMovie("movies/singleUpControl.mp4");
    singleDown.loadMovie("movies/singleDownControl.mp4");
    bothUp.loadMovie("movies/bothUpControl.mp4");
    bothDown.loadMovie("movies/bothDownControl.mp4");
    noise.loadMovie("movies/noiseEllipse.mp4");
    square.loadMovie("movies/squareGif.mp4");
    triRed.loadMovie("movies/triangleGifRed.mp4");
    sineRed.loadMovie("movies/sineGifRed.mp4");
    FXRed.loadMovie("movies/FXGifRed.mp4");
    CLRRed.loadMovie("movies/singleLRControlRed.mp4");
    singleUpRed.loadMovie("movies/singleUpRed.mp4");
    singleDownRed.loadMovie("movies/singleDownRed.mp4");
    
    
//    triangle.play();
//    sine.play();
//    saw.play();
//    arp.play();
//    lineUp.play();
//    lineDown.play();
//    FX.play();
//    singleLR.play();
//    singleUp.play();
//    singleDown.play();
//    bothUp.play();
//    bothDown.play();
//    noise.play();
//    square.play();
//    triRed.play();
//    sineRed.play();
//    FXRed.play();
//    CLRRed.play();
//    singleUpRed.play();
//    singleDownRed.play();
    
}

void Interface::updateUI() {
    
}

// Drawgif function, allows changing of position, size, speed and transparency.
void Interface::drawGif(ofVideoPlayer insertGifName, int xPos, int yPos, string title, float speed, int transparency, int vidDim) {
    ofSetColor(0, transparency);
    verySmallText.drawString(title, xPos + (60 - verySmallText.stringWidth(title)/2), yPos);
    ofSetColor(255, 255, 255, transparency);
    insertGifName.play();
    insertGifName.draw(xPos, yPos, vidDim, vidDim);
    insertGifName.setSpeed(speed);
    insertGifName.update();
    ofSetColor(0);
}

void Interface::drawGraphic() {
    ofSetColor(179, 0, 134, 40);
    ofDrawRectangle(780, 0, 20, 650);
    ofSetColor(0, 255, 0, 40);
    ofDrawRectangle(820, 0, 20, 650);
    ofSetColor(0, 0, 255, 40);
    ofDrawRectangle(860, 0, 20, 650);
    ofSetColor(255, 255, 0, 40);
    ofDrawRectangle(900, 0, 20, 650);
    ofSetColor(255, 0, 0, 40);
    ofDrawRectangle(940, 0, 20, 650);
}

void Interface::drawString(string words, int xPos, int yPos) {
    
}

void Interface::drawCenterString(string words, int xPos, int yPos) {
    
}

// Each section has an interface function that is drawn when that section is active. These functions contain all graphics code for drawing the titles and gifs.

void Interface::title() {
    
    ofSetColor(0);
    string title = "expresSynth";
    titleText.drawString(title, ofGetWidth()/2 - (titleText.stringWidth(title)/2), ofGetHeight()/2);
    string intro = "A 12 Voice Quad VCO Gestural Expressional Synth Extravaganza";
    smallText.drawString(intro, ofGetWidth()/2 - (smallText.stringWidth(intro)/2), 360);
    string pressBlue = "press the Space Button to start";
    verySmallText.drawString(pressBlue, ofGetWidth()/2 - (verySmallText.stringWidth(pressBlue)/2), 570);
    
    drawGif(sine, 60, 400, "", 1.0, 255, 120);
    drawGif(triangle, 210, 400, "", 1.0, 255, 120);
    drawGif(square, 360, 400, "", -1.0, 255, 120);
    drawGif(saw, 510, 400, "", -1.0, 255, 120);
    drawGif(arp, 660, 400, "", 1.0, 255, 120);
    drawGif(noise, 800, 400, "", 1.0, 255, 120);
    
}

void Interface::instructions() {
    ofSetColor(0);
    int spacing = 40;
    string instrtitle = "instructions";
    headerText.drawString(instrtitle, ofGetWidth()/2 - (headerText.stringWidth(instrtitle)/2), 100);
    string line1 = "expresSynth is a software synth controlled with a handheld controller that recognises gestures and movement.";
    smallText.drawString(line1, ofGetWidth()/2 - (smallText.stringWidth(line1)/2), 130+(1*spacing));
    string line2 = "the movements you make to control the synth are shown by animated gifs. each gif has a blue or red button that";
    smallText.drawString(line2, ofGetWidth()/2 - (smallText.stringWidth(line2)/2), 130+(2*spacing));
    string line3 = "shows which button on the controller to press.";
    smallText.drawString(line3, ofGetWidth()/2 - (smallText.stringWidth(line3)/2), 130+(3*spacing));
    string line4 = "you can make selections, ie which waveform you want by drawing shapes, or change parameters, ie amplifier attack";
    smallText.drawString(line4, ofGetWidth()/2 - (smallText.stringWidth(line4)/2), 130+(4*spacing));
    string line5 = "by movements, either to the left or right or up or down, depending on what the animation shows.";
    smallText.drawString(line5, ofGetWidth()/2 - (smallText.stringWidth(line5)/2), 130+(5*spacing));
    string line6 = "to move back a section at any point, tap the red button and wait for the section to change.";
    smallText.drawString(line6, ofGetWidth()/2 - (smallText.stringWidth(line6)/2), 130+(6*spacing));
    string line7 = "use the a, w, s, e, d, f, t, g, y, h, u, j and k keys to play through an octave of notes.";
    smallText.drawString(line7, ofGetWidth()/2 - (smallText.stringWidth(line7)/2), 130+(7*spacing));
    string line8 = "the current settings of the synthesizer are shown in white writing at the bottom of the screen.";
    smallText.drawString(line8, ofGetWidth()/2 - (smallText.stringWidth(line8)/2), 130+(8*spacing));
    string line9 = "on the next page, you need to calibrate the controller by drawing each shape, followed by pressing";
    smallText.drawString(line9, ofGetWidth()/2 - (smallText.stringWidth(line9)/2), 130+(9*spacing));
    string line10 = "the space bar. onece this is complete, you're ready to use the synth!";
    smallText.drawString(line10, ofGetWidth()/2 - (smallText.stringWidth(line10)/2), 130+(10*spacing));
    
    string pressSpace = "press the space bar to begin calibration.";
    verySmallText.drawString(pressSpace, ofGetWidth()/2 - (verySmallText.stringWidth(pressSpace)/2), 570);
}

void Interface::calibration(int one, int two, int three, int four, int five, int six, int seven, int eight, int nine) {
    ofSetColor(0);
    string calibration = "calibration...";
    headerText.drawString(calibration, ofGetWidth()/2 - (headerText.stringWidth(calibration)/2), 100);
    
    drawGif(sine, 100, 160, "1.", one, 255 + ((one-1)*205), 120);
    drawGif(triangle, 435, 160, "2.", two, 255 + ((two-1)*205), 120);
    drawGif(square, 780, 160, "3.", -three, 255 + ((three-1)*205), 120);
    drawGif(saw, 100, 310, "4.", -four, 255 + ((four-1)*205), 120);
    drawGif(arp, 435, 310, "5.", five, 255 + ((five-1)*205), 120);
    drawGif(noise, 780, 310, "6.", six, 255 + ((six-1)*205), 120);
    drawGif(FX, 100, 460, "7.", -seven, 255 + ((seven-1)*205), 120);
    drawGif(lineUp, 435, 460, "8.", eight, 255 + ((eight-1)*205), 120);
    drawGif(lineDown, 780, 460, "9.", nine, 255 + ((nine-1)*205), 120);
    
    
}

void Interface::homeSec() {
    ofSetColor(0);
    drawHeadings(transparency1, transparency1, transparency1, transparency1, transparency1, transparency1, transparency1, 1, 1, 1, 1, 1, 1);
    waveformSeq(20, 450);
    ofSetColor(0, 200);
    verySmallText.drawString("Add/remove oscillators", 30, 300);
    verySmallText.drawString("Select waveform", 30, 350);
    verySmallText.drawString("Change oscillator pitch", 30, 400);
    
    verySmallText.drawString("Change attack/release", 200, 300);
    
    verySmallText.drawString("Select filter type", 375, 300);
    verySmallText.drawString("Change cutoff/res", 375, 350);
    verySmallText.drawString("Change automation", 375, 400);
    
    verySmallText.drawString("LFO Parameters", 520, 300);
    verySmallText.drawString("Portamento Parameters", 520, 350);
    verySmallText.drawString("Tremolo Parameters", 520, 400);
    
    verySmallText.drawString("Select Arp Mode", 700, 300);
    verySmallText.drawString("Change Arp Speed", 700, 350);
    verySmallText.drawString("Change Octaves", 700, 400);
    
    verySmallText.drawString("Chorus Settings", 855, 300);
    verySmallText.drawString("Delay Settings", 855, 350);
    verySmallText.drawString("Reverb Settings", 855, 400);
    
    
}

void Interface::oscSelect() {
    drawHeadings(transparency1, transparency2, transparency2, transparency2, transparency2, transparency2, transparency2, 2, 1, 1, 1, 1, 1);
    smallText.drawString("Oscillator Waveform Selection", 60, 290);
    drawGif(sine, 60, 330, "Sine", 1.0, 255, 100);
    drawGif(triangle, 210, 330, "Triangle", 1.0, 255, 100);
    drawGif(square, 360, 330, "Square", -1.0, 255, 100);
    drawGif(saw, 490, 330, "Saw", -1.0, 255, 100);
    drawGif(noise, 630, 330, "Noise", 1.0, 255, 100);
    waveformSeq(20, 450);
}

void Interface::oscControl() {
    drawHeadings(transparency1, transparency2, transparency2, transparency2, transparency2, transparency2, transparency2, 3, 1, 1, 1, 1, 1);
    smallText.drawString("Oscillator Controls", 60, 290);
    drawGif(singleLR, 60, 330, "Increase/Lower Osc Pitch", 1.0, 255, 100);
    drawGif(singleUp, 210, 330, "Add Osc", 1.0, 255, 100);
    drawGif(singleDown, 360, 330, "Remove Osc", 1.0, 255, 100);
    waveformSeq(20, 450);
}

void Interface::envelopeControl() {
    drawHeadings(transparency2, transparency1, transparency2, transparency2, transparency2, transparency2, transparency2, 1, 3, 1, 1, 1, 1);
    smallText.drawString("Amplifier Envelope Parameters", 60, 290);
    drawGif(singleLR, 60, 330, "Attack Longer/Shorter", 1.0, 255, 100);
    drawGif(CLRRed, 240, 330, "Release Shorter/Longer", 1.0, 255, 100);
    waveformSeq(20, 450);
}

void Interface::filterSelect() {
    drawHeadings(transparency2, transparency2, transparency1, transparency2, transparency2, transparency2, transparency2, 1, 1, 2, 1, 1, 1);
    smallText.drawString("Filter Type Selection", 60, 290);
    waveformSeq(20, 450);
    drawGif(lineUp, 60, 330, "Hi Pass", 1.0, 255, 100);
    drawGif(lineDown, 210, 330, "Lo Pass", 1.0, 255, 100);
    drawGif(triRed, 360, 330, "Lores", 1.0, 255, 100);
    drawGif(FXRed, 510, 330, "Hires", -1.0, 255, 100);
    drawGif(sineRed, 660, 330, "Automation", 1.0, 255, 100);
}

void Interface::filterControl() {
    drawHeadings(transparency2, transparency2, transparency1, transparency2, transparency2, transparency2, transparency2, 1, 1, 3, 1, 1, 1);
    smallText.drawString("Filter Controls", 60, 290);
    drawGif(singleLR, 60, 330, "Cutoff Lower/Higher", 1.0, 255, 100);
    drawGif(CLRRed, 240, 330, "Resonance Lower/Higher", 1.0, 255, 100);
    waveformSeq(20, 450);
}

void Interface::filterAutomation() {
    drawHeadings(transparency2, transparency2, transparency1, transparency2, transparency2, transparency2, transparency2, 1, 1, 3, 1, 1, 1);
    smallText.drawString("Filter Automation Controls", 60, 290);
    drawGif(singleLR, 60, 330, "Attack Longer/Shorter", 1.0, 255, 100);
    drawGif(CLRRed, 240, 330, "Release Shorter/Longer", 1.0, 255, 100);
    drawGif(singleUp, 390, 330, "Increase Sustain", 1.0, 255, 100);
    drawGif(singleDown, 540, 330, "Decrease Sustain", 1.0, 255, 100);
    waveformSeq(20, 450);
}

void Interface::LFOSelect() {
    drawHeadings(transparency2, transparency2, transparency2, transparency1, transparency2, transparency2, transparency2, 1, 1, 1, 2, 1, 1);
    smallText.drawString("Effect Selection", 60, 290);
    waveformSeq(20, 450);
    drawGif(sine, 60, 330, "LFO", 1.0, 255, 100);
    drawGif(square, 210, 330, "Portamento", -1.0, 255, 100);
    drawGif(FX, 360, 330, "Tremolo", -1.0, 255, 100);
}

void Interface::LFOControl() {
    drawHeadings(transparency2, transparency2, transparency2, transparency1, transparency2, transparency2, transparency2, 1, 1, 1, 3, 1, 1);
    smallText.drawString("LFO Controls", 60, 290);
    waveformSeq(20, 450);
    drawGif(singleLR, 60, 330, "Faster/Slower Speed", 1.0, 255, 100);
    drawGif(CLRRed, 210, 330, "Decrease/Increase Depth", 1.0, 255, 100);

}

void Interface::portaControl() {
    drawHeadings(transparency2, transparency2, transparency2, transparency1, transparency2, transparency2, transparency2, 1, 1, 1, 3, 1, 1);
    smallText.drawString("Portamento Controls", 60, 290);
    waveformSeq(20, 450);
    drawGif(singleLR, 60, 330, "Faster/Slower Speed", 1.0, 255, 100);
}

void Interface::tremControl() {
    drawHeadings(transparency2, transparency2, transparency2, transparency1, transparency2, transparency2, transparency2, 1, 1, 1, 3, 1, 1);
    smallText.drawString("Tremolo Controls", 60, 290);
    waveformSeq(20, 450);
    drawGif(singleLR, 60, 330, "Faster/Slower Speed", 1.0, 255, 100);
    drawGif(CLRRed, 210, 330, "Decrease/Increase Depth", 1.0, 255, 100);
}

void Interface::arpSelect() {
    drawHeadings(transparency2, transparency2, transparency2, transparency2, transparency1, transparency2, transparency2, 1, 1, 1, 1, 2, 1);
    smallText.drawString("Arpeggiator Type Selection", 60, 290);
    waveformSeq(20, 450);
    drawGif(lineUp, 60, 330, "Up Mode", 1.0, 255, 100);
    drawGif(lineDown, 210, 330, "Down Mode", 1.0, 255, 100);
    drawGif(sineRed, 360, 330, "Up/Down Mode", 1.0, 255, 100);
}

void Interface::arpControl() {
    drawHeadings(transparency2, transparency2, transparency2, transparency2, transparency1, transparency2, transparency2, 1, 1, 1, 1, 3, 1);
    smallText.drawString("Arpeggiator Controls", 60, 290);
    waveformSeq(20, 450);
    drawGif(singleLR, 60, 330, "Increase/Decrease Speed", 1.0, 255, 100);
    drawGif(singleUpRed, 210, 330, "Add octaves", 1.0, 255, 100);
    drawGif(singleDownRed, 360, 330, "Remove Octaves", 1.0, 255, 100);
}

void Interface::FXSelect() {
    drawHeadings(transparency2, transparency2, transparency2, transparency2, transparency2, transparency1, transparency2, 1, 1, 1, 1, 1, 2);
    smallText.drawString("Effect Selection", 60, 290);
    waveformSeq(20, 450);
    drawGif(sineRed, 60, 330, "Chorus", 1.0, 255, 100);
    drawGif(saw, 210, 330, "Delay", -1.0, 255, 100);
    drawGif(FX, 360, 330, "Reverb", 1.0, 255, 100);
}

void Interface::chorusControl() {
    drawHeadings(transparency2, transparency2, transparency2, transparency2, transparency2, transparency1, transparency2, 1, 1, 1, 1, 1, 3);
    smallText.drawString("Chorus Controls", 60, 290);
    waveformSeq(20, 450);
    drawGif(singleLR, 60, 330, "Speed", 1.0, 255, 100);
    drawGif(singleUp, 210, 330, "Increase Depth", 1.0, 255, 100);
    drawGif(singleDown, 360, 330, "Decrease Depth", 1.0, 255, 100);
}

void Interface::delayControl() {
    drawHeadings(transparency2, transparency2, transparency2, transparency2, transparency2, transparency1, transparency2, 1, 1, 1, 1, 1, 3);
    smallText.drawString("Delay Controls", 60, 290);
    waveformSeq(20, 450);
    drawGif(singleLR, 60, 330, "Delay Time", 1.0, 255, 100);
    drawGif(singleUp, 210, 330, "Increase FB", 1.0, 255, 100);
    drawGif(singleDown, 360, 330, "Decrease FB", 1.0, 255, 100);
}

void Interface::reverbControl() {
    drawHeadings(transparency2, transparency2, transparency2, transparency2, transparency2, transparency1, transparency2, 1, 1, 1, 1, 1, 3);
    smallText.drawString("Reverb Controls", 60, 290);
    waveformSeq(20, 450);
    drawGif(singleUp, 60, 330, "More Reverb", 1.0, 255, 100);
    drawGif(singleDown, 210, 330, "Less Reverb", 1.0, 255, 100);
}

// color: 1 = black, 2 = blue, 3 = red
void Interface::drawHeadings(int t1, int t2, int t3, int t4, int t5, int t6, int tTitle, int color1, int color2, int color3, int color4, int color5, int color6) {
    
    ofSetColor(0, tTitle);
    headerText.drawString(home, ofGetWidth()/2 - (headerText.stringWidth(home)/2), 75);
    
    if(color1 == 1 ) { ofSetColor(0, t1); } else if(color1 == 2) { ofSetColor(0, 0, 255); } else if(color1 == 3) { ofSetColor(255, 0, 0); }
    normalText.drawString(osc, 100 - (normalText.stringWidth(osc)/2), 150);
    if(t1 == 255) {
        drawGif(sine, 100 - (120/2), 150, "", 1.0, t1, 120);
    } else {
        drawGif(sine, 100 - (120/2), 150, "", 0, t1, 120);
    }
    if(color2 == 1 ) { ofSetColor(0, t2); } else if(color2 == 2) { ofSetColor(0, 0, 255); } else if(color2 == 3) { ofSetColor(255, 0, 0); }
    normalText.drawString(envelope, 260 - (normalText.stringWidth(envelope)/2), 150);
    if(t2 == 255) {
        drawGif(triangle, 260 - (120/2), 150, "", 1.0, t2, 120);
    } else {
        drawGif(triangle, 260 - (120/2), 150, "", 0, t2, 120);
    }
    if(color3 == 1 ) { ofSetColor(0, t3); } else if(color3 == 2) { ofSetColor(0, 0, 255); } else if(color3 == 3) { ofSetColor(255, 0, 0); }
    normalText.drawString(filters, 420 - (normalText.stringWidth(filters)/2), 150);
    if(t3 == 255) {
        drawGif(square, 420 - (120/2), 150, "", -1.0, t3, 120);
    } else {
        drawGif(square, 420 - (120/2), 150, "", 0, t3, 120);
    }
    if(color4 == 1 ) { ofSetColor(0, t4); } else if(color4 == 2) { ofSetColor(0, 0, 255); } else if(color4 == 3) { ofSetColor(255, 0, 0); }
    normalText.drawString(LFO, 580 - (normalText.stringWidth(LFO)/2), 150);
    if(t4 == 255) {
        drawGif(noise, 580 - (120/2), 150, "", 1.0, t4, 120);
    } else {
        drawGif(noise, 580 - (120/2), 150, "", 0, t4, 120);
    }
    if(color5 == 1 ) { ofSetColor(0, t5); } else if(color5 == 2) { ofSetColor(0, 0, 255); } else if(color5 == 3) { ofSetColor(255, 0, 0); }
    normalText.drawString(arpt, 740 - (normalText.stringWidth(arpt)/2), 150);
    if(t5 == 255) {
        drawGif(saw, 740 - (120/2), 150, "", -1.0, t5, 120);
    } else {
        drawGif(saw, 740 - (120/2), 150, "", 0, t5, 120);
    }
    if(color6 == 1 ) { ofSetColor(0, t6); } else if(color6 == 2) { ofSetColor(0, 0, 255); } else if(color6 == 3) { ofSetColor(255, 0, 0); }
    normalText.drawString(FXt, 900 - (normalText.stringWidth(FXt)/2), 150);
    if(t6 == 255) {
        drawGif(FX, 900 - (120/2), 150, "", -1.0, t6, 120);
    } else {
        drawGif(FX, 900 - (120/2), 150, "", 0, t6, 120);
    }
}

void Interface::waveformSeq(int x, int y) {
    ofSetColor(240);
    ofDrawRectangle(x, y, ofGetWidth() - (2*x), 150);
    ofSetColor(255);
    ofDrawRectangle(ofGetWidth() - x - 255, y + 5, 250, 140);
    ofSetColor(0);
    ofDrawRectangle(0, ofGetHeight()-20, ofGetWidth(), 20);
    ofSetColor(255);

}
