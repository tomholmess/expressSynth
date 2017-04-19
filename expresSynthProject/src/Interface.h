//
//  Interface.hpp
//  maximTest
//
//  Created by Tom Holmes on 16/03/2017.
//
//

#pragma once

#ifndef Interface_h
#define Interface_h

#include "ofMain.h"

class Interface {
    
public:
    
    void setupUI();
    void loadGifs();
    void updateUI();
    void drawGif(ofVideoPlayer insertGifName, int xPos, int yPos, string title, float speed, int transparency, int vidDim);
    void drawGraphic();
    void drawString(string words, int xPos, int yPos);
    void drawCenterString(string words, int xPos, int yPos);
    
    void title();
    void instructions();
    void calibration();
    void homeSec();
    void oscSelect();
    void oscControl();
    void envelopeControl();
    void filterSelect();
    void filterControl();
    void filterAutomation();
    void LFOSelect();
    void LFOControl();
    void portaControl();
    void tremControl();
    void arpSelect();
    void arpControl();
    void FXSelect();
    void chorusControl();
    void delayControl();
    void reverbControl();
    void waveformSeq(int x, int y);
    
    void drawHeadings(int t1, int t2, int t3, int t4, int t5, int t6, int tTitle, int color1, int color2, int color3, int color4, int color5, int color6);
    int transparency1 = 255, transparency2 = 50;
    
    int i = 0;
    
    ofVideoPlayer triangle, triRed, sineRed, FXRed, CLRRed, sine, square, saw, arp, lineUp, lineDown, FX, singleLR, singleUp, singleDown, bothUp, bothDown, noise, singleUpRed, singleDownRed;
    //    int vidX = 120;
    //    int vidY = 120;
    
    string home = "home section";
    string osc = "osc";
    string filters = "filters";
    string envelope = "amp env";
    string LFO = "LFO/Porta";
    string arpt = "arp";
    string FXt = "FX";
    
    ofTrueTypeFont normalText, headerText, titleText, smallText, verySmallText;
    
    Interface();
    
};

#endif /* Interface_hpp */


