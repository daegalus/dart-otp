import '../packages/base32/base32.dart';
import 'dart:math';
import 'dart:crypto';

main() {
  print(OTP.generateCode("JBSWY3DPEHPK3PXP", (new Date.now()).toUtc().millisecondsSinceEpoch));
}

class OTP {
  static int generateCode(String secret, int time, {int length: 6}){
    length = (length <=8 && length > 0) ? length : 6;
    time = (((time ~/ 1000).round())~/30).floor();
    
    var secretList = base32.decode(secret);
    var timebytes = _int2bytes(time);
    
    var hmac = new HMAC(new SHA1(), timebytes);
    hmac.update(secretList);
    var hash = hmac.digest();
 
    int offset = hash[hash.length - 1] & 0xf;
    print("hash ${CryptoUtils.bytesToHex(hash)}");
    print("offset ${offset}");
    int binary = ((hash[offset] & 0x7f) << 24) |
                 ((hash[offset + 1] & 0xff) << 16) |
                 ((hash[offset + 2] & 0xff) << 8) |
                 (hash[offset + 3] & 0xff);
    
    print(binary);

    return binary % pow(10,length);
  }
  
  static String randomSecret() {
    var rand = new Random();
    var bytes = new List();
    
    for(int i = 0; i < 10; i++) {
      bytes.add(rand.nextInt(256));
    }
    
    return base32.encode(bytes);
  }
  
  static String _dec2hex(int s) { 
    var st = s.round().toRadixString(16);
    return (st.length % 2 == 0) ? st : '0'.concat(st); 
  } 
  
  static String _leftpad(String str, int len, String pad) {
    var padded = '';
    for(int i = str.length; i < len; i++) {
      padded = padded.concat(pad);
    }
    return padded.concat(str);
  }
  
  static List _hex2bytes(hex) {
    List bytes = new List(hex.length~/2);
    for(int i=0; i < hex.length; i+=2) {
      var hexBit = "0x${hex[i]}${hex[i+1]}";
      int parsed = int.parse(hexBit);
      bytes[i~/2] = parsed;
    }
    return bytes;
  }
  
  static List _int2bytes(int long) {
    // we want to represent the input as a 8-bytes array
    var byteArray = [0, 0, 0, 0, 0, 0, 0, 0];
    for ( var index = byteArray.length-1; index >= 0; index -- ) {
        var byte = long & 0xff;
        byteArray [ index ] = byte;
        long = (long - byte) ~/ 256 ;
    }
    return byteArray;
  }

  static int _bytes2int(/*byte[]*/byteArray) {
    var value = 0;
    for ( var i = byteArray.length - 1; i >= 0; i--) {
        value = (value * 256) + byteArray[i];
    }
    return value;
  }
}