/*
  The game is called "BLOBCHASER". In the game, a target (blob) will appear at a random location on the canvas. If the player clicks within a certain radius around the target, the target changes color, 
  indicating a hit. Each hit is worth 1 point.
  Semantic versioning style: MAJOR.MINOR.PATCH
  200626: 0.1.0 - First version of BLOBCHASER.
  For upcoming versions (in no particular order):
  - A welcome screen.
  - An option to customize difficulty by letting the player choose frame rate, & target size.
  - Improved visuals (alignment, text, color).
  - Sounds?
  - A pause option.
 */
 
 
// Variables & constants.
int targetSize = 150, // Sets size of target.
    score = 0, // The number of times the player whacks the mole. Score starts at 0.
    textSize = 32; // Size of the score display text.
float targetX, targetY, // Location of target.
      targetLeftEdgeX, targetRightEdgeX, targetUpperEdgeY, targetLowerEdgeY, // The location of the target's edges.
      playTime = 30, // The length of 1 game. Could be changed later, or could be made to give the player the choice of playing time.
      time = playTime, // The time remaining. Initial value is equal to the length of 1 game.
      frameRate = 3, // Frame rate. Initial value is 3. Later versions could change value to make game harder/easier. This variable is also needed to count down the time.
      timeRounded = playTime; // A variable used to display the time onto the screen. Initial value is equal to length of 1 game.                                                                                                           

// Functions

/* 
  The function welcomeScreen() displays a welcome screen that prompts the player to press any key to begin the game.
 */
void welcomeScreen()
{
}

/*
  drawTarget() draws the target, then resets it every frame.
 */
void drawTarget()
{
  fill(255,0,0); // Makes the target red.
  stroke(1); // Makes the target have an outline.
  targetX = random(targetSize/2,width-targetSize/2); // Sets a random location of the target for each frame.
  targetY = random(height/8+textSize/2+targetSize/2,height-targetSize/2); // The "targetSize/2" paramater and the "-targetSize/2" parts ensures that the circle will appear entirely within the canvas.
                                                                          // height/8 is the y-coordinate of where the score will be displayed. Setting height/8+textSize/2+targetSize/2 as the lower 
                                                                          // value in this random() call will ensure the target does not obstruct the score.
  ellipse(targetX,targetY,targetSize,targetSize); // Draws a circular target.
  targetLeftEdgeX = targetX - targetSize/2; // Sets values for the location of the target's edges.
  targetRightEdgeX = targetX + targetSize/2; 
  targetUpperEdgeY = targetY - targetSize/2; 
  targetLowerEdgeY = targetY + targetSize/2;
}
 
/*
  mousePressed() changes the color of the target that's been hit, and adds 1 point to the score.
 */
void mousePressed()
{
  if (time >= 1/frameRate && (targetLeftEdgeX <= mouseX) && (mouseX <= targetRightEdgeX) && (targetUpperEdgeY <= mouseY) && (mouseY <= targetLowerEdgeY)) // If when the player presses the mouse, 
                                                                                                                                                           // there's still time on the clock and 
                                                                                                                                                           // the cursor is in the target:
  {
    ++score; // Adds 1 point to the score.
    fill(0,255,0); // Change the color of the target to green.
    ellipse(targetX,targetY,targetSize,targetSize); // Redraw the target at the same location, just with a different color.
  } // if (time >= 1/frameRate && targetHit)
} // mousePressed()

/*
  Displays the score.
 */
void scoreDisplay()
{
  textSize(textSize); // Sets text size.
  fill(0); // Makes text black.
  textAlign(CENTER);
  text("SCORE: " + score, width/10*3, height/8); // Displays the score.
}

/* 
  Countdown logic.
 */
void timeCountdown()
{
  time -= 1/frameRate; // Time changes with every frame.
  timeRounded = round(time);  // Since the "time" variable will have a non-zero decimal part during the game due to the frame rate change, another variable, timeDisplay, which only displays 
                                 // the whole-number part of time, would make the time more accurately expressed because then, the time decreases by 1 with every passing second.
} // void timeCountdown()

/*
  Display the time.
 */
void timeDisplay()
{
  textSize(textSize); // Sets text size.
  fill(0); // Makes text black.
  textAlign(CENTER);
  text("TIME: " + int(timeRounded), width/10*7, height/8); // Displays the time.
}

/* 
  Freeze the target in its most recent position at the end of the game.
 */
void targetEndGame()
{
  fill(255,0,0); // Make the target red.
  stroke(1); // Makes the target have an outline.
  ellipse(targetX,targetY,targetSize,targetSize); // Draws a circular target.
}

/* 
  Announces the end of the game, prompts player to press any key to restart.
 */
void endGameScreen()
{
  // Once time is up:
  if (time < 1/frameRate)
  {
    // Draw a transparent dark grey rectangle on top of the existing game to use as background for end-game text.
    fill(50,50,50,128); // Use a darker shade of grey than the current game background, but still transparent to see the background.
    rect(0,0,width,height); // Draws a rectangle that overlaps the entire game.
    // Displays a text announcing the end of the game, recapping the score.
    textSize(textSize);
    fill(0);
    noStroke();
    textAlign(CENTER);
    text("TIME'S UP!", width/2, height/10*4);
    text("YOUR FINAL SCORE: " + score, width/2, height/10*5);
    // Prompts the player to press any key to restart the game.
    textSize(textSize/5*4); // Make text size smaller so the longer sentence fits inside the canvas better.
    text("PRESS ANY KEY TO PLAY AGAIN", width/2, height/10*6);
  } // if (time < 1/frameRate)
}

/* 
  The reset() function will reset the values of variables to its starting state so that a new game can be started.
*/
void reset()
{
  time = playTime; // Resets the time.
  score = 0; // Resets the score.
} // reset()

/* 
  When any key is pressed, if the time is up, the frame count will be reset to -1. When the frame count increments to frame 0, it re-runs setup without you trying to call it directly.
 */
void keyPressed()
{
  if (time < 1/frameRate)
  {
    reset();
  }
}

void setup()
{
  size(500,500); // Sets canvas size to 500x500 pixels.
  frameRate(frameRate); // Sets frame rate.
  reset();
} // setup()

void draw()
{
  background(200); // Resets background after every frame.
  scoreDisplay();
  timeDisplay();
  if (time >= 1/frameRate)
  {
      drawTarget(); 
      timeCountdown();
  } // if (time >= 1/frameRate)
  targetEndGame();
  endGameScreen();
} // draw()
