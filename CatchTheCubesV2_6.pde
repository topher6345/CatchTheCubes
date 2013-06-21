//Catch the Cubes
// A game by Christopher Saunders
// topher@tophersaunders.com

//Catch the Cubes is a  simple game where
//Cubes fall from the top of the screen,
//the player must click the falling cube before
//it reaches the bottom. 

//If the player catchCount the cube, then the "catchCount" 
//count is incremented. And the cubes speed up!
//If the cube reaches the bottom before it is "caught"
//then the misses count is incremented
//When the misses count is 10, the game ends.
//

import processing.opengl.*;
import ddf.minim.*;

//Audio Stuff
Minim minim = new Minim(this);
AudioPlayer player;

AudioSample catchSample;
AudioSample missSample;
AudioSample game_overSample;
AudioSample welcomeSample;
final int BUFFERSIZE = 512;
final int NUMLEVELS = 128;

//These variables are timestamps to trigger single frame actions.

//Custom Classes
CATCHTHE_banner subtitleBanner = new CATCHTHE_banner(0);
   CUBES_banner titleBanner    = new CUBES_banner(0);
      howToPlay tutorial       = new howToPlay(0); 
      gameStats stats          = new gameStats(0);
      events    event          = new events(-1);

     cubeObject[] cube         = new cubeObject[NUMLEVELS];
   openSplashBox mainMenuBox   = new openSplashBox(0);
//This needs to be objectified (0, -100, 1, 2);

int cubesColors_index, cubeColor_index;

float cubeSpeed;

final float initCubeSpeed = 2;
final float speedIncrement = 1.02;


final int GameOverScreen  =-1;
final int MainMenuScreen  = 0;
final int HowToPlayScreen = 1;
final int PlayScreen    = 2;


int levelNumber = 2; 

int currentScreen = MainMenuScreen;


PFont font_h2, fontTitle, font_link, fontBig;

void setup()
{
  size (600, 400, OPENGL);
  frameRate(60);
  background(0);
  smooth();
  fontTitle = loadFont("Helvetica-Bold-45.vlw");
  fontBig   = loadFont("Helvetica-Bold-90.vlw");
  font_h2   = loadFont("Courier-Oblique-28.vlw"); 
  font_link = loadFont("Koshgarian-Bold-20.vlw");
  catchSample     = minim.loadSample("catch.aif"    ,BUFFERSIZE);
  missSample      = minim.loadSample("miss.aif"     ,BUFFERSIZE);
  game_overSample = minim.loadSample("game_over.aif",BUFFERSIZE);
  welcomeSample   = minim.loadSample("welcome.aif"  ,BUFFERSIZE);
  
  player          = minim.loadFile("01PWSteal.Ldpinch.D.mp3", 2024);
  player.loop();
  int rotation =1;    
  
  for (int i = 1; i < 128 ; i++)
  {//int x, int y, int color_index, float speed, int c, int ro)
    cube[i] = new cubeObject( (int)random(width),//X initial Position
                    (int)(-(random(height))),//Y initial Position
                                  (int)random(4),// Color Index
                                   initCubeSpeed, 
                           ((int)(random(20)+20)),// 
                              newSpeed(rotation));//Rotation Speed/Direction
  }
}


