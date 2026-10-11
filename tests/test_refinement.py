import configparser
import importlib.machinery
import importlib.util
import json,os,shutil,subprocess,tempfile,unittest
from pathlib import Path
from unittest.mock import patch

ROOT=Path(__file__).resolve().parents[1]
def load(name,path):
 loader=importlib.machinery.SourceFileLoader(name,str(path));spec=importlib.util.spec_from_loader(name,loader)
 module=importlib.util.module_from_spec(spec);loader.exec_module(module);return module

class RefinementTests(unittest.TestCase):
 def test_theme_selects_qt6_greeter(self):
  metadata=configparser.ConfigParser()
  metadata.read(ROOT/'sddm/themes/multienv-selector/metadata.desktop')
  # SDDM defaults to its Qt 5 binary without this field, then falls back.
  self.assertEqual(metadata['SddmGreeterTheme'].get('QtVersion'),'6')
  self.assertEqual(metadata['SddmGreeterTheme'].get('MainScript'),'Main.qml')

 def test_greeter_switch_does_not_change_autologin(self):
  with tempfile.TemporaryDirectory() as folder:
   root=Path(folder);config=root/'config/multienv';config.mkdir(parents=True)
   autologin=root/'autologin.conf';autologin.write_text('[Autologin]\nUser=sample\nSession=sample.desktop\n')
   (config/'multienv.toml').write_text('[general]\nsddm_autologin_path='+json.dumps(str(autologin))+'\n')
   env=dict(os.environ,HOME=folder,XDG_CONFIG_HOME=str(root/'config'))
   result=subprocess.run([ROOT/'bin/multienv-logout','--greeter','--dry-run'],env=env,capture_output=True)
   self.assertEqual(result.returncode,3)
   self.assertIn('User=sample',autologin.read_text())

 def test_installer_owns_only_recorded_unchanged_files(self):
  with tempfile.TemporaryDirectory() as folder:
   root=Path(folder);prefix=root/'prefix';binary=prefix/'bin/multienv';binary.parent.mkdir(parents=True);binary.write_text('preexisting')
   env=dict(os.environ,HOME=folder,XDG_CONFIG_HOME=str(root/'config'))
   installer=ROOT/'bin/multienv-install'
   for _ in range(2): subprocess.run([installer,'--prefix',str(prefix)],env=env,check=True,capture_output=True)
   config=root/'config/multienv/multienv.toml';config.write_text('user customization')
   subprocess.run([installer,'--prefix',str(prefix),'--uninstall'],env=env,check=True,capture_output=True)
   self.assertEqual(binary.read_text(),'preexisting')
   self.assertEqual(config.read_text(),'user customization')

 def test_logout_preserves_unsaved_windows(self):
  with tempfile.TemporaryDirectory() as folder:
   root=Path(folder);binary=root/'bin';binary.mkdir();log=root/'commands'
   stub=binary/'hyprctl'
   stub.write_text('#!/usr/bin/env python3\nimport json,sys,os\nfrom pathlib import Path\nwith Path(os.environ["TEST_LOG"]).open("a") as f: f.write(" ".join(sys.argv[1:])+"\\n")\nif sys.argv[1:]==["clients","-j"]: print(json.dumps([{"address":"0x123"}]))\n')
   stub.chmod(0o755)
   notify=binary/'notify-send';notify.write_text('#!/bin/sh\nexit 0\n');notify.chmod(0o755)
   env=dict(os.environ,PATH=str(binary)+':'+os.environ['PATH'],HYPRLAND_INSTANCE_SIGNATURE='fixture',XDG_RUNTIME_DIR=folder,TEST_LOG=str(log))
   result=subprocess.run([ROOT/'bin/multienv-logout','--timeout','0'],env=env,capture_output=True)
   self.assertEqual(result.returncode,2)
   self.assertNotIn('dispatch exit',log.read_text())

 def test_session_paths_are_data_and_launch_failure_survives(self):
  with tempfile.TemporaryDirectory(prefix="multienv's space ") as folder:
   root=Path(folder);binary=root/'bin';binary.mkdir();config=root/'profile.conf';config.touch()
   stub=binary/'Hyprland';stub.write_text('#!/usr/bin/env python3\nimport sys,os,json\nfrom pathlib import Path\nPath(os.environ["TEST_ARGS"]).write_text(json.dumps(sys.argv[1:]))\nsys.exit(7)\n');stub.chmod(0o755)
   toml=root/'profile.toml';toml.write_text('[general]\nsession_manager="direct"\n[environments.test]\ncompositor="Hyprland"\nconfig_path='+json.dumps(str(config))+'\n')
   env=dict(os.environ,PATH=str(binary)+':'+os.environ['PATH'],TEST_ARGS=str(root/'args'))
   result=subprocess.run([ROOT/'bin/multienv-session','--config',str(toml),'test'],env=env,capture_output=True)
   self.assertEqual(result.returncode,7)
   self.assertEqual(json.loads((root/'args').read_text()),['--config',str(config)])

 def test_autologin_transaction_and_failed_validation(self):
  with tempfile.TemporaryDirectory() as folder:
   root=Path(folder);module=load('multienv_fixture',ROOT/'bin/multienv')
   target=root/'autologin.conf';target.write_text('original\n')
   module.write_atomic(target,'replacement\n')
   self.assertEqual(target.read_text(),'replacement\n')
   self.assertEqual(next(root.glob('autologin.conf.bak-*')).read_text(),'original\n')
   for name in ['../bad.desktop','/tmp/bad.desktop','x.desktop\nUser=bad']:
    with self.assertRaises(ValueError):module.session_filename(name)
   config=root/'invalid.conf';config.write_text('invalid_property = nonsense\n')
   issues=module.validate_environment('fixture',{'config_path':str(config),'session_desktop':'missing.desktop'}, {'general':{'wayland_sessions_dir':folder}})
   self.assertTrue(issues)

if __name__=="__main__": unittest.main(verbosity=2)
