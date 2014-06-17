// Catch the Cubes
// by Topher6345
// http://github.com/topher6345/CatchTheCubes
// Copyright Christopher Saunders 2014
// http://creativecommons.org/licenses/by-nc-sa/4.0/

import processing.opengl.*;
import ddf.minim.*;

final int NUMLEVELS = 128;

// Models
Score  score = new Score();
SoundEvent soundEvent = new SoundEvent(-1);

// Controllers
MainMenuViewController mainMenuViewController = new MainMenuViewController();
GamePlayViewController gamePlayViewController = new GamePlayViewController();
GameOverViewController gameOverViewController = new GameOverViewController();
TutorialViewController tutorialViewController = new TutorialViewController();

// Color Scheme
// https://kuler.adobe.com/create/color-wheel/?base=2&rule=Custom&selected=4&name=My%20Kuler%20Theme&mode=rgb&rgbvalues=0,0.6438629248263169,0.8,0,0.95,0.13957146750274205,1,0.8255421983520892,0.24273734474390318,1,0.3203022337219924,0.25430558677822357,0.6522370672997568,0,0.8&swatchOrder=0,1,2,3,4
color[] g_colorPalette = {#00A4CC, #00F224, #FFD33E, #FF5241, #A600CC, };

float cubeSpeed;
int   levelNumber = 2;

// Change Difficulty Here
final float initCubeSpeed = 2;
final float speedIncrement = 1.02;

// Enum
int currentScreen;
final int MAIN_MENU  =  0;
final int PLAY_GAME  =  2;
final int GAME_OVER  = -1;
final int HOW_TO     =  1;

final int BUFFERSIZE = 512;

PFont font;

Minim minim = new Minim(this);
AudioSample catchSample;
AudioSample missSample;
AudioSample game_overSample;
AudioSample welcomeSample;

void setup(){
  size (800, 600, P3D);
  frameRate(60);
  background(0);
  smooth();
  font = loadFont("Futura-CondensedMedium-48.vlw");
  currentScreen = MAIN_MENU;

  catchSample     = minim.loadSample("catch.aif"    ,BUFFERSIZE);
  missSample      = minim.loadSample("miss.aif"     ,BUFFERSIZE);
  game_overSample = minim.loadSample("game_over.aif",BUFFERSIZE);
  welcomeSample   = minim.loadSample("welcome.aif"  ,BUFFERSIZE);
}

void draw(){

  background(0);

  switch(currentScreen) {

    case MAIN_MENU:
      mainMenuViewController.draw();
      break;

    case HOW_TO:
      tutorialViewController.draw(score);
      break;

    case PLAY_GAME:
      gamePlayViewController.draw(score);
      break;

    case GAME_OVER:
      gameOverViewController.draw(score);
      break;
  }
}

void stop(){
  super.stop();
}

int newSpeed(int rotation) {
  rotation = (int)(random(6)-3);
  while(rotation == 0 ) rotation = (int)(random(6)-3);
  return rotation;
}