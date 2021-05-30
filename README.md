![Dart](https://github.com/Daegalus/dart-otp/workflows/Dart/badge.svg)

# dart-otp

RFC4226/RFC6238 One-Time Password / Google Authenticator Library

Features:

- Generate TOTP (RFC6238) and HOTP (RFC4226) codes.
- [Annotated source code](https://daegalus.github.com/dart-otp/)

## Getting Started

### Pubspec

pub.dartlang.org: (you can use 'any' instead of a version if you just want the latest always)

```yaml
dependencies:
  otp: 3.0.0
```

```dart
import 'package:otp/otp.dart';
```

Start generating tokens.

```dart
// Generate TOTP code. (String versin of function incase of leading 0)
OTP.generateTOTPCodeString("JBSWY3DPEHPK3PXP", 1362302550000); // -> '637305'

// Generate HOTP Code.
OTP.generateHOTPCodeString("JBSWY3DPEHPK3PXP", 7); // -> '346239'
```

## API

### Notes

This library does not support any other secret input other than Base32. It is what is used standard most places, and by Google Authenticator.
If your secrets are not Base32 forms, please use my Base32 library (the one I use as a dependency for this library) or any other base32 library to encode your secret before passing it into the functions. All generate functions force decode of Base32.

### Global Settings

`useTOTPPaddingForHOTP` (bool, default: false) 
Uses the TOTP padding method for handling secrets bigger or smaller than the mandatory sizes for SHA256/SHA512.
This is needed as HOTP does not have an official method of using SHA256 or SHA512 in the RFC spec and most libraries don't pad HOTP for use with SHA256 or SHA512. (examples: otplib and speakeasy from Node.js)

If you enable this, it will use the same padding as TOTP (repeating the secret to the right length) but might cause incompatibilies with other libraries. I am defaulting to no padding, as this is the predominant behavior I am finding for HOTP.

### OTP.generateTOTPCode(String secret, int currentTime, {int length: 6, int interval: 30, Algorithm algorithm: Algorithm.SHA256, bool isGoogle: false})

Generate a code for the provided secret and time.

- `secret` - (String) A Base32 String.
- `currentTime` - (int) The current time in milliseconds.
- `length` - (int) The length of the resulting code.
- `interval` - (int) Refresh interval to get a new code.
- `algorithm` - (Algorithm) Hashing method.
- `isGoogle` - (bool) flag to turn off secret padding for Google Auth.

Returns an `int` code. Does not preserve leading zeros.

### OTP.generateTOTPCodeString(String secret, int currentTime, {int length: 6, int interval: 30, Algorithm algorithm: Algorithm.SHA256, bool isGoogle: false})

Generate a code for the provided secret and time.

- `secret` - (String) A Base32 String.
- `currentTime` - (int) The current time in milliseconds.
- `length` - (int) The length of the resulting code.
- `interval` - (int) Refresh interval to get a new code.
- `algorithm` - (Algorithm) Hashing method.
- `isGoogle` - (bool) flag to turn off secret padding for Google Auth.

Returns an `String` code. Preserves leading zeros.

### OTP.generateHOTPCode(String secret, int counter, {int length: 6})

Generate a code for the provided secret and time.

- `secret` - (String) A Base32 String.
- `counter` - (int) An int counter.
- `length` - (int) the length of the resulting code.

Returns an `int` code. Does not preserve leading zeros

### OTP.generateHOTPCodeString(String secret, int counter, {int length: 6})

Generate a code for the provided secret and time.

- `secret` - (String) A Base32 String.
- `counter` - (int) An int counter.
- `length` - (int) the length of the resulting code.

Returns an `String` code. Preserves leading zeros

### OTP.constantTimeVerification(final String code, final String othercode)

*!DISCLAIMER!*
I can only get this to be within 1 millisecond between different codes and same codes.
I have yet to get them to be equal. but 1 millisecond should be an OK room for error though.

Compares 2 codes in constant time to minimize risk of timing attacks.

- `code` - (String) A Base32 String.
- `othercode` - (String) A Base32 String.

Returns an `bool` if they match or not.

## Testing

```
pub run test
```

## Release notes

See CHANGELOG.md
