# Changelog

v2.2.3
- Improve pub package score
- Use const and final instead of var
- Document public API members

v2.2.2
- Update quick_log to latest version

v2.2.1
- Correctly use Google Auth flag (`isGoogle`) to disable padding. (thanks hpoul)

v2.2.0
- Add Google Auth flag, because they do SHA1 TOTP without Padding the secret.
- Reverting _int2bytes function back to old implementation, as the new on uses int64 which breaks flutter web and dart2js as it doesn't have support for Int64.

v2.1.0
- Fix secret paddding to follow proper TOTP secret padding and sizing for SHA256, SHA512
- Remove RFC unsupported hashes. SHA224 and SHA384 are no longer supported.
- Show warning when using anything other than SHA1, as the RFC doesn't support it so I have found that libraries don't pad correctly for HOTP.
- At the same time, SHA1 is now again the HOTP default.
- Add optional TOTP style paddding for HOTP when using SHA256 and SHA512.
- Force version 1.1.1 of Base32 library, as that was a major bug fix release that improved Base32 support.
- Add documentation and additional information on how to use this library.

v2.0.3

- Fix type error at runtime for RandomSecret generation. MR #14 (thanks readytopark)

v2.0.2

- Switch to crypto lib inplace of PointyCastle for HMAC

v2.0.1, v2.0.0

- Formatting
- No changes from rc1, accepting the 1-3 second timing difference between constant time code checks until someone can help me figure out how to make it match.

v2.0.0-rc1

- *BREAKING CHANGE* Switched default hashing algorithm to SHA256 from SHA1
- Add constant time verification function to avoid timing attacks on code comparison.
- Add String return variant of code generation.

v1.0.3

- Switched to PointyCastle for crypto and support for more than SHA1 hashing for tokens (amadejkastelic)

v1.0.2

- Add new TOTP interval parameters (optional)

v1.0.1

- Cleanup and remove dead code

v1.0.0

- Dart 2.0 updates

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
