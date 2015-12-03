PImage bg1, bg2, enemy, fighter, hp, treasure, start1, start2, end1, end2;
int bg, enX, enY, hps, trX, trY, ftX, ftY,  timer, timerExplode;
int speed, shootingSpeed, enemySpeed, enemyStart;
int shX, shY;
boolean straightMode=true, tiltMode=false, squareMode=false;
boolean upPressed=false, downPressed=false, leftPressed=false, rightPressed=false; 
boolean EnemyFighterHit, FighterTreasureHit, EnemyBulletHit;
final int START=0, PLAYING=1, END=2;
int gameState, currentFrame;
boolean[]showing = new boolean[8];
PImage[]flames = new PImage[5];
PImage[]shoot = new PImage[5];
boolean[]explode = new boolean[8];
boolean[]shooting = new boolean[5];
int bullet[][] = new int[5][2];
int enemyXY[][] = new int[8][2];
int c=0, n=0;
int score=0;
PFont f;

boolean isHit(int aX, int aY, int aW, int aH, int bX,int bY, int bW, int bH)
{
  if(aY+aH>=bY && bY>=aY-bH){
  if(aX-bW<=bX && bX<=aX+aW){
      return true;}
    else{return false;}
  }
    else{return false;}
  }

void setup () {
  size(640, 480) ;
  start1=loadImage("img/start1.png");
  start2=loadImage("img/start2.png");
  bg1=loadImage("img/bg1.png");
  bg2=loadImage("img/bg2.png");
  hp=loadImage("img/hp.png");
  enemy=loadImage("img/enemy.png");
  fighter=loadImage("img/fighter.png");
  treasure=loadImage("img/treasure.png");
  end1=loadImage("img/end1.png");
  end2=loadImage("img/end2.png");
  f=createFont("Agency FB",24);
  
  bg=0;
  speed=0;
  gameState=START;
  for(int n=0; n<5; n++){showing[n] = true;}
  for(int i=0; i<5; i++){flames[i] = loadImage("img/flame"+(i+1)+".png");}
  for(int c=0; c<5; c++){shoot[c]= loadImage("img/shoot.png");}
  for(int c=0; c<5; c++){shooting[c]= false;}
}
void draw() {
 switch(gameState){
  case START:
  image(start2,0,0);
  if(mouseX<=450 && mouseX>=200 && mouseY<=430 && mouseY>=380){
   if(mousePressed){gameState=PLAYING;}
   else{image(start1,0,0);}}
  //restart
  timer=0;
   straightMode=true;
   ftX=580;
   ftY=260;
   trX=floor(random(0,600));
   trY=floor(random(45,430));
   enemyStart=floor(random(45,430));
   enemySpeed=0;
   hps=199*2/10;
   score=0;
   for(int n=0; n<5; n++){
   explode[n]=false;
   showing[n] = true;
   shooting[n]=false;}
  break;
 
  case PLAYING:
  //background
   bg++;
   bg%=1282;
   image(bg1,bg,0);
   image(bg2,bg-641,0);
   image(bg1,bg-1282,0);
   
  //treasure
   image(treasure, trX, trY);
   FighterTreasureHit=isHit(ftX, ftY, 50, 50, trX, trY, 50, 50);
   if(FighterTreasureHit==true){
     image(treasure, trX, trY);
     trY=floor(random(45,430));
     trX=floor(random(0,600));
     hps+=199/10;
     if(hps>=199){
     hps=199;}}
     scoreChange(score);
     
  //enemy
   //move 
   enemySpeed+=3;
   /*if(upPressed){
    if(enY+30>ftY+25){enY-=(speed-2);}
    if(enY+30<ftY+25){enY+=(speed-2);}
    else if(enY+30==ftY+25){enY=ftY;}}
   else if(downPressed){
    if(enY+30<ftY+25){enY+=(speed-2);}
    if(enY+30>ftY+25){enY-=(speed-2);}
    else if(enY+30==ftY+25){enY=ftY;}}
   else if(enY+30==ftY+25){enY=ftY;}
   else{
    if(enY+30>ftY+25){enY-=(speed-2);}
    if(enY+30<ftY+25){enY+=(speed-2);}
    else if(enY+30==ftY+25){enY=ftY;}} */
  
 //shoot
  for(int c=0;c<5;c++){
   if(shooting[c]){
    bullet[c][0]-=5;  
    shX= bullet[c][0];
    shY= bullet[c][1];
    image(shoot[c],shX,shY);
   }
   if(shX-shootingSpeed<=0){
    shooting[c]=false;
    shX=2000;
   }
  }

//enemies
   
   timer+=3;
   if(timer==981){
    enemySpeed=0;
    enemyStart=floor(random(0,130));
    straightMode=false;
    tiltMode=true;
    for(int n=0; n<5; n++){
    showing[n]=true;}
   }
   if(timer==1962){
    enemySpeed=0;
    enemyStart=floor(random(0,180));
    tiltMode=false;
    squareMode=true;
    for(int n=0; n<8; n++){
    showing[n]=true;}
   }
   if(timer==2901){
    enemySpeed=0;
    enemyStart=floor(random(0,420));
    squareMode=false;
    straightMode=true;
    timer=0;
    for(int n=0; n<5; n++){
    showing[n]=true;}
   }

int i=floor((currentFrame++)/6%5);

   //straight
   if(straightMode){
    for(int n=0; n<5; n++){
   if(showing[n]){
    enemyXY[n][0]=enemySpeed+n*70-340;
    enemyXY[n][1]=enemyStart;
    enX= enemyXY[n][0];
    enY= enemyXY[n][1];
    image(enemy,enX,enY);
   }
   if(showing[n]){
   EnemyFighterHit=isHit(enX, enY, 60, 60, ftX, ftY, 50, 50);
   if(EnemyFighterHit==true){
        showing[n]=false;
        explode[n]=true;
        currentFrame=0;
        hps-=2*199/10;}
   for(int c=0; c<5; c++){
   if(shooting[c]==true){
   EnemyBulletHit=isHit(enX, enY, 60, 60, shX, shY, 30, 30);
   if(EnemyBulletHit==true){
        showing[n]=false;
        shooting[c]=false;shX=2000;
        explode[n]=true;
        score++;
        currentFrame=0;}
   }
   }
   }
    //explode
    if(explode[n]){
       image(flames[i], enemyXY[n][0], enemyXY[n][1]);       
       if(frameCount%(60/10)==0){
       timerExplode++;}
   }
   if(timerExplode==4){explode[n]=false;timerExplode=0;}
    }
  }
   
   
   //tilt
   if(tiltMode){
    for(int n=0; n<5; n++){
   if(showing[n]){
    enemyXY[n][0]=enemySpeed+n*70-340;
    enemyXY[n][1]=enemyStart+n*70;
    enX= enemyXY[n][0];
    enY= enemyXY[n][1];
    image(enemy,enX,enY);
   }
   if(showing[n]){
   EnemyFighterHit=isHit(enX, enY, 60, 60, ftX, ftY, 50, 50);
   if(EnemyFighterHit==true){
        showing[n]=false;
        explode[n]=true;
        currentFrame=0;
        hps-=2*199/10;}
   for(int c=0; c<5; c++){
   if(shooting[c]==true){
   EnemyBulletHit=isHit(enX, enY, 60, 60, shX, shY, 30, 30);
   if(EnemyBulletHit==true){
        showing[n]=false;
        shooting[c]=false;shX=2000;
        explode[n]=true;
        score++;
        currentFrame=0;}
   }
   }
   }  
  //explode
    if(explode[n]){
       image(flames[i], enemyXY[n][0], enemyXY[n][1]);       
       if(frameCount%(60/10)==0){
       timerExplode++;}
   }
   if(timerExplode==4){explode[n]=false;timerExplode=0;}
   }
   }
     
     
   //square
   if(squareMode){
    for(int n=0; n<3; n++){
   if(showing[n]){
    enemyXY[n][0]=enemySpeed+n*60-200;
    enemyXY[n][1]=enemyStart+n*60;
    enX= enemyXY[n][0];
    enY= enemyXY[n][1];
    image(enemy,enX,enY);
   }
   if(showing[n]){
   EnemyFighterHit=isHit(enX, enY, 60, 60, ftX, ftY, 50, 50);
   if(EnemyFighterHit==true){
        showing[n]=false;
        explode[n]=true;
        currentFrame=0;
        hps-=2*199/10;}
   for(int c=0; c<5; c++){
   if(shooting[c]==true){
   EnemyBulletHit=isHit(enX, enY, 60, 60, shX, shY, 30, 30);
   if(EnemyBulletHit==true){
        showing[n]=false;
        shooting[c]=false;shX=2000;
        explode[n]=true;
        score++;
        currentFrame=0;}
   }
   }
   }  
  //explode
    if(explode[n]){
       image(flames[i], enemyXY[n][0], enemyXY[n][1]);       
       if(frameCount%(60/10)==0){
       timerExplode++;}
   }
   if(timerExplode==4){explode[n]=false;timerExplode=0;}
   }
   
    for(int n=3; n<6; n++){
   if(showing[n]){
    enemyXY[n][0]=enemySpeed+(n-3)*60-320;
    enemyXY[n][1]=enemyStart+(n-3)*60+120;
    enX= enemyXY[n][0];
    enY= enemyXY[n][1];
    image(enemy,enX,enY);
   }
   if(showing[n]){
   EnemyFighterHit=isHit(enX, enY, 60, 60, ftX, ftY, 50, 50);
   if(EnemyFighterHit==true){
        showing[n]=false;
        explode[n]=true;
        currentFrame=0;
        hps-=2*199/10;}
   for(int c=0; c<5; c++){
   if(shooting[c]==true){
   EnemyBulletHit=isHit(enX, enY, 60, 60, shX, shY, 30, 30);
   if(EnemyBulletHit==true){
        showing[n]=false;
        shooting[c]=false;shX=2000;
        explode[n]=true;
        score++;
        currentFrame=0;}
   }
   }
   }  
  //explode
    if(explode[n]){
       image(flames[i], enemyXY[n][0], enemyXY[n][1]);       
       if(frameCount%(60/10)==0){
       timerExplode++;}
   }
   if(timerExplode==4){explode[n]=false;timerExplode=0;}
   } 
   
    for(int n=6; n<8; n++){
   if(showing[n]){
    enemyXY[n][0]=enemySpeed+(n-6)*120-260;
    enemyXY[n][1]=enemyStart+(n-6)*120+60;
    enX= enemyXY[n][0];
    enY= enemyXY[n][1];
    image(enemy,enX,enY);
   }
   if(showing[n]){
   EnemyFighterHit=isHit(enX, enY, 60, 60, ftX, ftY, 50, 50);
   if(EnemyFighterHit==true){
        showing[n]=false;
        explode[n]=true;
        currentFrame=0;
        hps-=2*199/10;}
   for(int c=0; c<5; c++){
   if(shooting[c]==true){
   EnemyBulletHit=isHit(enX, enY, 60, 60, shX, shY, 30, 30);
   if(EnemyBulletHit==true){
        showing[n]=false;
        shooting[c]=false;shX=2000;
        explode[n]=true;
        score++;
        currentFrame=0;}
   }
   }
   }  
  //explode
    if(explode[n]){
       image(flames[i], enemyXY[n][0], enemyXY[n][1]);       
       if(frameCount%(60/10)==0){
       timerExplode++;}
   }
   if(timerExplode==4){explode[n]=false;timerExplode=0;}
    }
 }
        
   //boundary
    if(enY>height-60){enY=height-60;}
    if(enY<0){enY=0;}
    
   /*//crash
   image(enemy, enX, enY);
   if(enY+60>=ftY && ftY>=enY-50){
    if(enX-50<=ftX && ftX<=enX+60){
     image(enemy, enX, enY);
     enY=floor(random(45,420));
     enX=0;
     hps-=2*199/10;}}*/
  
  //fighter
   //move
    speed++;
    if(speed>=4){speed=4;}
    if(upPressed){ftY-=speed;}
    if(downPressed){ftY+=speed;} 
    if(leftPressed){ftX-=speed;}
    if(rightPressed){ftX+=speed;}
    
  //boundary
    if(ftX>width-50){ftX=width-50;}
    if(ftX<0){ftX=0;}
    if(ftY>height-50){ftY=height-50;}
    if(ftY<0){ftY=0;}
  image(fighter, ftX, ftY);
  
  //hp
   fill(255,0,0);
   noStroke();
   rect(22, 15, hps, 30);
   image(hp, 15, 15);
   if(hps<=0){
    hps=0;
    gameState=END;
    }
    

 break;
 
 case END:
  image(end2,0,0);
  if(mouseX<=450 && mouseX>=200 && mouseY<=350 && mouseY>=320){
   if(mousePressed){gameState=START;}
   else{image(end1,0,0);}
   straightMode=false;
   tiltMode=false;
   squareMode=false;
 break;
 }
}
}

void keyPressed(){
  if(key==CODED){
    switch(keyCode){
    case UP:
    upPressed = true;
    break;
    case DOWN:
    downPressed = true;
    break;  
    case LEFT:
    leftPressed = true;
    break;
    case RIGHT:
    rightPressed = true;
    break;  
  }
  }
  if(key==' '){
    if(shooting[c]==false){
     shooting[c]=true;
     bullet[c][0]=ftX;
     bullet[c][1]=ftY+10;
     c++; c=c%5;
     key='d';}
  }
  }
   
void keyReleased(){
  if(key==CODED){
    switch(keyCode){
    case UP:
    upPressed = false;
    break;
    case DOWN:
    downPressed = false;
    break;  
    case LEFT:
    leftPressed = false;
    break;
    case RIGHT:
    rightPressed = false;
    break; 
  }
  }
}

void scoreChange(int score){
textFont(f,30);
//textAlign(CORNER)
fill(255);
text("score: "+score*20,10, 465);
}
