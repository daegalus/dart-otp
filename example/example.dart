import 'package:otp/otp.dart';

void main() {
  final code = OTP.generateTOTPCodeString(
      'JBSWY3DPEHPK3PXP', DateTime.now().millisecondsSinceEpoch);
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
}
