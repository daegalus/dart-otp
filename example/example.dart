import "package:otp/otp.dart";

main() {
  var code = OTP.generateTOTPCode(
      "JBSWY3DPEHPK3PXP", DateTime.now().millisecondsSinceEpoch);
  print(code);
}
