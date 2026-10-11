# Switching and session lifecycle

`multienv switch ID --dry-run --no-prompt` validates the chosen profile and
shows the intended next-session configuration. A real switch uses a serialized
atomic write with a timestamped preimage. `--now` explicitly requests logout.

Logout requests closure of exact window addresses on the selected compositor,
then waits up to eight seconds. Remaining windows keep the session alive and
return exit code 2. Save or close them and retry. `--force` is an explicit
override. There is no detached shutdown watchdog or broad process-name killing.
An optional configured teardown hook runs after window closure. UWSM is stopped
only when it owns the selected compositor; otherwise that compositor exits.

The launcher treats expanded paths as argument data, rejects missing or invalid
profiles, and preserves compositor failure status. Autostart hooks run after a
new matching Hyprland instance becomes ready. Do not mask failures with an
EXIT trap. Inspect the SDDM journal and repair the failing launch instead.

`multienv fallback` disables autologin with a recovery copy and restores manual
greeter selection. It does not log out unless `--now` is supplied. Existing
desktop sessions remain available.

Full authentication, hardware seat release and profile switching must be
verified interactively on each target host. Automated stubs cannot prove those
host-specific behaviors.