void draw()//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////DRAW//START
{
  
   
  //if (frameCount == 5) player.play();
  //if (frameCount == 5) welcomeSample.trigger();
      //fill(0, 0, 0, 255);
      //rect(0,0, width, height);
  background(0);
  if(currentScreen == MainMenuScreen)//////////////////////////////////////////
  {

    lighting();
    for  (int l = 1 ; l < 4; l++) cube[l].startCube();
    mainMenuBox.spin();    
    hint(DISABLE_DEPTH_TEST);

    subtitleBanner.incrementColors();
    titleBanner.incrementColors();
    PlayTheGameButton();
    HowToPlayButton();
    LinkTSButton();
    hint(ENABLE_DEPTH_TEST);


    
  }
     
  if(currentScreen == HowToPlayScreen)/////////////////////////////////////////////
  {  
        lighting();

    for  (int l = 1 ; l < 2; l++) cube[l].moveCube(); 
    hint(DISABLE_DEPTH_TEST);
    stats.displayStats(); 
    tutorial.inText(event.how_to);  
    
    if (stats.catchCount > 9) stats.catchCount = 10;
    hint(ENABLE_DEPTH_TEST);

  }
  
  if(currentScreen == PlayScreen)
  {
    
    int l=1;
    lighting();
            
    for  (l = 1 ; l < (levelNumber); l++) cube[l].moveCube(); 
    hint(DISABLE_DEPTH_TEST);
    if ((event._catch) == frameCount) catchSample.trigger();
    if ((  event.miss) == frameCount)  missSample.trigger();
    stats.displayStats();   
    if (stats.catchCount  > 9 && frameCount > event.how_to + frameRate * 5 ) {levelNumber++; stats.missCount =0;stats.catchCount=0;}
    hint(ENABLE_DEPTH_TEST);
    backMainMenu();
  }  
 
  if(currentScreen == GameOverScreen)////////////////////////////////////////////////////////
    {
      if ((event.game_over) == frameCount) { player.pause(); game_overSample.trigger(); }      
      for (int i=1; i < NUMLEVELS; i++) cube[i].cubeYposition = 0;      
      gameOver();
      yourScore();     
      LinkTSButton();
      if((event.game_over+frameRate*2.5)  < frameCount && mousePressed) currentScreen = MainMenuScreen;     
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////END DRAW////////////////////////////////////////////////////////////////////////////////////


void stop(){
           catchSample.close();
            missSample.close();
       game_overSample.close();
         welcomeSample.close();  
       
       minim.stop();
       super.stop();    
}


void PlayTheGameButton() {
  if(mouseX < ((width*3/4) + 110)   &&
       mouseX > ((width*3/4) - 110) &&
       mouseY < ((height*5/8))      &&
       mouseY > ((height*5/8) - 20))
       {
        fill(#E7003E);
        if(mousePressed) 
        {
          currentScreen = PlayScreen;
          event._catch = frameCount;    
          for (int i=1; i < NUMLEVELS; i++) cube[i].cubeYposition = 0;
        }
       }
    else {
    fill(255);
    } 
    textFont(font_h2); 
    text("Play the Game ", width*3/4, height*5/8);
    stats.resetStats();
}
  
void HowToPlayButton() {
  if(  mouseX < ((width/4)   + 100) &&
       mouseX > ((width/4) - 100)   &&
       mouseY < ((height*5/8))      &&
       mouseY > ((height*5/8) - 20))
       {
         fill(#5De100);
         if(mousePressed) {
           for (int i=1; i < NUMLEVELS; i++) cube[i].cubeYposition = 0;
           currentScreen = HowToPlayScreen; 
           event.how_to = frameCount; 
           tutorial.inTextChapter =1;
         }
       }
    else{
    fill(255);  
    }
    textFont(font_h2); 
    text("How to Play", width/4, height*5/8);
    stats.resetStats();

}


void LinkTSButton() {
  if(mouseY > 338 && 
     mouseY < 360 && 
     mouseX > 212 && 
     mouseX < 400)
    { 
      fill(#FFCA00);
      if(mousePressed) 
      {
        link("http://www.tophersaunders.com"); 
        stop();
        exit();
        return;

      }  
    }
  else{
  fill(255); 
  }
  textFont(font_link);
  text("tophersaunders.com", width/2, height*7/8);
}


class CUBES_banner
{ 
  int cubesColors_index,  c,  u,  b, e,  s,  x;
  color[] CUBEScolors = {#FFFFFF, #FFCA00, #5De100, #E7003E, #2c17B1, };

  CUBES_banner(int cubesColors_index)
  {
    c=0; u=1; b=2; e=3; s=2; x=0;
  }

  void incrementColors(){
    if ((frameCount % 12) == 0) cubesColors_index++; if (cubesColors_index > 4) cubesColors_index =0;
    textAlign(CENTER);
    textFont(fontBig);
    //text("CUBES", width/2, height*4/8);
 
    c = cubesColors_index % 5;
    fill(CUBEScolors[c]);
    text("C", width*.5/5 , height*4/8); 

    u = (cubesColors_index+ 1) % 5;
    fill(CUBEScolors[u]);
    text("U", width*1.5/5, height*4/8); 

    b = (cubesColors_index+2) %5;
    fill(CUBEScolors[b]);
    text("B", width*2.5/5, height*4/8); 

    e = (cubesColors_index + 3) % 5;
    fill(CUBEScolors[e]);
    text("E", width*3.5/5, height*4/8); 

    s = (cubesColors_index + 4) % 5;
    fill(CUBEScolors[s]);
    text("S", width*4.5/5, height*4/8); 
  }
}

class CATCHTHE_banner
{
  
  int cubesColors_index,  c,  u,  b, e,  s,  x;
  color[] CUBEScolors = {#FFFFFF, #FFCA00, #5De100, #E7003E, #2c17B1 };

  CATCHTHE_banner(int cubesColors_index)
  {
    c=0; u=1; b=2; e=3; s=2; x=0;
  }

  void incrementColors(){
    textAlign(CENTER);
    fill(255);
    textFont(fontTitle); 
    text("CATCH THE", width/2, height*2/8);
  }
}



class openSplashBox 
{
  int rotation_index;
  openSplashBox(int o)
  {
    rotation_index=0;
  }
  void spin() 
  {
    if ((frameCount % 12) == 0) cubeColor_index = (int)random(5);
    color[] CUBEcolors = {#FFFFFF, #FFCA00, #5De100, #E7003E, #2c17B1, };
    pushMatrix();
    fill(CUBEcolors[cubeColor_index]);
    translate(width/2, height*5/8, 0); 
    rotateY(rotation_index*.01*PI*2);
    box(20); 
    popMatrix();
    rotation_index++; 
  }
}

class cubeObject///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
{
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
  
  color[] colors = {#FFCA00, 
                    #5De100, 
                    #E7003E, 
                    #2c17B1};
  float cubeSpeed;

  cubeObject(int x, 
             int y, 
   int color_index, 
       float speed, 
             int c, 
             int ro)
  {
    cubeXposition = x;
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
            
      if(mouseX < cubeXposition + (cubeSize-cubeSize*.25) && 
         mouseX > cubeXposition - (cubeSize-cubeSize*.25) && 
         mouseY < cubeYposition + (cubeSize-cubeSize*.25) && 
         mouseY > cubeYposition - (cubeSize-cubeSize*.25)) 
      {
        fill(255);
        if(mousePressed)
        {
          fill(colors[whichColor]); ///box clicked animation goes here
          cubeYposition = 0;
          cubeXposition = (int)random(300) + 100;
          whichColor = (whichColor + 1) % 4;
          stats.catchCount++;
          stats.totalCatchCount++;
        cubeSpeed *= speedIncrement;
        event._catch = frameCount+2;
        rotationSpeed = newSpeed(rotationSpeed); 
      }
    }
    else fill(colors[whichColor]);

    box(cubeSize);
    popMatrix();
    
    if (stats.missCount<10)
    { 
      
      rotation_index+= rotationSpeed;; 
      cubeYposition+=cubeSpeed;
    }   
    
    if(stats.missCount == 10)
    { 
      currentScreen = GameOverScreen;
      event.game_over = frameCount+2;
      stats.catchCount = 0;
    }

    if(cubeYposition > height + 40)
    {
      cubeYposition = ypos[(int)random(ypos.length)];
      cubeXposition = (int) random(300) + 100;
      whichColor = (whichColor + 1) % 4;
      stats.missCount++;
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
    else fill(colors[whichColor]);
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


class howToPlay
{
  int startPos;
  int inTextChapter = 1;
  float tutorialSplashOpacity = 255;
  boolean tutorialCatchFlag = false;

  howToPlay(int startPos){
  tutorialSplashOpacity = 255;
  }
  
  void inText(int startPos)
  {   
    
    if (inTextChapter == 1) 
    {
      textAlign(CENTER);
      textFont(fontTitle);
      tutorialSplashOpacity-=2; if (tutorialSplashOpacity < 1){ inTextChapter = 2; tutorialSplashOpacity = 255; }
      fill(255,255,255, tutorialSplashOpacity);
      text("How to Play", width/2, height/2);
    }
    if (inTextChapter == 2) 
    {
      textAlign(CENTER);
      textFont(fontTitle);
      tutorialSplashOpacity--; if (tutorialSplashOpacity < 1) { inTextChapter = 3; tutorialSplashOpacity = 255;}
      fill(255,255,255, (tutorialSplashOpacity*.5)+127 );
      text("Cubes are falling!", width/2, height/2);
    }
    if (inTextChapter == 3) 
    {
      textAlign(CENTER);
      textFont(fontTitle);
      tutorialSplashOpacity--; if (tutorialSplashOpacity < 1) { inTextChapter = 4; tutorialSplashOpacity = 255;}
      fill(255,255,255, (tutorialSplashOpacity*.5) + 127 );
      text("Catch them with the mouse.", width/2, height/2);
    }
    if(inTextChapter == 4 && event.how_to_unlock < frameRate * 5 + frameCount) 
    {
      textAlign(CENTER);
      textFont(fontTitle);
      tutorialSplashOpacity--; if (tutorialSplashOpacity < 1) { inTextChapter = 5; tutorialSplashOpacity = 255; stats.missCount = 9;      
}
      fill(255,255,255, (tutorialSplashOpacity*.5) + 127 );
      text("Catch 10 and you advance", width/2, height*1/3);
      text("to the next level", width/2, height*2/3);          
    }   
    if(inTextChapter == 5 )
    {
      textAlign(CENTER);
      textFont(fontTitle);
      tutorialCatchFlag = false;
      fill(255,255,255, (tutorialSplashOpacity*.5)+127 );
      text("Miss 10 and it's", width/2, height*1/3);
      text("Game Over", width/2, height*2/3);
      ClickToPlay();
      }
    } 
    void ClickToPlay() 
    {
      if( mouseX < width/2 + 100   &&
        mouseX > width/2 - 100   &&
        mouseY < height/2 + 20 &&
        mouseY > height/2 )
     { fill(255);
       if(mousePressed)
       {
         event._catch = frameCount;    
         for (int i=1; i < NUMLEVELS; i++) cube[i].cubeYposition = 0;
         currentScreen = PlayScreen;
         stats.resetStats();
       }
     }
     else  fill(120,120,120,120); 
     text("Click to Play", width/2, height/2);
    }   
  }
  
  
  int newSpeed(int rotation) {
      rotation = (int)(random(6)-3);
      while(rotation == 0 ) rotation = (int)(random(6)-3);
      return rotation;
  }
  
  
  class gameStats
{
int      missCount,
        catchCount,
   totalCatchCount,
        totalScore; //Because score is totalCatchCount * level #

  gameStats(int i)
  {
         missCount = i;
        catchCount = i;
   totalCatchCount = i;
        totalScore = i; //Because score is totalCatchCount * level #
  }

  void resetStats(){
         missCount = 0;
        catchCount = 0;
   totalCatchCount = 0;
        totalScore = 0; //Because score is totalCatchCount * level #  
  }
  
  void displayStats(){
    strokeWeight(1);
//spotLight(255, 255, 255, width/2, height/2, 400, 0, 0, -1, PI/4, 2);

   
    
    if(missCount <= catchCount)
    {
      fill(255);
      arc(width*4/8, 75, 60, 60, (PI*3/2),PI*3/2 + TWO_PI*((catchCount)*.1));
      fill(255,0,0);
      arc(width*4/8, 75, 60, 60, (PI*3/2),PI*3/2 + TWO_PI*(missCount*.1));
    }
    if(stats.catchCount < stats.missCount)
    {
      fill(255,0,0);
      arc(width*4/8, 75, 60, 60, (PI*3/2),PI*3/2 + TWO_PI*(missCount*.1));    
      fill(255);
      arc(width*4/8, 75, 60, 60, (PI*3/2),PI*3/2 + TWO_PI*((catchCount)*.1)); 
    }

    fill(255);
    textFont(font_h2);
    text("Score:", width/2, height*19/20);
    textAlign(LEFT);
    totalScore = int(totalCatchCount*(levelNumber-1));
    text(totalScore, (width/2) + 67, height*19/20);

    fill(255);
    textAlign(CENTER);
    textFont(font_h2);
    text("Level", width*1/2, 50);
    text(levelNumber-1, width*1/2, 25);
  }
}


class events
{
  
  int   _catch, 
          miss, 
     game_over,
       how_to,
       welcome,
       how_to_unlock;
  
  
  events(int c)
  {
   _catch = c;
   miss   = c;
   game_over = c;
   welcome = c;
   how_to =c;
   how_to_unlock =c;
  }
 
  
}


void gameOver() {
  
      fill(255);
      textAlign(CENTER);
      textFont(fontTitle);
      text("GAME OVER", width/2, height/2);
      
}

void yourScore() {
      textAlign(LEFT);
      textFont(font_h2);
      text("Your Score:", width*1/3, height*3/4);
      text(stats.totalScore, width*2/3, height*3/4);
}
  
  
void backMainMenu() {
  
  if( mouseX < width*1/20 + 10   &&
      mouseX > width*1/20 - 10   &&
      mouseY < height*19/20 + 10 &&
      mouseY > height*19/20 - 10)
     { fill(255);
       if(mousePressed)
       {
         currentScreen = MainMenuScreen;
         event._catch = frameCount;    
         for (int i=1; i < NUMLEVELS; i++) cube[i].cubeYposition = 0;
       }
     }
     else  fill(120,120,120,120); 
     ellipse( width*1/20, height*19/20, 20, 20);  
}

void lighting() {
  
  pointLight(150, 100, 0, // Color
             200, -150, 0); // Position

  // Blue directional light from the left
  directionalLight(0, 102, 255, // Color
                   1, 0, 0); // The x-, y-, z-axis direction

  // Yellow spotlight from the front
  spotLight(255, 255, 109, // Color
            0, 40, 200, // Position
            0, -0.5, -0.5, // Direction
            PI / 2, 2); // Angle, concentration
            
    ambientLight(150, 150, 150);
    
}


