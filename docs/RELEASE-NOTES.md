# arch-multienv 1.3.1

Fix the login screen falling back to SDDM's default theme. The theme now declares `QtVersion=6`, ensuring SDDM launches its Qt 6 greeter for the existing Qt 6 QML. The floating design and session behavior are preserved.

Validation: metadata regression, the six backend regressions, native greeter fixtures, and the actual `sddm-greeter-qt6 --test-mode` theme load. No display-manager restart or active-session termination was performed. Existing public history is preserved and new commits/tags use GitHub noreply metadata.
