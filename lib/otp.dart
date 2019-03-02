library otp;

import 'dart:math';
import 'dart:typed_data';
import 'package:base32/base32.dart';
import "package:pointycastle/pointycastle.dart";
import "package:pointycastle/digests/sha512.dart";
import "package:pointycastle/digests/sha256.dart";
import "package:pointycastle/digests/sha1.dart";
import "package:pointycastle/macs/hmac.dart";

class OTP {
  static int generateTOTPCode(String secret, int time, {int length = 6, int interval = 30, Algorithm algorithm = Algorithm.SHA1}) {
    time = (((time ~/ 1000).round()) ~/ interval).floor();
    return _generateCode(secret, time, length, getAlgorithm(algorithm));
  }

  static int generateHOTPCode(String secret, int counter, {int length = 6, Algorithm algorithm = Algorithm.SHA1}) {
    return _generateCode(secret, counter, length, getAlgorithm(algorithm));
  }

  static int _generateCode(String secret, int time, int length, Digest digest) {
    length = (length > 0) ? length : 6;

    var secretList = base32.decode(secret);
    var timebytes = _int2bytes(time);

    var hmac = HMac(digest, 64)..init(KeyParameter(secretList));
    var hash = hmac.process(timebytes);

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

  static Uint8List _int2bytes(int long) {
    // we want to represent the input as a 8-bytes array
    var byteArray = Uint8List(8);
    for (var index = byteArray.length - 1; index >= 0; index--) {
      var byte = long & 0xff;
      byteArray[index] = byte;
      long = (long - byte) ~/ 256;
    }
    return byteArray;
  }

  static Digest getAlgorithm(Algorithm algorithm) {
    switch(algorithm) {
      case Algorithm.SHA256:
        return SHA256Digest();
      case Algorithm.SHA512:
        return SHA512Digest();
      default:
        return SHA1Digest();
    }
  }
}

enum Algorithm {
  SHA1, SHA256, SHA512
}
