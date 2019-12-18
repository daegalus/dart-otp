library otp;

import 'dart:math';
import 'dart:typed_data';
import 'package:base32/base32.dart';
import 'package:crypto/crypto.dart';

class OTP {
  /// Generates a Time-based one time password code
  ///
  /// Takes current time in milliseconds, converts to seconds and devides it by interval to get a code every iteration of the interval.
  /// A interval of 1 will be the same as if passing time into the HOTPCode function..
  ///
  /// Optional parameters to change the length of the code provided (default 6), interval (default 30), and hashing algorithm (default SHA1)
  /// These settings are defaulted to the RFC standard but can be changed.
  static int generateTOTPCode(String secret, int time,
      {int length = 6, int interval = 30, Algorithm algorithm = Algorithm.SHA256}) {
    time = (((time ~/ 1000).round()) ~/ interval).floor();
    return _generateCode(secret, time, length, getAlgorithm(algorithm));
  }

  /// Generates a Time-based one time password code and return as a 0 padded string.
  ///
  /// Takes current time in milliseconds, converts to seconds and devides it by interval to get a code every iteration of the interval.
  /// A interval of 1 will be the same as if passing time into the HOTPCode function..
  ///
  /// Optional parameters to change the length of the code provided (default 6), interval (default 30), and hashing algorithm (default SHA1)
  /// These settings are defaulted to the RFC standard but can be changed.
  static String generateTOTPCodeString(String secret, int time,
      {int length = 6, int interval = 30, Algorithm algorithm = Algorithm.SHA256}) {
    String code = "${generateTOTPCode(secret, time, length: length, interval: interval, algorithm: algorithm)}";
    return code.padLeft(length, '0');
  }

  /// Generates a one time password code based on a counter you provide and increment.
  ///
  /// This function does not increment for you.
  /// Optional parameters to change the length of the code provided (default 6) and hashing algorithm (default SHA1)
  /// These settings are defaulted to the RFC standard but can be changed.
  static int generateHOTPCode(String secret, int counter, {int length = 6, Algorithm algorithm = Algorithm.SHA256}) {
    return _generateCode(secret, counter, length, getAlgorithm(algorithm));
  }

  /// Generates a one time password code based on a counter you provide and increment, returns as a 0 padded string.
  ///
  /// This function does not increment for you.
  /// Optional parameters to change the length of the code provided (default 6) and hashing algorithm (default SHA1)
  /// These settings are defaulted to the RFC standard but can be changed.
  static String generateHOTPCodeString(String secret, int counter,
      {int length = 6, Algorithm algorithm = Algorithm.SHA256}) {
    String code = "${generateHOTPCode(secret, counter, length: length, algorithm: algorithm)}";
    return code.padLeft(length, '0');
  }

  static int _generateCode(String secret, int time, int length, Hash mac) {
    length = (length > 0) ? length : 6;

    var secretList = base32.decode(secret);
    var timebytes = _int2bytes(time);

    var hmac = Hmac(mac, secretList);
    var digest = hmac.convert(timebytes).bytes;

    int offset = digest[digest.length - 1] & 0xf;

    int binary = ((digest[offset] & 0x7f) << 24) |
        ((digest[offset + 1] & 0xff) << 16) |
        ((digest[offset + 2] & 0xff) << 8) |
        (digest[offset + 3] & 0xff);

    return binary % pow(10, length);
  }

  /// Allows you to compare 2 codes in constant time, to mitigate timing attacks for secure codes.
  ///
  /// This function takes 2 codes in string format.
  static bool constantTimeVerification(final String code, final String othercode) {
    if (code.length != othercode.length) {
      return false;
    }

    var result = true;
    for (var i = 0; i < code.length; i++) {
      // Keep result at the end otherwise Dart VM will shortcircuit on a result thats already false.
      result = (code[i] == othercode[i]) && result;
    }
    return result;
  }

  /// Generates a cryptographically secure random secret in base32 string format.
  static String randomSecret() {
    var rand = Random.secure();
    var bytes = <int>[];

    for (var i = 0; i < 10; i++) {
      bytes.add(rand.nextInt(256));
    }

    return base32.encode(Uint8List.fromList(bytes));
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
  static Hash getAlgorithm(Algorithm algorithm) {
    switch (algorithm) {
      case Algorithm.SHA224:
        return sha224;
      case Algorithm.SHA256:
        return sha256;
      case Algorithm.SHA384:
        return sha384;
      case Algorithm.SHA512:
        return sha512;
      case Algorithm.SHA1:
        return sha1;
      default:
        return sha256;
    }
  }
}

enum Algorithm { SHA1, SHA224, SHA256, SHA384, SHA512 }
