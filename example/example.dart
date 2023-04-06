import 'package:otp/otp.dart';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

void main() {
  final now = DateTime.now();
  timezone.initializeTimeZones();

  final pacificTimeZone = timezone.getLocation('America/Los_Angeles');
  final date = timezone.TZDateTime.from(now, pacificTimeZone);

  final code = OTP.generateTOTPCodeString(
      'JBSWY3DPEHPK3PXP', date.millisecondsSinceEpoch,
      algorithm: Algorithm.SHA1, isGoogle: true);
  print(code);

  final code2 = OTP.generateTOTPCodeString(
      'JBSWY3DPEHPK3PXP', DateTime.now().millisecondsSinceEpoch,
      interval: 10);
  print(code2);

  final code3 = OTP.generateTOTPCodeString(
      'JBSWY3DPEHPK3PXP', DateTime.now().millisecondsSinceEpoch,
      interval: 20, algorithm: Algorithm.SHA512);
  print(code3);

  final code4 =
      OTP.generateHOTPCodeString('OBRWE5CEFNFWQQJRMZRGM4LZMZIGKKZU', 1);
  print(code4);

  final code5 = OTP.generateTOTPCodeString('JBSWY3DPEHPK3PXP', 1362302550000);
  print(code5);

  final code6 = OTP.generateTOTPCodeString(
      'JBSWY3DPEHPK3PXP', DateTime.now().millisecondsSinceEpoch,
      interval: 60);
  print(code6);
  print(OTP.remainingSeconds(interval: 60));

  final code7 = OTP.generateTOTPCodeString(
      'JBSWY3DPEHPK3PXP', DateTime.now().millisecondsSinceEpoch);
  print(code7);
  print(OTP.remainingSeconds());

  final code8 = OTP.generateTOTPCodeString('TULF5VNGGE267KF7BVZ3FGWBB7TELLIL',
      DateTime.now().millisecondsSinceEpoch);
  print(code8);
  print(OTP.remainingSeconds());

  final code9 = OTP.generateTOTPCodeString(
      'sdfsdf', DateTime.now().millisecondsSinceEpoch,
      algorithm: Algorithm.SHA1); // This should throw an exception.
  print(code9);
}
