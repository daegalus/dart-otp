library otp;

import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:base32/base32.dart';

class OTP {
  static int generateTOTPCode(String secret, int time, {int length = 6, int interval = 30, Algorithm algorithm = Algorithm.SHA1}) {
    time = (((time ~/ 1000).round()) ~/ interval).floor();
    return _generateCode(secret, time, length, getAlgorithm(algorithm));
  }

  static int generateHOTPCode(String secret, int counter, {int length = 6, Algorithm algorithm = Algorithm.SHA1}) {
    return _generateCode(secret, counter, length, getAlgorithm(algorithm));
  }

  static int _generateCode(String secret, int time, int length, Hash algorithm) {
    length = (length > 0) ? length : 6;

    var secretList = base32.decode(secret);
    var timebytes = _int2bytes(time);

    var hmac = Hmac(algorithm, secretList);
    var hash = hmac.convert(timebytes).bytes;

    int offset = hash[hash.length - 1] & 0xf;

    int binary = ((hash[offset] & 0x7f) << 24) |
        ((hash[offset + 1] & 0xff) << 16) |
        ((hash[offset + 2] & 0xff) << 8) |
        (hash[offset + 3] & 0xff);

    return binary % pow(10, length);
  }

  static String randomSecret() {
    var rand = Random();
    var bytes = List();

    for (int i = 0; i < 10; i++) {
      bytes.add(rand.nextInt(256));
    }

    return base32.encode(bytes);
  }

  static List _int2bytes(int long) {
    // we want to represent the input as a 8-bytes array
    var byteArray = [0, 0, 0, 0, 0, 0, 0, 0];
    for (var index = byteArray.length - 1; index >= 0; index--) {
      var byte = long & 0xff;
      byteArray[index] = byte;
      long = (long - byte) ~/ 256;
    }
    return byteArray;
  }

  static Hash getAlgorithm(Algorithm algorithm) {
    switch(algorithm) {
      case Algorithm.SHA256:
        return sha256;
      case Algorithm.SHA512:
        //TODO: implement
      default:
        return sha1;
    }
  }
}

enum Algorithm {
  SHA1, SHA256, SHA512
}
