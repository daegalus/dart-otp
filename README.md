[![Build Status](https://travis-ci.org/Daegalus/dart-otp.svg?branch=master)](https://travis-ci.org/Daegalus/dart-otp)

# dart-otp

RFC6238 Time-Based One-Time Password / Google Authenticator Library

Features:

- Generate TOTP and HOTP codes.
- [Annotated source code](http://daegalus.github.com/annotated/dart-otp/otp/otp.html)

## Getting Started

### Pubspec

pub.dartlang.org: (you can use 'any' instead of a version if you just want the latest always)

```yaml
dependencies:
  otp: 1.0.3
```

```dart
import 'package:otp/otp.dart';
```

Start generating tokens.

```dart
// Generate TOTP code.
OTP.generateTOTPCode("JBSWY3DPEHPK3PXP", 1362302550000); // -> 238158

// base32 decoding to original string.
OTP.generateHOTPCode("JBSWY3DPEHPK3PXP", 7); // -> 449891
```

## API

### OTP.generateTOTPCode(String secret, int currentTime, {int length: 6, int interval: 30, Algorithm algorithm: Algorithm.SHA1})

Generate a code for the provided secret and time.

- `secret` - (String) A Base32 String.
- `currentTime` - (int) The current time in milliseconds.
- `length` - (int) The length of the resulting code.
- `interval` - (int) Refresh interval to get a new code.
- `algorithm` - (Algorithm) Hashing method.

Returns an `int` code.

### OTP.generateHOTPCode(String secret, int counter, {int length: 6})

Generate a code for the provided secret and time.

- `secret` - (String) A Base32 String.
- `counter` - (int) An int counter.
- `length` - (int) the length of the resulting code.

Returns an `int` code.

## Testing

```
pub run test
```

## Release notes

See CHANGELOG.md
