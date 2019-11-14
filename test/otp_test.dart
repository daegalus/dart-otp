import "package:test/test.dart";
import 'package:otp/otp.dart';

main() {
  final int HALFMINUTES = 45410085;
  final int SECONDS = HALFMINUTES * 30;
  final int TIME = SECONDS * 1000;

  group('[Code Gen Test]', () {
    test('Generated code for Sun Mar 03 09:22:30 2013 +0000 using default algorithm and length', () {
      var code = OTP.generateTOTPCode("JBSWY3DPEHPK3PXP", TIME);
      expect(code, equals(182937));
    });

    test('Generated code for Sun Mar 03 09:22:30 2013 +0000 using default algorithm and length of 7', () {
      var code = OTP.generateTOTPCode("JBSWY3DPEHPK3PXP", TIME + 30000,
          length:
              7); // Need to adjust by 30 seconds, as the original code only had 6 digits and would normally be padded with 0s
      expect(code, equals(7525308));
    });

    test('Generated code for counter 7', () {
      var code = OTP.generateHOTPCode("JBSWY3DPEHPK3PXP", 7);
      expect(code, equals(346239));
    });

    test('Generated code for counter 7 using SHA1 (old default)', () {
      var code = OTP.generateHOTPCode("JBSWY3DPEHPK3PXP", 7, algorithm: Algorithm.SHA1);
      expect(code, equals(449891));
    });

    test('Generated code for Sun Mar 03 09:22:30 2013 +0000 using SHA1 (old default)', () {
      var code = OTP.generateTOTPCode("JBSWY3DPEHPK3PXP", TIME, algorithm: Algorithm.SHA1);
      expect(code, equals(238158));
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

    test('Generated code for Sun Mar 03 09:22:30 2013 +0000 as String', () {
      var code = OTP.generateTOTPCodeString("JBSWY3DPEHPK3PXP", TIME);
      expect(code, equals("182937"));
    });
    test('Verify comparison works', () {
      var code = OTP.generateTOTPCodeString("JBSWY3DPEHPK3PXP", TIME);
      var othercode = OTP.generateTOTPCodeString("JBSWY3DPEHPK3PXP", TIME);

      expect(OTP.constantTimeVerification(code, othercode), equals(true));
    });

    test('Verify comparison timing', () {
      var code = OTP.generateTOTPCodeString("JBSWY3DPEHPK3PXZ", TIME);
      var othercode = OTP.generateTOTPCodeString("JBSWY3DPEHPK3PXZ", TIME + 30000);
      var othercodeSame = "${OTP.generateTOTPCodeString("JBSWY3DPEHPK3PXZ", TIME)}";
      var w = Stopwatch();
      // cache stopwatch functions to avoid affecting timing.
      w.start();
      w.stop();
      w.reset();

      w.start();
      var resultDifferent = OTP.constantTimeVerification(code, othercode);
      w.stop();
      var diff1 = w.elapsedMicroseconds;
      w.reset();
      w.start();
      var resultSame = OTP.constantTimeVerification(code, othercodeSame);
      w.stop();
      var diff2 = w.elapsedMicroseconds;

      print("resultDifferent: $diff1");
      print("resultSame: $diff2");
      expect(resultSame, equals(true));
      expect(resultDifferent, equals(false));
      expect((diff1 - diff2).abs() < 5, equals(true)); // allow for margin of error of 5 microseconds.
    });
  });
}
