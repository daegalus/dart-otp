library otp;

import 'dart:math';
import 'dart:typed_data';
import 'package:base32/base32.dart';
import 'package:pointycastle/pointycastle.dart';

class OTP {
  /// Generates a Time-based one time password code
  ///
  /// Takes current time in milliseconds, converts to seconds and devides it by interval to get a code every iteration of the interval.
  /// A interval of 1 will be the same as if passing time into the HOTPCode function..
  ///
  /// Optional parameters to change the length of the code provided (default 6), interval (default 30), and hashing algorithm (default SHA1)
  /// These settings are defaulted to the RFC standard but can be changed.
  static int generateTOTPCode(String secret, int time,
      {int length = 6,
      int interval = 30,
      Algorithm algorithm = Algorithm.SHA1}) {
    time = (((time ~/ 1000).round()) ~/ interval).floor();
    return _generateCode(secret, time, length, getAlgorithm(algorithm));
  }

  /// Generates a one time password code based on a counter you provide and increment.
  ///
  /// This function does not increment for you.
  /// Optional parameters to change the length of the code provided (default 6) and hashing algorithm (default SHA1)
  /// These settings are defaulted to the RFC standard but can be changed.
  static int generateHOTPCode(String secret, int counter,
      {int length = 6, Algorithm algorithm = Algorithm.SHA1}) {
    return _generateCode(secret, counter, length, getAlgorithm(algorithm));
  }

  static int _generateCode(String secret, int time, int length, Mac mac) {
    length = (length > 0) ? length : 6;

    var secretList = base32.decode(secret);
    var timebytes = _int2bytes(time);

    var hmac = mac..init(KeyParameter(secretList));
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

  /// Gets the Mac for the provided algorithm.
  static Mac getAlgorithm(Algorithm algorithm) {
    switch (algorithm) {
      case Algorithm.SHA224:
        return Mac('SHA-224/HMAC');
      case Algorithm.SHA256:
        return Mac('SHA-256/HMAC');
      case Algorithm.SHA384:
        return Mac('SHA-384/HMAC');
      case Algorithm.SHA512:
        return Mac('SHA-512/HMAC');
      default:
        return Mac('SHA-1/HMAC');
    }
  }
}

enum Algorithm { SHA1, SHA224, SHA256, SHA384, SHA512 }
