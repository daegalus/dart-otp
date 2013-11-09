[![](https://drone.io/github.com/daegalus/dart-otp/status.png)](https://drone.io/github.com/daegalus/dart-otp/latest)

# dart-otp

RFC6238 Time-Based One-Time Password / Google Authenticator Library

Features:

* Generate TOTP and HOTP codes.
* [Annotated source code](http://daegalus.github.com/annotated/dart-otp/otp/otp.html)

## Getting Started

### Pubspec

pub.dartlang.org: (you can use 'any' instead of a version if you just want the latest always)
```yaml
dependencies:
  otp: 0.1.0
```

```dart
#import('package:otp/otp.dart');
```

Start encoding/decoding ...

```dart
// Generate TOTP code.
OTP.generateTOTPCode("JBSWY3DPEHPK3PXP", 1362302550000); // -> 238158

// base32 decoding to original string.
OTP.generateHOTPCode("JBSWY3DPEHPK3PXP", 7); // -> 449891
```

## API

### OTP.generateTOTPCode(String secret, int currentTime, {int length: 6})

Generate a code for the provided secret and time.

* `secret` - (String) A Base32 String.
* `currentTime` - (int) The current time in milliseconds.
* `length` - (int) the length of the resulting code. Either 6 or 8.

Returns an `int` code.

### OTP.generateHOTPCode(String secret, int counter, {int length: 6})

Generate a code for the provided secret and time.

* `secret` - (String) A Base32 String.
* `counter` - (int) An int counter.
* `length` - (int) the length of the resulting code. Either 6 or 8.

Returns an `int` code.

## Testing

In dartvm

```
dart test\otp_test.dart
```

In Browser

N/A

## Release notes
v0.1.0
- Dart 1.0 Readiness

v0.0.4
- Fixing crypto library.

v0.0.3
- Fixing language changes.

v0.0.2
- No functionality changes, just fixing a bad file state it git and in the package involving the case of the file.

v0.0.1
- Initial Documented Release
