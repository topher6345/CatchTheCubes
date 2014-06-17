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
    if ((soundEvent.catchEvent) == frameCount) catchSample.trigger();
    if ((  soundEvent.miss) == frameCount)  missSample.trigger();

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
    if(inTextChapter == 4 && soundEvent.how_to_unlock < frameRate * 5 + frameCount) {
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
