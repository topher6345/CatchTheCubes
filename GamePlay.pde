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
    if (score.catchCount  > 9 && frameCount > soundEvent.how_to + frameRate * 5 ) {levelNumber++; score.missCount =0;score.catchCount=0;}
    hint(ENABLE_DEPTH_TEST);
    backToMainMenuButton.draw();
    if ((soundEvent.catchEvent) == frameCount) catchSample.trigger();
    if ((  soundEvent.miss) == frameCount)  missSample.trigger();

  }
}
