# Changelog

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
