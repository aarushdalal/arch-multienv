# arch-multienv 1.3.2

Fix logout and desktop-switch failure on Hyprland Lua sessions. Detect the actual Lua dispatch API and use `hl.dsp.window.close({ window = ... })`; retain legacy commands for older compositors. Standalone exit uses the matching API, while owned UWSM sessions keep their normal teardown. Strict hexadecimal address validation preserves exact targeting, and a window disappearing during closure no longer cancels logout.

Validated against the installed compositor’s real parser and an agent-owned disposable test window, with final session termination intercepted. Backend regressions cover Lua commands and legacy behavior. Both panels use the corrected shared helper; no user window or actual session was terminated by validation. Current payload privacy scan passed; existing public history is preserved.
