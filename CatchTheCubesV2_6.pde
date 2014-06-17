// Catch the Cubes
// by Topher6345
// http://github.com/topher6345/CatchTheCubes

import processing.opengl.*;
import ddf.minim.*;

final int NUMLEVELS = 128;

// Models
Score  score = new Score();
Events event = new Events(-1);

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
class MainMenuViewController {

  LightingContext lightingContext;
  SplashCubeView mainMenuBox;
  SubtitleBannerView subtitleBannerView;
  TitleBannerView titleBannerView;
  CubeView[] cubeViews;
  PlayButtonView playbuttonView;
  HowToPlayButtonView howToPlayButtonView;
  TSDotcomButtonView tSDotcomButtonView;

  MainMenuViewController(){
    lightingContext     = new LightingContext();
    mainMenuBox         = new SplashCubeView(0);
    subtitleBannerView  = new SubtitleBannerView(0);
    titleBannerView     = new TitleBannerView(0);
    cubeViews           = new CubeView[NUMLEVELS];
    playbuttonView      = new PlayButtonView();
    howToPlayButtonView = new HowToPlayButtonView();
    tSDotcomButtonView  = new TSDotcomButtonView();

    int rotation = 1;    

    for(int j=0; j < 40; j++) random(3);

    for (int i = 0; i < 4 ; i++){
      cubeViews[i] = new CubeView(90,// X initial Position
                             (int)(-(random(height/2))),// Y initial Position
                                       (int)random(4),// Color Index
                                        initCubeSpeed, 
                               ((int)(random(20, 40))),// 
                                  newSpeed(rotation));//Rotation Speed/Direction
    }
  };

  void draw() {
    lightingContext.render();  
    for(int i = 0; i < 4; i++) cubeViews[i].startCube();
    mainMenuBox.draw();   
    hint(DISABLE_DEPTH_TEST);      
    subtitleBannerView.draw();
    titleBannerView.draw();
    playbuttonView.draw();
    howToPlayButtonView.draw();
    // tSDotcomButtonView.draw();
    hint(ENABLE_DEPTH_TEST);
  }
}
class GamePlayViewController {
  
  LightingContext lightingContext;
  CubeView[] cubeViews;
  BackToMainMenuButton backToMainMenuButton;
  ScoreViewController scoreViewController;

  int l=1;
  int rotation = 1;    

  GamePlayViewController(){
    lightingContext      = new LightingContext();
    cubeViews            = new CubeView[NUMLEVELS];
    backToMainMenuButton = new BackToMainMenuButton();
    scoreViewController  = new ScoreViewController();

    for (int i = 1; i < NUMLEVELS ; i++){
      cubeViews[i] = new CubeView( (int)random(width),// X initial Position
                             (int)(-(random(height))),// Y initial Position
                                       (int)random(4),// Color Index
                                        initCubeSpeed, 
                               ((int)(random(20)+20)),// 
                                  newSpeed(rotation));//Rotation Speed/Direction
    }

  };

  void draw(Score score) {
    lightingContext.render();      
    for  (l = 1 ; l < (levelNumber); l++) cubeViews[l].moveCube(); 
    hint(DISABLE_DEPTH_TEST);
    scoreViewController.draw(score);   
    if (score.catchCount  > 9 && frameCount > event.how_to + frameRate * 5 ) {levelNumber++; score.missCount =0;score.catchCount=0;}
    hint(ENABLE_DEPTH_TEST);
    backToMainMenuButton.draw();
  }
}
class GameOverViewController {

  YourScoreView yourScoreView;
  GameOverView gameOverView;
  TSDotcomButtonView tSDotcomButtonView;

  GameOverViewController(){
    yourScoreView = new YourScoreView();
    gameOverView = new GameOverView();
    tSDotcomButtonView = new TSDotcomButtonView();
  };

  void draw(Score score) {
    yourScoreView.draw(score);
    gameOverView.draw();
    tSDotcomButtonView.draw();
    if((event.game_over+frameRate*2.5)  < frameCount && mousePressed) { currentScreen = MAIN_MENU;}    
  }
}
class TutorialViewController {

  CubeView[] cubeViews;
  ClickToPlayButtonView clickToPlayButtonView;
  ScoreViewController scoreViewController;

  int startPos;
  int inTextChapter = 1;
  float tutorialSplashOpacity = 255;
  boolean tutorialCatchFlag = false;
  int rotation = 1;   

  TutorialViewController(){
    tutorialSplashOpacity = 255;
    clickToPlayButtonView = new ClickToPlayButtonView();
    cubeViews             = new CubeView[NUMLEVELS];
    scoreViewController   = new ScoreViewController();

    for (int i = 1; i < NUMLEVELS ; i++){
      cubeViews[i] = new CubeView( (int)random(width),// X initial Position
                             (int)(-(random(height))),// Y initial Position
                                       (int)random(4),// Color Index
                                        initCubeSpeed, 
                               ((int)(random(20)+20)), 
                                  newSpeed(rotation));//Rotation Speed/Direction
    }
  }
  
