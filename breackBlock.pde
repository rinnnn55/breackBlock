Ball ball;
Bar bar;
BreakableBlock breBlo;
UnbreakableBlock unBreBlo;

color bgCol = color(255);
color unBBCol = color(255, 0, 0);
color bbCol = color(128);
color barCol = color(33,44,66);
color ballCol = color(23,156,66);


int BALL_SIZE = 20;
int BLOCK_SIZE_W, BLOCK_SIZE_H;
int BLOCK_COUNT_ROW = 4;
int BLOCK_COUNT_COL = 10;
int BLOCK_INTERVAL = 10;

Block[][] blockList = new Block[BLOCK_COUNT_COL][BLOCK_COUNT_ROW];

void setup() {
  size(500, 500);

  BLOCK_SIZE_H = height / 20;
  BLOCK_SIZE_W = width / 12;
  int xx = (width - (BLOCK_COUNT_COL * BLOCK_SIZE_W)) / 2;



  for (int i = 0; i < BLOCK_COUNT_COL; i++) {
    for (int j = 0; j < BLOCK_COUNT_ROW; j++) {
      int randomNum = int(random(7));
      if(randomNum == 4){
        blockList[i][j] = new UnbreakableBlock(xx + (BLOCK_SIZE_W) * (i), BLOCK_SIZE_H * (j + 1));
      }else{
        blockList[i][j] = new BreakableBlock(xx + (BLOCK_SIZE_W) * (i), BLOCK_SIZE_H * (j + 1));
      }
    }
  }

  ball = new Ball();
  bar = new Bar();
}

void draw() {
  background(bgCol);
  bar.display();
  bar.isBallHit();


  ball.gameLoop();

  for (int i = 0; i < BLOCK_COUNT_COL; i++) {
    for (int j = 0; j < BLOCK_COUNT_ROW; j++) {
      blockList[i][j].display();
      blockList[i][j].isHit();
    }
  }
}





abstract class Shape {
  int x, y, size;

  color col;


  abstract void display();
  abstract void move();


  void gameLoop() {
    display();
    move();
  }
}

class Ball extends Shape {
  int xStep, yStep;
  int lastX, lastY;
  Ball() {
    xStep = 3;
    yStep = 2;
    x = width /2;
    y = height - 40;
    size = 20;
    col = ballCol;
  }

  void display() {
    fill(col);
    ellipse(x, y, size, size);
  }

  void move() {
    lastX = x;
    lastY = y;

    x += xStep;
    y += yStep;

    if (x - size / 2 < 0 || x + size / 2 > width) xStep *= -1;
    if (y - size / 2 < 0 || y + size / 2 > height) yStep *= -1;
  }
}

class Bar extends Shape {
  int sizeW, sizeH;
  Bar() {
    sizeW = 80;
    sizeH = 30;
    y = height - 50;
    col = barCol;
    
  }


  void display() {
    x = mouseX;
    rect(x, y, sizeW, sizeH);
  }

  void move() {
  }

  void isBallHit() {
    if (ball.x-ball.size/2 > x && ball.x+ball.size/2 < x+sizeW) {

      if (ball.y > ball.lastY && ball.y > y) {
        ball.yStep = -abs(ball.yStep);
      }
    }
  }
}


abstract class Block {
  int x, y;
  color col;
  boolean isAlive, isBreak;


  Block(int _x, int _y) {
    x = _x;
    y = _y;
    isAlive = true;
  }


  void display() {
    if (isAlive) {
      fill(col);
      rect(x, y, BLOCK_SIZE_W, BLOCK_SIZE_H);
    }
  }

  abstract void isHit();
}

class BreakableBlock extends Block {

  BreakableBlock(int x, int y) {
    super(x, y);
    isBreak = true;
    col = bbCol;
  }

  void isHit() { 
    if (CheckCollition(ball.x, ball.y, x, y) && isAlive) {
      isAlive = false;

      if (x < ball.lastX && x + BLOCK_SIZE_W > ball.lastX){
        ball.yStep *= -1;
      }else if (y < ball.lastY && y + BLOCK_SIZE_H > ball.lastY){
         ball.xStep *= -1;
      }else {
        ball.xStep *= -1;
      }

      println(2);
    }
  }
}

class UnbreakableBlock extends Block {
  UnbreakableBlock(int x, int y) {
    super(x, y);
    isBreak = false;
    col = unBBCol;
  }



  


  void isHit() {
    if (CheckCollition(ball.x, ball.y, x, y) && isAlive) {

      if (x < ball.lastX && x + BLOCK_SIZE_W > ball.lastX){
        ball.yStep *= -1;
      }else if (y < ball.lastY && y + BLOCK_SIZE_H > ball.lastY){
         ball.xStep *= -1;
      }else {
        ball.xStep *= -1;
      }
    }
  }
}

boolean CheckCollition(int x, int y, int blockX, int blockY) {
  boolean isWithinX = (x + BALL_SIZE / 2 > blockX) && (x - BALL_SIZE / 2 < blockX + BLOCK_SIZE_W);
  boolean isWithinY = (y + BALL_SIZE / 2 > blockY) && (y - BALL_SIZE / 2  < blockY + BLOCK_SIZE_H);

  if (isWithinX && isWithinY) return true;
  return false;
}
