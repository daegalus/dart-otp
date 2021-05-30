import 'package:test/test.dart';
import 'package:otp/otp.dart';
import 'package:base32/base32.dart';

void main() {
  const HALFMINUTES = 45410085;
  const SECONDS = HALFMINUTES * 30;
  const TIME = SECONDS * 1000;

  group('[Code Gen Test]', () {
    test(
        'Generated code for Sun Mar 03 09:22:30 2013 +0000 using default algorithm and length',
        () {
      final code = OTP.generateTOTPCode('JBSWY3DPEHPK3PXP', TIME);
      expect(code, equals(637305));
    });

    test(
        'Generated code for Sun Mar 03 09:22:30 2013 +0000 using default algorithm and length of 7',
        () {
      final code = OTP.generateTOTPCode('JBSWY3DPEHPK3PXP', TIME + 30000,
          length:
              7); // Need to adjust by 30 seconds, as the original code only had 6 digits and would normally be padded with 0s
      expect(code, equals(1203843));
    });

    test('Generated code for counter 7 using SHA256', () {
      final code = OTP.generateHOTPCode('JBSWY3DPEHPK3PXP', 7,
          algorithm: Algorithm.SHA256);
      expect(code, equals(346239));
    });

    test('Generated code for counter 7 using SHA1', () {
      final code = OTP.generateHOTPCode('JBSWY3DPEHPK3PXP', 7);
      expect(code, equals(449891));
    });

    test('Verify isGoogle is passed along to disable padding', () {
      final code = OTP.generateTOTPCodeString(
        'Q4D65VKZ3T5NERSB',
        1589633445440,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );
      expect(code, equals('700998'));
    });

    test(
        'Generated code for Sun Mar 03 09:22:30 2013 +0000 using SHA1 (old default)',
        () {
      final code = OTP.generateTOTPCode('JBSWY3DPEHPK3PXP', TIME,
          algorithm: Algorithm.SHA1);
      expect(code, equals(345785));
    });

    test('Generated code for Sun Mar 03 09:22:30 2013 +0000 using SHA256', () {
      final code = OTP.generateTOTPCode('JBSWY3DPEHPK3PXP', TIME,
          algorithm: Algorithm.SHA256);
      expect(code, equals(637305));
    });

    test('Generated code for Sun Mar 03 09:22:30 2013 +0000 using SHA512', () {
      final code = OTP.generateTOTPCode('JBSWY3DPEHPK3PXP', TIME,
          algorithm: Algorithm.SHA512);
      expect(code, equals(402314));
    });

    test('Generated code for Sun Mar 03 09:22:30 2013 +0000 as String', () {
      final code = OTP.generateTOTPCodeString('JBSWY3DPEHPK3PXP', TIME);
      expect(code, equals('637305'));
    });

    test('Verify that padding flag for HOTP works.', () {
      final code = OTP.generateTOTPCodeString('JBSWY3DPEHPK3PXP', 0);

      final hcode = OTP.generateHOTPCodeString('JBSWY3DPEHPK3PXP', 0,
          algorithm: Algorithm.SHA256);
      OTP.useTOTPPaddingForHOTP = true;
      final hcodeP = OTP.generateHOTPCodeString('JBSWY3DPEHPK3PXP', 0,
          algorithm: Algorithm.SHA256);
      OTP.useTOTPPaddingForHOTP = false;
      expect(code, equals(hcodeP), reason: 'TOTP eq HOTP');
      expect(code, isNot(equals(hcode)), reason: 'TOTP neq HOTP');
    });

    test('Verify comparison works', () {
      final code = OTP.generateTOTPCodeString('JBSWY3DPEHPK3PXP', TIME);
      final othercode = OTP.generateTOTPCodeString('JBSWY3DPEHPK3PXP', TIME);

      expect(OTP.constantTimeVerification(code, othercode), equals(true));
    });

    test(
        'Generate a cryptographically secure random secret in base32 string format',
        () {
      final secret = OTP.randomSecret();
      assert(secret.isNotEmpty);
    });

    test('Verify comparison timing', () {
      final code = OTP.generateTOTPCodeString('JBSWY3DPEHPK3PXZ', TIME);
      final othercode =
          OTP.generateTOTPCodeString('JBSWY3DPEHPK3PXZ', TIME + 30000);
      final othercodeSame =
          "${OTP.generateTOTPCodeString('JBSWY3DPEHPK3PXZ', TIME)}";
      final w = Stopwatch();
      // cache stopwatch functions to avoid affecting timing.
      w.start();
      w.stop();
      w.reset();

      w.start();
      final resultDifferent = OTP.constantTimeVerification(code, othercode);
      w.stop();
      final diff1 = w.elapsedMicroseconds;
      w.reset();
      w.start();
      final resultSame = OTP.constantTimeVerification(code, othercodeSame);
      w.stop();
      final diff2 = w.elapsedMicroseconds;

      print('resultDifferent: $diff1');
      print('resultSame: $diff2');
      expect(resultSame, equals(true));
      expect(resultDifferent, equals(false));
      expect((diff1 - diff2).abs() < 5,
          equals(true)); // allow for margin of error of 5 microseconds.
    });
  });

  group('[RFC4226 Dataset Test - Secret: 12345678901234567890]', () {
    const digests = [
      'cc93cf18508d94934c64b65d8ba7667fb7cde4b0',
      '75a48a19d4cbe100644e8ac1397eea747a2d33ab',
      '0bacb7fa082fef30782211938bc1c5e70416ff44',
      '66c28227d03a2d5529262ff016a1e6ef76557ece',
      'a904c900a64b35909874b33e61c5938a8e15ed1c',
      'a37e783d7b7233c083d4f62926c7a25f238d0316',
      'bc9cd28561042c83f219324d3c607256c03272ae',
      'a4fb960c0bc06e1eabb804e5b397cdc4b45596fa',
      '1b3c89f65e6c9e883012052823443f048b4332db',
      '1637409809a679dc698207310c8c7fc07290d9e5'
    ];

    const tokens = [
      '755224',
      '287082',
      '359152',
      '969429',
      '338314',
      '254676',
      '287922',
      '162583',
      '399871',
      '520489'
    ];

    for (var i = 0; i < digests.length; i++) {
      const secret = '12345678901234567890';
      final secretEncoded = base32.encodeString(secret);
      final digest = digests[i];
      final token = tokens[i];

      test('Counter: $i | Token $token | Digest $digest', () {
        final code = OTP.generateHOTPCodeString(secretEncoded, i,
            algorithm: Algorithm.SHA1);
        final internal = OTP.getInternalDigest(
            secretEncoded, i, 6, OTP.getAlgorithm(Algorithm.SHA1));
        expect(internal, equals(digest));
        expect(code, equals(token));
      });
    }
  });

  group('[RFC6238 Dataset Test - Secret: 12345678901234567890]', () {
    const dataset = [
      {
        'epoch': 59,
        'counter': '0000000000000001',
        'token': '94287082',
        'algorithm': Algorithm.SHA1
      },
      {
        'epoch': 59,
        'counter': '0000000000000001',
        'token': '46119246',
        'algorithm': Algorithm.SHA256
      },
      {
        'epoch': 59,
        'counter': '0000000000000001',
        'token': '90693936',
        'algorithm': Algorithm.SHA512
      },
      {
        'epoch': 1111111109,
        'counter': '00000000023523EC',
        'token': '07081804',
        'algorithm': Algorithm.SHA1
      },
      {
        'epoch': 1111111109,
        'counter': '00000000023523EC',
        'token': '68084774',
        'algorithm': Algorithm.SHA256
      },
      {
        'epoch': 1111111109,
        'counter': '00000000023523EC',
        'token': '25091201',
        'algorithm': Algorithm.SHA512
      },
      {
        'epoch': 1111111111,
        'counter': '00000000023523ED',
        'token': '14050471',
        'algorithm': Algorithm.SHA1
      },
      {
        'epoch': 1111111111,
        'counter': '00000000023523ED',
        'token': '67062674',
        'algorithm': Algorithm.SHA256
      },
      {
        'epoch': 1111111111,
        'counter': '00000000023523ED',
        'token': '99943326',
        'algorithm': Algorithm.SHA512
      },
      {
        'epoch': 1234567890,
        'counter': '000000000273EF07',
        'token': '89005924',
        'algorithm': Algorithm.SHA1
      },
      {
        'epoch': 1234567890,
        'counter': '000000000273EF07',
        'token': '91819424',
        'algorithm': Algorithm.SHA256
      },
      {
        'epoch': 1234567890,
        'counter': '000000000273EF07',
        'token': '93441116',
        'algorithm': Algorithm.SHA512
      },
      {
        'epoch': 2000000000,
        'counter': '0000000003F940AA',
        'token': '69279037',
        'algorithm': Algorithm.SHA1
      },
      {
        'epoch': 2000000000,
        'counter': '0000000003F940AA',
        'token': '90698825',
        'algorithm': Algorithm.SHA256
      },
      {
        'epoch': 2000000000,
        'counter': '0000000003F940AA',
        'token': '38618901',
        'algorithm': Algorithm.SHA512
      },
      {
        'epoch': 20000000000,
        'counter': '0000000027BC86AA',
        'token': '65353130',
        'algorithm': Algorithm.SHA1
      },
      {
        'epoch': 20000000000,
        'counter': '0000000027BC86AA',
        'token': '77737706',
        'algorithm': Algorithm.SHA256
      },
      {
        'epoch': 20000000000,
        'counter': '0000000027BC86AA',
        'token': '47863826',
        'algorithm': Algorithm.SHA512
      }
    ];

    for (var i = 0; i < dataset.length; i++) {
      const secret = '12345678901234567890';
      final epoch = dataset[i]['epoch'] as int;
      final counter = int.parse(dataset[i]['counter'] as String, radix: 16);
      final token = dataset[i]['token'];
      final algorithm = dataset[i]['algorithm'] as Algorithm;

      test(
          'Epoch: $epoch | Counter: $counter | Token: $token | Algorithm: $algorithm',
          () {
        final secretEncoded = base32.encodeString(secret);

        final time = epoch * 1000;

        final code = OTP.generateTOTPCodeString(secretEncoded, time,
            algorithm: algorithm, length: 8);

        //OTP.useTOTPPaddingForHOTP = true;
        //var hcode = OTP.generateHOTPCodeString(secretEncoded, counter, algorithm: algorithm, length: 8);
        //OTP.useTOTPPaddingForHOTP = false;
        //expect(code, equals(hcode), reason: 'TOTP eq HOTP');
        //expect(hcode, equals(token), reason: 'HOTP eq rfc dataset');
        expect(code, equals(token), reason: 'TOTP eq rfc dataset');
      });
    }
  });
}
