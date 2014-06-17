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
