# Changelog

## v3.1.1

- Loosen version constraint on the `crypto` so that there is no conflict between our library and those requiring 3.0.1 or 3.0.0. `crypto` versions 3.0.1 and 3.0.2 don't affect this library or are just doc/link fixes.
  
## v3.1.0

- Bug where all secrets were being treated as Base32 by default, when RFC default is ASCII. Base32 is only when using Google Authenticator mode. This came about due to even when not using Google, secrets were Base32 encoded anyway by most implementations, so the bug wasn't caught, including my tests where I pre-encoded everything as Base32. (thanks @pt-rick for catching this.)
  - Used `notp` and `otplib` to verify my outputs.

## v3.0.4

- Partially change behavior, if it is invalid Base32, it should throw, but in certain cases, it still doesn't throw, so we do fallback behavior.
  
## v3.0.3

- Fix when secrets are not Base32 causing infinite loops because the resulting list is size 0.
- Don't assume Base32, use the secret as is if not base32.
  
## v3.0.2

- Add `remainingSeconds()` in order to calculate the remaining seconds based on `lastUsedTime`. (thanks @AkbarAsghari)
  
## v3.0.1

- Add `lastUsedTime` and `lastUsedCounter` to provide additional information for users and potential debugging points.

## v3.0.0

- Docs and file cleanup
  
## v3.0.0-nullsafety.0

- Nullsafety conversion

## v2.2.3

- Improve pub package score (thanks @DavBfr)
- Use const and final instead of var (thanks @DavBfr)
- Document public API members (thanks @DavBfr)

## v2.2.2

- Update quick_log to latest version

## v2.2.1

- Correctly use Google Auth flag (`isGoogle`) to disable padding. (thanks hpoul)

## v2.2.0

- Add Google Auth flag, because they do SHA1 TOTP without Padding the secret.
- Reverting _int2bytes function back to old implementation, as the new on uses int64 which breaks flutter web and dart2js as it doesn't have support for Int64.

## v2.1.0

- Fix secret paddding to follow proper TOTP secret padding and sizing for SHA256, SHA512
- Remove RFC unsupported hashes. SHA224 and SHA384 are no longer supported.
- Show warning when using anything other than SHA1, as the RFC doesn't support it so I have found that libraries don't pad correctly for HOTP.
- At the same time, SHA1 is now again the HOTP default.
- Add optional TOTP style paddding for HOTP when using SHA256 and SHA512.
- Force version 1.1.1 of Base32 library, as that was a major bug fix release that improved Base32 support.
- Add documentation and additional information on how to use this library.

## v2.0.3

- Fix type error at runtime for RandomSecret generation. MR #14 (thanks readytopark)

## v2.0.2

- Switch to crypto lib inplace of PointyCastle for HMAC

## v2.0.1, ## v2.0.0

- Formatting
- No changes from rc1, accepting the 1-3 second timing difference between constant time code checks until someone can help me figure out how to make it match.

## v2.0.0-rc1

- *BREAKING CHANGE* Switched default hashing algorithm to SHA256 from SHA1
- Add constant time verification function to avoid timing attacks on code comparison.
- Add String return variant of code generation.

## v1.0.3

- Switched to PointyCastle for crypto and support for more than SHA1 hashing for tokens (amadejkastelic)

## v1.0.2

- Add new TOTP interval parameters (optional)

## v1.0.1

- Cleanup and remove dead code

## v1.0.0

- Dart 2.0 updates

## v0.1.0

- Dart 1.0 Readiness

## v0.0.4

- Fixing crypto library.

## v0.0.3

- Fixing language changes.

## v0.0.2

- No functionality changes, just fixing a bad file state it git and in the package involving the case of the file.

## v0.0.1

- Initial Documented Release
