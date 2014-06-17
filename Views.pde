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
         soundEvent.how_to = frameCount;
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
          soundEvent.catchEvent = frameCount;
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
        soundEvent.catchEvent = frameCount+2;
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
      soundEvent.game_over = frameCount+2;
      score.catchCount = 0;
    }

    if(cubeYposition > height + 40){
      cubeYposition = ypos[(int)random(ypos.length)];
      cubeXposition = (int) width * ((int) random(0,30) / 30);
      whichColor = (whichColor + 1) % 4;
      score.missCount++;
      soundEvent.miss = frameCount+2;
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
        soundEvent.catchEvent = frameCount+2;
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
       soundEvent.catchEvent = frameCount;
       score.reset();
       currentScreen = PLAY_GAME;
     }
   }
   else  fill(120,120,120,120);
   text("Click to Play", width/2, height/2);
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
        mouseY > height*19/20 - 10){
        
        fill(255);
         if(mousePressed){
           currentScreen = MAIN_MENU;
           soundEvent.catchEvent = frameCount;
         }
       }
      else  fill(255,255,255,128);
      ellipse( width*1/20, height*19/20, 20, 20);
  }
}
