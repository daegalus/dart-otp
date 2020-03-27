import "package:otp/otp.dart";

main() {
  var code = OTP.generateTOTPCode("JBSWY3DPEHPK3PXP", DateTime.now().millisecondsSinceEpoch);
  print(code);

  var code2 = OTP.generateTOTPCode("JBSWY3DPEHPK3PXP", DateTime.now().millisecondsSinceEpoch, interval: 10);
  print(code2);

  var code3 = OTP.generateTOTPCode("JBSWY3DPEHPK3PXP", DateTime.now().millisecondsSinceEpoch, interval: 20, algorithm: Algorithm.SHA256);
  print(code3);

  var code4 = OTP.generateHOTPCode("OBRWE5CEFNFWQQJRMZRGM4LZMZIGKKZU", 1, algorithm: Algorithm.SHA256);
  print(code4);
}