  void draw(Score score) {   
    
    // Draw Cubes
    for  (int l = 1 ; l < (levelNumber); l++) cubeViews[l].moveCube(); 
    scoreViewController.draw(score);   

    // Pop up tutorial text
    if (inTextChapter == 1) {
      textAlign(CENTER);
      tutorialSplashOpacity-=2; 
      if (tutorialSplashOpacity < 1){ 
        inTextChapter = 2; 
        tutorialSplashOpacity = 255; 
      }
      text("How to Play", width/2, height/2);
    }
    if (inTextChapter == 2) {
      textAlign(CENTER);
      tutorialSplashOpacity--; 
      if (tutorialSplashOpacity < 1) { 
        inTextChapter = 3; 
        tutorialSplashOpacity = 255;
      }
      fill(255,255,255, (tutorialSplashOpacity*.5)+127 );
      text("Cubes are falling!", width/2, height/2);
    }
    if (inTextChapter == 3) {
      textAlign(CENTER);
      tutorialSplashOpacity--; 
      if (tutorialSplashOpacity < 1) { 
        inTextChapter = 4; 
        tutorialSplashOpacity = 255;
      }
      fill(255,255,255, (tutorialSplashOpacity*.5) + 127 );
      text("Catch them with the mouse.", width/2, height/2);
    }
    if(inTextChapter == 4 && event.how_to_unlock < frameRate * 5 + frameCount) {
      textAlign(CENTER);
      tutorialSplashOpacity--; 
      if (tutorialSplashOpacity < 1) { 
        inTextChapter = 5; 
        tutorialSplashOpacity = 255; 
        score.missCount = 9;      
      }
      fill(255,255,255, (tutorialSplashOpacity*.5) + 127 );
      text("Catch 10 and you advance", width/2, height*1/3);
      text("to the next level", width/2, height*2/3);          
    }   
    if(inTextChapter == 5 )
    {
      textAlign(CENTER);
      tutorialCatchFlag = false;
      fill(255,255,255, (tutorialSplashOpacity*.5)+127 );
      text("Miss 10 and it's", width/2, height*1/3);
      text("Game Over", width/2, height*2/3);
      clickToPlayButtonView.draw();
      }
    }     
}
class TSDotcomButtonView {

  TSDotcomButtonView(){};

  void draw() {
    if(mouseX > width/2 && 
       mouseX < ( (width/2) + 10) && 
       mouseY > height*7/8 && 
       mouseY < ( (height*7/8) + 20) )
      { 
        fill(#FFCA00);
        if(mousePressed) 
        {
          link("http://github.com/topher6345"); 
          stop();
          exit();
          return;
        }  
      }
    else{
    fill(255); 
    }
    text("github.com/topher6345", width/2, height*7/8);
  }
}
class HowToPlayButtonView {

  HowToPlayButtonView(){};

  void draw() {
    if(  mouseX < ((width/4) + 100)  &&
         mouseX > ((width/4) - 100)  &&
         mouseY < ((height*5/8))     &&
         mouseY > ((height*5/8) - 20)
      ){
       fill(#5De100);
       if(mousePressed) {
         currentScreen = HOW_TO; 
         event.how_to = frameCount; 
       }
      }
    else{
      fill(255);  
      }
      text("How to Play", width/4, height*5/8);
    }
}
class PlayButtonView {

  PlayButtonView(){};

  void draw() {
    if( mouseX < ((width*3/4) + 110) &&
        mouseX > ((width*3/4) - 110) &&
        mouseY < ((height*5/8))      &&
        mouseY > ((height*5/8) - 20)) {
        
        fill(g_colorPalette[1]);
        if(mousePressed) {
          score.reset();
          currentScreen = PLAY_GAME;
          event._catch = frameCount;    
        }
    } else { fill(255); } 
    
    text("Play the Game ", width*3/4, height*5/8);
  }
}
class TitleBannerView { 
  int cubesColors_index,  c,  u,  b, e,  s,  x;

  TitleBannerView(int cubesColors_index){
    c=0; u=1; b=2; e=3; s=2; x=0;
  }

