
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
    Mcode[McodeL] = Mcode[McodeL] + String(binL) + ":";
    bin[binL] = opNameToCode(ASMtoOpCode(asm[ASML],false),false);
    Mcode[McodeL] = Mcode[McodeL] + String(bin[binL]) + "  " + opCodeToDesc(bin[binL]);
    McodeL++;
    binL++;
    if(ASML < 10){
      Mcode[McodeL] = "0";
    }
    Mcode[McodeL] = Mcode[McodeL] + String(binL) + ":";
    bin[binL] = opNameToCode(ASMtoOpCode(asm[ASML],true),true);
    Mcode[McodeL] = Mcode[McodeL] + String(bin[binL]) + "  " + opCodeToDesc(bin[binL]);
  }
}


String opCodeToDesc(int input){
  switch(input) {
    case "AA":
      return(1);
      break;
    case "AB":
      return(2);
      break;
    case "SA":
      return(4);
      break;
    case "SB":
      return(5);
      break;
    case "RA":
      return(7);
      break;
    case "RV":
      return(8);
      break;
    case "PA":
      return(10);
      break;
    case "CA":
      return(11);
      break;
    case "CB":
      return(13);
      break;
    case "CC":
      return(15);
      break;
    case "CD":
      return(17);
      break;
    case "OR":
      return(19);
      break;
    case "FO":
      return(20);
      break;
    case "FU":
      return(21);
      break;
    case "JO":
      return(22);
      break;
    case "JU":
      return(23);
      break;
    case "J0":
      return(24);
      break;
    default:
      return(0);
      break;
    }
}


int opNameToCode(String input, boolean load){
  if(load){
    switch(input) {
      case "AA":
        return(1);
        break;
      case "AB":
        return(2);
        break;
      case "SA":
        return(4);
        break;
      case "SB":
        return(5);
        break;
      case "RA":
        return(7);
        break;
      case "RV":
        return(8);
        break;
      case "PA":
        return(10);
        break;
      case "CA":
        return(11);
        break;
      case "CB":
        return(13);
        break;
      case "CC":
        return(15);
        break;
      case "CD":
        return(17);
        break;
      case "OR":
        return(19);
        break;
      case "FO":
        return(20);
        break;
      case "FU":
        return(21);
        break;
      case "JO":
        return(22);
        break;
      case "JU":
        return(23);
        break;
      case "J0":
        return(24);
        break;
      default:
        return(0);
        break;
    }
  } else {
    if(input.charAt(0) == "L"){
      return(int(subset(input, 1, input.length())) + 128);
    } else {
      switch(input) {
        case "AO":
          return(3);
          break;
        case "SO":
          return(6);
          break;
        case "RV":
          return(9);
          break;
        case "CA":
          return(12);
          break;
        case "CB":
          return(14);
          break;
        case "CC":
          return(16);
          break;
        case "CD":
          return(18);
          break;
        case "FO":
          return(20);
          break;
        case "FU":
          return(21);
          break;
        default:
          return(0);
          break;
      }
    }
  }
}

String ASMtoOpCode(String input, boolean load){
  if(load){
    return(subset(input, 12, 13);
  } else {
    if(input.charAt(6) == 'L'){
      String output = subset(input, 6, 7);  
      if(input.charAt(8) != ' '){
        output = output + input.charAt(8);
      }
      if(input.charAt(9) != '-'){
        output = putput + input.charAt(9);
      }
      return(output);
    } else {
      return(subset(input, 6, 7);
    }
  }
}

String lineNumber(String input){
  return(subset(input, 0, 4));
}
