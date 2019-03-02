import "package:test/test.dart";
import 'package:otp/otp.dart';

main() {
  final int HALFMINUTES = 45410085;
  final int SECONDS = HALFMINUTES*30;
  final int TIME = SECONDS*1000;

  group('[Code Gen Test]', () {
    test('Generated code for Sun Mar 03 09:22:30 2013 +0000', () {
      var code = OTP.generateTOTPCode("JBSWY3DPEHPK3PXP", TIME);
      expect(code, equals(238158));
    });

    test('Generated code for counter 7', () {
      var code = OTP.generateHOTPCode("JBSWY3DPEHPK3PXP", 7);
      expect(code, equals(449891));
    });

    test('Generated code for Sun Mar 03 09:22:30 2013 +0000 using SHA224', () {
      var code = OTP.generateTOTPCode("JBSWY3DPEHPK3PXP", TIME, algorithm: Algorithm.SHA224);
      expect(code, equals(237228));
    });

    test('Generated code for Sun Mar 03 09:22:30 2013 +0000 using SHA256', () {
      var code = OTP.generateTOTPCode("JBSWY3DPEHPK3PXP", TIME, algorithm: Algorithm.SHA256);
      expect(code, equals(182937));
    });

    test('Generated code for Sun Mar 03 09:22:30 2013 +0000 using SHA384', () {
      var code = OTP.generateTOTPCode("JBSWY3DPEHPK3PXP", TIME, algorithm: Algorithm.SHA384);
      expect(code, equals(476758));
    });

    test('Generated code for Sun Mar 03 09:22:30 2013 +0000 using SHA512', () {
      var code = OTP.generateTOTPCode("JBSWY3DPEHPK3PXP", TIME, algorithm: Algorithm.SHA512);
      expect(code, equals(908378));
    });
  });
}


