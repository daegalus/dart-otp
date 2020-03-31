import 'package:otp/otp.dart';

void main() {
  var code = OTP.generateTOTPCodeString('JBSWY3DPEHPK3PXP', DateTime.now().millisecondsSinceEpoch);
  print(code);

  var code2 = OTP.generateTOTPCodeString('JBSWY3DPEHPK3PXP', DateTime.now().millisecondsSinceEpoch, interval: 10);
  print(code2);

  var code3 = OTP.generateTOTPCodeString('JBSWY3DPEHPK3PXP', DateTime.now().millisecondsSinceEpoch, interval: 20, algorithm: Algorithm.SHA512);
  print(code3);

  var code4 = OTP.generateHOTPCodeString('OBRWE5CEFNFWQQJRMZRGM4LZMZIGKKZU', 1);
  print(code4);

  var code5 = OTP.generateTOTPCodeString('JBSWY3DPEHPK3PXP', 1362302550000);
  print(code5);
}
