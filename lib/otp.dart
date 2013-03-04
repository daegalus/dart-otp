library otp;
import 'dart:crypto';
import 'dart:math';
import 'package:base32/base32.dart';

class OTP {
  static int generateTOTPCode(String secret, int time, {int length: 6}) {
    time = (((time ~/ 1000).round())~/30).floor();
    return _generateCode(secret, time, length);
  }

  static int generateHOTPCode(String secret, int counter, {int length: 6}) {
    return _generateCode(secret, counter, length);
  }

  static int _generateCode(String secret, int time, int length){
    length = (length <=8 && length > 0) ? length : 6;


    var secretList = base32.decode(secret);
    var timebytes = _int2bytes(time);

    var hmac = new HMAC(new SHA1(), secretList);
    hmac.add(timebytes);
    var hash = hmac.close();

    int offset = hash[hash.length - 1] & 0xf;

    int binary = ((hash[offset] & 0x7f) << 24) |
                 ((hash[offset + 1] & 0xff) << 16) |
                 ((hash[offset + 2] & 0xff) << 8) |
                 (hash[offset + 3] & 0xff);

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