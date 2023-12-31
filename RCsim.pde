
//int[] ROM = {0,129,11,129,13,129,19,12,1,14,2,3,15,16,19,12,13,16,11,134,10};//Fib Sqnc
int[] ROM = {0,129,11,129,13,129,19,12,1,14,2,3,15,150,22,16,19,12,13,16,11,134,10,0};//Fib Sqnc auto-stop
//int[] ROM = {0,128,7,9,11,129,7,9,13,18,4,14,5,156,24,16,1,12,2,3,15,18,1,129,2,3,17,136,10,16,19,0};//multiply
int[] RAM = {5,12,0,0};

int realROMlength;

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
int runSpeed = 10;

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
  zeroROM();
}

void zeroROM(){//makes ROM 256 bytes long
  realROMlength = ROM.length;
  int[] tempROM = ROM;
  ROM = new int[256];
  for(int i = 0; i < tempROM.length; i++){
    ROM[i] = tempROM[i];
  }
}

void draw(){
  runHardware();
  drawBackground();
  drawProgMem(25,25,300,750);
  if(autoRun){
    if(millis() > runTimer){
      runTimer = millis() + runSpeed;
      clock();
    }
  }
}


/*
Keybinds:
Space = advance clock by 1
S = Sets the program addr to 1
R = toggles autoRun
C = Clear all registers in the computer
Q = Quit the simulation
*/
void keyPressed(){
  if(key == ' '){//lol, almost tried to add capital space
    clock();
  } else if(key == 's' || key == 'S') {
    PA = 1;
  } else if(key == 'r' || key == 'R'){
    autoRun = !autoRun;
  } else if(key == 'c' || key == 'C'){
    clearReg();
  } else if(key == 'q' || key == 'Q'){
    exit();
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
      if(PA > 255){
        PA = PA - 256;
      }
    }
  } else {
    bus = 0;
    clearBusTracker = 0;
  }
  runHardware();
}

void runHardware(){
  PV = ROM[PA];
  RV = RAM[RA];
  AO = AA + AB;
  if(AO > 255){
    AO = AO - 256;
    overflow = true;
    //println("Overflow");
  }
  SO = SA - SB;
  if(SO < 0){
    SO = SO + 256;
    underflow = true;
    //println("Underflow");
  }
  if(SO == 0){
    ans0 = true;
  } else {
    ans0 = false;
  }
}

void drawProgMem(int x1, int y1, int x2, int y2){
  strokeWeight(10);
  stroke(127);
  fill(40);
  rect(x1, y1, x2, y2);//main box
  strokeWeight(5);
  rect(x1 + 25, y1 + 55, x2 - 50, 40);//addr
  rect(x1 + 25, y1 + 95, x2 - 50, 40);//value
  fill(255);
  textAlign(CENTER);
  textSize(32);
  text("Program Memory", x1 + (x2/2), y1 + 40);
  textAlign(LEFT);
  textSize(20);
  text("Address:" , x1 + 40, y1 +  80);
  text("Value:"   , x1 + 40, y1 + 120);
  textAlign(RIGHT);
  text(PA                    , x1 + x2 - 40, y1 +  80);
  text(opName(PV) + ": " + PV, x1 + x2 - 40, y1 + 120);
  textAlign(LEFT);
  textSize(16);
  for(int i = 0; i < realROMlength; i++){
    if(i == PA){
      fill(255);
    } else {
      fill(180);
    }
    text(ROMstring(i), x1 + 40, y1 + 160 + ((y2-160.0) / realROMlength) * i);
  }
}

String ROMstring(int ROMline){
  String output = "";
  if(ROMline < 10){
    output += "0";
  }
  output += ROMline + ": ";
  if(ROM[ROMline] < 100){
    output += "  ";
  }
  if(ROM[ROMline] < 10){
    output += "  ";
  }
  output += ROM[ROMline] + "  ";
  output += opName(ROM[ROMline]);
  return(output);
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
  } else if (input == 20){
    overflow = false;
  } else if (input == 21){
    underflow = false;
  } else if (input == 22){
    if(overflow){
      PA = bus;
    }
  } else if (input == 23){
    if(underflow){
      PA = bus;
    }
  } else if (input == 24){
    if(ans0){
      PA = bus;
    }
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
  } else if (input == 20){
    return("Clear Overflow");
  } else if (input == 21){
    return("Clear Underflow");
  } else if (input == 22){
    return("Jump if overflow");
  } else if (input == 23){
    return("Jump if underflow");
  } else if (input == 24){
    return("Jump if ans0");
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
