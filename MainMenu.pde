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
    if ((soundEvent.catchEvent) == frameCount) catchSample.trigger();

    hint(ENABLE_DEPTH_TEST);
  }
}
