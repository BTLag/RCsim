
String[] asm;

String[] Mcode;
int[] bin;

void buildMcode(){
  Mcode[0] = "0";
  Mcode[1] = "00:0  Halt";
  int McodeL = 2;
  int binL = 0;
  for(int ASML = 0; ASML < asm.length; ASML++){
    Mcode[McodeL] = lineNumber(asm[ASML]);
    McodeL++;
    binL++;
    if(ASML < 10){
      Mcode[McodeL] = "0";
    }
    Mcode[McodeL] = Mcode[McodeL] + binL + ":";
    bin[binL] = opNameToCode(ASMtoOpCode(asm[ASML],false),false);
    Mcode[McodeL] = Mcode[McodeL] + bin[binL] + "  " + opCodeToDesc(bin[binL]);
    McodeL++;
    binL++;
    if(ASML < 10){
      Mcode[McodeL] = "0";
    }
    Mcode[McodeL] = Mcode[McodeL] + binL + ":";
    bin[binL] = opNameToCode(ASMtoOpCode(asm[ASML],true),true);
    Mcode[McodeL] = Mcode[McodeL] + bin[binL] + "  " + opCodeToDesc(bin[binL]);
    McodeL++;
  }
}

String opCodeToDesc(int input){
  switch(input) {
    case 0:
      return("Halt");
    case 1:
      return("load AA");
    case 2:
      return("load AB");
    case 3:
      return("post AO");
    case 4:
      return("load SA");
    case 5:
      return("load SB");
    case 6:
      return("post SO");
    case 7:
      return("load RA");
    case 8:
      return("load RV");
    case 9:
      return("post RV");
    case 10:
      return("Jump to address");
    case 11:
      return("load CA");
    case 12:
      return("post CA");
    case 13:
      return("load CB");
    case 14:
      return("post CB");
    case 15:
      return("load CC");
    case 16:
      return("post CC");
    case 17:
      return("load CD");
    case 18:
      return("post CD");
    case 19:
      return("Output return");
    case 20:
      return("Clear overflow");
    case 21:
      return("Clear underflow");
    case 22:
      return("Jump if overflow");
    case 23:
      return("Jump if underflow");
    case 24:
      return("Jump if ans0");
    default:
      return("Invalid op code");
    }
}

int opNameToCode(String input, boolean load){
  if(load){
    switch(input) {
      case "AA":
        return(1);
      case "AB":
        return(2);
      case "SA":
        return(4);
      case "SB":
        return(5);
      case "RA":
        return(7);
      case "RV":
        return(8);
      case "PA":
        return(10);
      case "CA":
        return(11);
      case "CB":
        return(13);
      case "CC":
        return(15);
      case "CD":
        return(17);
      case "OR":
        return(19);
      case "FO":
        return(20);
      case "FU":
        return(21);
      case "JO":
        return(22);
      case "JU":
        return(23);
      case "J0":
        return(24);
      default:
        return(0);
    }
  } else {
    if(input.charAt(0) == 'L'){
      return(int(input.substring(1, input.length())) + 128);
    } else {
      switch(input) {
        case "AO":
          return(3);
        case "SO":
          return(6);
        case "RV":
          return(9);
        case "CA":
          return(12);
        case "CB":
          return(14);
        case "CC":
          return(16);
        case "CD":
          return(18);
        case "FO":
          return(20);
        case "FU":
          return(21);
        default:
          return(0);
      }
    }
  }
}

String ASMtoOpCode(String input, boolean load){
  if(load){
    return(input.substring(12, 13));
  } else {
    if(input.charAt(6) == 'L'){
      String output = input.substring(6, 7);  
      if(input.charAt(8) != ' '){
        output = output + input.charAt(8);
      }
      if(input.charAt(9) != '-'){
        output = output + input.charAt(9);
      }
      return(output);
    } else {
      return(input.substring(6, 7));
    }
  }
}

String lineNumber(String input){
  return(input.substring(0, 4));
}
