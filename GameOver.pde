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
    if ((soundEvent.game_over) == frameCount) { game_overSample.trigger(); }      
    yourScoreView.draw(score);
    gameOverView.draw();
    tSDotcomButtonView.draw();
    if((soundEvent.game_over+frameRate*2.5)  < frameCount && mousePressed) { currentScreen = MAIN_MENU;}
  }
}

