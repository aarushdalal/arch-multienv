# arch-multienv 1.3.0

A responsive floating SDDM chooser exposes the full installed session list and retains selection, duplicate-login protection and visible authentication failures. Theme-owned motion supports 19 styles, intensity and reduced motion.

Logout requests exact window closure and pauses for remaining windows. Force is explicit; returning to the greeter does not change autologin policy. Session wrappers preserve launch failures, and the installer records exact preimages and ownership for conservative removal. No PAM, USB or vendor theme changes are installed.

Validation: five backend regressions, the existing script suite, isolated install/update/removal, and native Qt greeter fixtures passed. Run `/usr/lib/qt6/bin/qml tests/qml/GreeterTests.qml` in a graphical Qt 6 session and check for `GREETER_TEST_OK`; it uses simulated authentication and inert power actions. Actual password/fingerprint authentication and a full logout/login switch remain interactive checks.

Current files passed the release privacy guard. The preview uses sample data. New commits use a GitHub noreply address; existing public history is preserved.
