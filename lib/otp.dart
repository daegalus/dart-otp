library otp;

import 'dart:math';
import 'dart:typed_data';
import 'package:base32/base32.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:quick_log/quick_log.dart';

class OTP {
  /// Used to enable TOTP style padding of the secret for SHA256 and SHA512 usage with HOTP. False by default.
  static bool useTOTPPaddingForHOTP = false;

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
      Algorithm algorithm = Algorithm.SHA256,
      bool isGoogle = false}) {
    time = (((time ~/ 1000).round()) ~/ interval).floor();
    return _generateCode(secret, time, length, getAlgorithm(algorithm),
        _getAlgorithmByteLength(algorithm), isGoogle: isGoogle);
  }

  /// Generates a Time-based one time password code and return as a 0 padded string.
  ///
  /// Takes current time in milliseconds, converts to seconds and devides it by interval to get a code every iteration of the interval.
  /// A interval of 1 will be the same as if passing time into the HOTPCode function..
  ///
  /// Optional parameters to change the length of the code provided (default 6), interval (default 30), and hashing algorithm (default SHA1)
  /// These settings are defaulted to the RFC standard but can be changed.
  static String generateTOTPCodeString(String secret, int time,
      {int length = 6,
      int interval = 30,
      Algorithm algorithm = Algorithm.SHA256,
      bool isGoogle = false}) {
    var code =
        '${generateTOTPCode(secret, time, length: length, interval: interval, algorithm: algorithm, isGoogle: isGoogle)}';
    return code.padLeft(length, '0');
  }

  /// Generates a one time password code based on a counter you provide and increment.
  ///
  /// This function does not increment for you.
  /// Optional parameters to change the length of the code provided (default 6) and hashing algorithm (default SHA1)
  /// These settings are defaulted to the RFC standard but can be changed.
  static int generateHOTPCode(String secret, int counter,
      {int length = 6, Algorithm algorithm = Algorithm.SHA1}) {
    return _generateCode(secret, counter, length, getAlgorithm(algorithm),
        _getAlgorithmByteLength(algorithm),
        isHOTP: true);
  }

  /// Generates a one time password code based on a counter you provide and increment, returns as a 0 padded string.
  ///
  /// This function does not increment for you.
  /// Optional parameters to change the length of the code provided (default 6) and hashing algorithm (default SHA1)
  /// These settings are defaulted to the RFC standard but can be changed.
  static String generateHOTPCodeString(String secret, int counter,
      {int length = 6, Algorithm algorithm = Algorithm.SHA1}) {
    var code =
        '${generateHOTPCode(secret, counter, length: length, algorithm: algorithm)}';
    return code.padLeft(length, '0');
  }

  static int _generateCode(
      String secret, int time, int length, Hash mac, int secretbytes,
      {bool isHOTP = false, bool isGoogle = false}) {
    length = (length > 0) ? length : 6;

    var secretList = base32.decode(secret);

    if (!isGoogle && (!isHOTP || useTOTPPaddingForHOTP)) {
      secretList = _padSecret(secretList, secretbytes);
    } else if (isHOTP && !isGoogle) {
      _showHOTPWarning(mac);
    }

    var timebytes = _int2bytes(time);

    var hmac = Hmac(mac, secretList);
    var digest = hmac.convert(timebytes).bytes;

    var offset = digest[digest.length - 1] & 0x0f;

    var binary = ((digest[offset] & 0x7f) << 24) |
        ((digest[offset + 1] & 0xff) << 16) |
        ((digest[offset + 2] & 0xff) << 8) |
        (digest[offset + 3] & 0xff);

    return binary % pow(10, length);
  }

  /// Mostly used for testing purposes, but this can get you the internal digest based on your settings. 
  /// No handholding for this function, so you need to know exactly what to pass in.
  static String getInternalDigest(String secret, int counter, int length, Hash mac) {
    length = (length > 0) ? length : 6;

    var secretList = base32.decode(secret);
    var timebytes = _int2bytes(counter);

    var hmac = Hmac(mac, secretList);
    var digest = hmac.convert(timebytes).bytes;

    return hex.encode(digest);
  }

  /// Allows you to compare 2 codes in constant time, to mitigate timing attacks for secure codes.
  ///
  /// This function takes 2 codes in string format.
  static bool constantTimeVerification(
      final String code, final String othercode) {
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
    
    // Cleaner implementation but breaks in dart2js/flutter web
    // return Uint8List(8)..buffer.asByteData().setInt64(0, long);
  }

  static Uint8List _padSecret(Uint8List secret, int length) {
    if (secret.length == length) return secret;

    // ignore: prefer_collection_literals
    var newList = List<int>();
    for (var i = 0; i * secret.length < length; i++) {
      newList.addAll(secret);
    }

    return Uint8List.fromList(newList.sublist(0, length));
  }

  static void _showHOTPWarning(Hash mac) {
    if (mac is Sha256 || mac is Sha512) {
      var logger = Logger('otp');
      logger.warning('Using non-SHA1 hashing with HOTP is not part of the RFC for HOTP and may cause incompatibilities between different library implementatiions. This library attempts to match behavior with other libraries as best it can.');
    }
  }

  /// Gets the Mac for the provided algorithm. Mostly used for testing, not very helpful outside of that.
  static Hash getAlgorithm(Algorithm algorithm) {
    switch (algorithm) {
      case Algorithm.SHA256:
        return sha256;
      case Algorithm.SHA512:
        return sha512;
      case Algorithm.SHA1:
        return sha1;
      default:
        return sha256;
    }
  }

  /// Gets the requried byte length for the provided algorithm.
  static int _getAlgorithmByteLength(Algorithm algorithm) {
    switch (algorithm) {
      case Algorithm.SHA256:
        return 32;
      case Algorithm.SHA512:
        return 64;
      case Algorithm.SHA1:
        return 20;
      default:
        return 32; // For SHA256
    }
  }
}

enum Algorithm { SHA1, SHA256, SHA512 }