  void draw(){
    if ((frameCount % 12) == 0) { 
      cubesColors_index++; 
      if (cubesColors_index > 4) { cubesColors_index =0;}
    }

    textAlign(CENTER);
    textFont(font, 60);

    c = cubesColors_index % 5;
    fill(g_colorPalette[c]);
    text("C", width*.5/5 , height*4/8); 

    u = (cubesColors_index+ 1) % 5;
    fill(g_colorPalette[u]);
    text("U", width*1.5/5, height*4/8); 

    b = (cubesColors_index+2) %5;
    fill(g_colorPalette[b]);
    text("B", width*2.5/5, height*4/8); 

    e = (cubesColors_index + 3) % 5;
    fill(g_colorPalette[e]);
    text("E", width*3.5/5, height*4/8); 

    s = (cubesColors_index + 4) % 5;
    fill(g_colorPalette[s]);
    text("S", width*4.5/5, height*4/8);

    textFont(font, 24);
  }
}
class SubtitleBannerView{
  
  int cubesColors_index,  c,  u,  b, e,  s,  x;
  color[] CUBEScolors = {#00A4CC, #00F224, #FFD33E, #FF5241, #A600CC, };

  SubtitleBannerView(int cubesColors_index)
  {
    c=0; u=1; b=2; e=3; s=2; x=0;
  }

  void draw(){
    textAlign(CENTER);
    fill(255);
    textFont(font, 32);
    text("CATCH THE", width/2, height*2/8);
  }
}
class SplashCubeView {

  int rotation_index;
  int i;
  SplashCubeView(int o)
  {
    rotation_index=0;
  }
  void draw() 
  {
    if ((frameCount % 12) == 0) i = (int)random(5);
    pushMatrix();
    fill(g_colorPalette[i]);
    translate(width/2, height*5/8, 0); 
    rotateY(rotation_index*.01*PI*2);
    box(20); 
    popMatrix();
    rotation_index++; 
  }
}
class CubeView {
  int cubeYposition,
      cubeXposition,
         whichColor,
 rotation_index = 0,
      rotationSpeed,
           cubeSize;

  int ypos[] = new int[]{-40, 
                   (-40)*2+5, 
                   (-40)*3+5, 
                   (-40)*4+5, 
                   (-40)*5+5, 
                   (-40)*6+5, 
                  (-40)*7+5};
  

  float cubeSpeed;

  CubeView(  int x, 
             int y, 
   int color_index, 
       float speed, 
             int c, 
             int ro)
  {
    cubeXposition = width * (x / 30);
    cubeYposition = y;
    whichColor = color_index;
    cubeSpeed = speed;
    cubeSize = c;
    rotationSpeed = ro;

  }
  
  void moveCube()
  {

    pushMatrix();
      translate(cubeXposition, cubeYposition, 0); 
      rotateY(rotation_index*.01*PI*2);
            
      // Hover Detection
      if(mouseX < cubeXposition + (cubeSize-cubeSize*.25) && 
         mouseX > cubeXposition - (cubeSize-cubeSize*.25) && 
         mouseY < cubeYposition + (cubeSize-cubeSize*.25) && 
         mouseY > cubeYposition - (cubeSize-cubeSize*.25)) {
        fill(255);

        // Click Detection
        if(mousePressed) {
          fill(g_colorPalette[whichColor]); ///box clicked animation goes here
          cubeYposition = 0;
          cubeXposition = (int)random(cubeSize,width) ;
          whichColor = (whichColor + 1) % 4;
          score.catchCount++;
          score.totalCatchCount++;
        cubeSpeed *= speedIncrement;
        event._catch = frameCount+2;
        rotationSpeed = newSpeed(rotationSpeed); 
        }
      }
      else fill(g_colorPalette[whichColor]);
      box(cubeSize);
    popMatrix();
    
    if (score.missCount<10){ 
      rotation_index+= rotationSpeed;; 
      cubeYposition+=cubeSpeed;
    }   
    
    if(score.missCount == 10){ 
      currentScreen = GAME_OVER;
      event.game_over = frameCount+2;
      score.catchCount = 0;
    }

    if(cubeYposition > height + 40){
      cubeYposition = ypos[(int)random(ypos.length)];
      cubeXposition = (int) width * ((int) random(0,30) / 30);
      whichColor = (whichColor + 1) % 4;
      score.missCount++;
      event.miss = frameCount+2;
      rotationSpeed = newSpeed(rotationSpeed); 
    }

    if(rotation_index > 99) rotation_index = 0;
  }
  
