
int[] ROM = {0,129,11,129,1,3,19,12,13,12,1,14,2,3,19,12,13,3,11,136,10};

/* Op codes

Adder: A
01 Load A
02 Load B
03 Post Output

Sub: S
04 Load A
05 Load B
06 Post Output

RAM: R
07 Load Address
08 Load Value
09 Post Value

Program Memeory: P
10 Load Address

Cache: C
11 Load A
12 Post A
13 Load B
14 Post B
15 Load C
16 Post C
17 Load D
18 Post D

Return Output: R
19 Load Output

*/

boolean autoRun;
int runTimer;
int runSpeed = 100;

boolean overflow, underflow, ans0;

int bus;
int AA, AB, AO;//add
int SA, SB, SO;//sub
int RA, RV;//ram addr, ram value
int PA, PV; //Program
int CA, CB, CC, CD;//cache

void setup(){
  size(1500,800);
  clearReg();
  PA = 1;//Auto run code
}

void draw(){
  runHardware();
  drawBackground();
  if(autoRun){
    if(millis() > runTimer){
      runTimer = millis() + runSpeed;
      clock();
    }
  }
}

void keyPressed(){
  if(key == ' '){
    clock();
  } else if(key == 's') {
    PA = 1;
  } else if(key == 'r'){
    autoRun = !autoRun;
  } else if(key == 'c'){
    clearReg();
  }
}

int clearBusTracker;

void clock(){
  runHardware();
  if(clearBusTracker < 2){
    runInstruction(PV);
    clearBusTracker++;
    if(PA != 0){
      PA++;
    }
  } else {
    bus = 0;
    clearBusTracker = 0;
  }
  runHardware();
}

void runHardware(){
  PV = ROM[PA];
  AO = AA + AB;
  if(AO > 255){
    AO = AO - 255;
    overflow = true;
    println("Overflow");
  }
  SO = SA - SB;
  if(SO < 0){
    SO = SO + 255;
    underflow = true;
    println("Underflow");
  }
  if(SO == 0){
    ans0 = true;
  } else {
    ans0 = false;
  }
}

void drawBackground(){
  background(0);
  strokeWeight(9);
  stroke(127);
  fill(40);
  rect(600,100,300,600);
  rect(950,100,260,180);
  rect(950,300,260,180);
  rect(950,550,260,160);
  rect(280,100,275,140);
  rect(280,280,275,170);
  fill(200);
  textSize(20);
  textAlign(LEFT);
  text("Bus", 730, 140);
  text(bus, 700, 200);
  text("Adder", 1060, 140);
  text("A: " + AA, 1000, 170);
  text("B: " + AB, 1000, 210);
  text("Output: " + AO, 1000, 250);
  text("Subtractor", 1034, 337);
  text("A: " + SA, 1000, 380);
  text("B: " + SB, 1000, 420);
  text("Output: " + SO, 1000, 450);
  text("RAM", 1060, 590);
  text("Address: " + RA, 1000, 620);
  text("Value: " + RV, 1000, 660);
  text("Program Counter", 300, 140);
  text("Address: " + PA, 300, 170);
  text("Value:" + PV + " (" + opName(PV) + ")", 300, 200);
  text("Cache", 300, 320);
  text("A: " + CA, 300, 350);
  text("B: " + CB, 300, 375);
  text("C: " + CC, 300, 400);
  text("D: " + CD, 300, 425);
}

void runInstruction(int input){
  if(input > 127){
    bus = input - 128;
  } else if(input == 0){
    PA = 0;
  } else if(input == 1){
    AA = bus;
  } else if (input == 2){
    AB = bus;
  } else if (input == 3){
    bus = AO;
  } else if (input == 4){
    SA = bus;
  } else if (input == 5){
    SB = bus;
  } else if (input == 6){
    bus = SO;
  } else if (input == 7){
    RA = bus;
  } else if (input == 8){
    RV = bus;
  } else if (input == 9){
    bus = RV;
  } else if (input == 10){
    PA = bus;
  } else if (input == 11){
    CA = bus;
  } else if (input == 12){
    bus = CA;
  } else if (input == 13){
    CB = bus;
  } else if (input == 14){
    bus = CB;
  } else if (input == 15){
    CC = bus;
  } else if (input == 16){
    bus = CC;
  } else if (input == 17){
    CD = bus;
  } else if (input == 18){
    bus = CD;
  } else if (input == 19){
    println(bus);
  }
}

String opName(int input){
  if(input > 127){
    return("Post number: " + (input - 128));
  } else if(input == 0){
    return("Halt");
  } else if(input == 1){
    return("Load AA");
  } else if (input == 2){
    return("Load AB");
  } else if (input == 3){
    return("Post AO");
  } else if (input == 4){
    return("Load SA");
  } else if (input == 5){
    return("Load SB");
  } else if (input == 6){
    return("Post SO");
  } else if (input == 7){
    return("Load RAM Addrs");
  } else if (input == 8){
    return("Load RAM Value");
  } else if (input == 9){
    return("Post RAM Value");
  } else if (input == 10){
    return("Load Program Addrs");
  } else if (input == 11){
    return("Load Cache A");
  } else if (input == 12){
    return("Post Cache A");
  } else if (input == 13){
    return("Load Cache B");
  } else if (input == 14){
    return("Post Cache B");
  } else if (input == 15){
    return("Load Cache C");
  } else if (input == 16){
    return("Post Cache C");
  } else if (input == 17){
    return("Load Cache D");
  } else if (input == 18){
    return("Post Cache D");
  } else if (input == 19){
    return("Output Bus");
  } else {
    return("Invalid op code");
  }
}

void clearReg(){
  clearBusTracker = 0;
  overflow = false;
  underflow = false;
  ans0 = false;
  bus = 0;
  AA = 0;
  AB = 0;
  AO = 0;
  SA = 0;
  SB = 0;
  SO = 0;
  RA = 0;
  RV = 0;
  PA = 0;
  CA = 0;
  CB = 0;
  CC = 0;
  CD = 0;
}