  void startCube()
  {
    pushMatrix();
    translate(cubeXposition, cubeYposition, 0); 
    rotateY(rotation_index*.01*PI*2);
    int j, i;
  
    if(mouseX < cubeXposition + cubeSize && 
       mouseX > cubeXposition - cubeSize && 
       mouseY < cubeYposition + cubeSize && 
       mouseY > cubeYposition - cubeSize) 
    {
      fill(255);
      cursor(HAND);                
      if(mousePressed)
      {
        cubeYposition = 0;
        cubeXposition = (int)random(300) + 100;
        whichColor = (whichColor + 1) % 4;
        cubeSpeed *= speedIncrement;
        event._catch = frameCount+2;
        rotationSpeed = newSpeed(rotationSpeed); 
      }
    }
    else fill(g_colorPalette[whichColor]);
    box(cubeSize);
    popMatrix();
    rotation_index+= rotationSpeed; 
    cubeYposition+=cubeSpeed;   
    
    if(cubeYposition > height + 40)
    {
      
      cubeYposition = -((int) random(300) + 100);
      cubeXposition = (int) random(width);
      rotationSpeed = newSpeed(rotationSpeed); 
      
      
      
      whichColor = (int)random(4);
      cubeSize = (int)(random(20)+20);
    }

    if(rotation_index > 99) rotation_index = 0;
  }
}
class ClickToPlayButtonView {

  ClickToPlayButtonView(){};

  void draw() {
    if( mouseX < width/2  + 100 &&
        mouseX > width/2  - 100 &&
        mouseY < height/2 + 20  &&
        mouseY > height/2 ){ 
    fill(255);
     if(mousePressed)
     {
       event._catch = frameCount;  
       score.reset();
       currentScreen = PLAY_GAME;
     }
   }
   else  fill(120,120,120,120); 
   text("Click to Play", width/2, height/2);
  }
}
class Score {

  int    missCount,
        catchCount,
   totalCatchCount,
        totalScore; // Because score is totalCatchCount * level #

  Score() { 
    this.reset();
  }

  void reset(){
         missCount = 0;
        catchCount = 0;
   totalCatchCount = 0;
        totalScore = 0; 
  }
}
class ScoreViewController {

  ScoreViewController(){};

  void draw(Score score){
    strokeWeight(1);    
    if(score.missCount <= score.catchCount)
    {
      fill(255);
      arc(width*4/8, 75, 60, 60, (PI*3/2),PI*3/2 + TWO_PI*((score.catchCount)*.1));
      fill(g_colorPalette[3]);
      arc(width*4/8, 75, 60, 60, (PI*3/2),PI*3/2 + TWO_PI*(score.missCount*.1));
    }
    if(score.catchCount < score.missCount)
    {
      fill(g_colorPalette[3]);
      arc(width*4/8, 75, 60, 60, (PI*3/2),PI*3/2 + TWO_PI*(score.missCount*.1));    
      fill(255);
      arc(width*4/8, 75, 60, 60, (PI*3/2),PI*3/2 + TWO_PI*((score.catchCount)*.1)); 
    }

    fill(255);
    text("Score:", width/2, height*19/20);
    textAlign(LEFT);
    score.totalScore = int(score.totalCatchCount*(levelNumber-1));
    text(score.totalScore, (width/2) + 67, height*19/20);

    fill(255);
    textAlign(CENTER);
    text("Level", width*1/2, 50);
    text(levelNumber-1, width*1/2, 25);
  }
}
class Events {
  
  int   _catch, 
          miss, 
     game_over,
       how_to,
       welcome,
       how_to_unlock;

  Events(int c)
  {
   _catch = c;
   miss   = c;
   game_over = c;
   welcome = c;
   how_to =c;
   how_to_unlock =c;
  }
}
class GameOverView {
  GameOverView(){};
    void draw() {
      fill(255);
      textAlign(CENTER);
      text("GAME OVER", width/2, height/2);
    }
}
class YourScoreView {

  YourScoreView(){};

  void draw(Score score) {
      textAlign(LEFT);
      text("Your Score:", width*1/3, height*3/4);
      text(score.totalScore, width*2/3, height*3/4);
  }
}
class BackToMainMenuButton {

  BackToMainMenuButton(){};

  void draw() {
  
    if( mouseX < width*1/20 + 10   &&
        mouseX > width*1/20 - 10   &&
        mouseY < height*19/20 + 10 &&
        mouseY > height*19/20 - 10)
      { 
        fill(255);
         if(mousePressed)
         {
           currentScreen = MAIN_MENU;
           event._catch = frameCount;    
         }
       }
      else  fill(255,255,255,128); 
      ellipse( width*1/20, height*19/20, 20, 20);  
  }
}  
class LightingContext {

  LightingContext(){};

  void render() {
  
    pointLight(150, 100, 0,   // Color
               200, -150, 0); // Position

    // Blue directional light from the left
    directionalLight(0, 102, 255, // Color
                     1, 0, 0);    // The x-, y-, z-axis direction

    // Yellow spotlight from the front
    spotLight(255, 255, 109, // Color
              0, 40, 200,    // Position
              0, -0.5, -0.5, // Direction
              PI / 2, 2);    // Angle, concentration
              
    ambientLight(150, 150, 150);
  }
}
