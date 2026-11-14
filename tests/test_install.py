"""Exercise the installer against an isolated Git source without creating tags."""

import argparse
import datetime
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


REPOSITORY = Path(__file__).resolve().parents[1]
INSTALLER = REPOSITORY / "scripts" / "install.sh"
REMOTE_URL = "https://github.com/DumDereDum/thesis-trail.git"
BASH = shutil.which("bash")
GIT = shutil.which("git")


class InstallationTests(unittest.TestCase):
    work_directory = None

    @classmethod
    def setUpClass(cls):
        cls.environment = {
            key: value for key, value in os.environ.items()
            if not key.startswith("GIT_")
        }
        cls.environment.update({
            "GIT_CONFIG_NOSYSTEM": "1",
            "GIT_CONFIG_GLOBAL": str(cls.work_directory / "gitconfig"),
            "GIT_TERMINAL_PROMPT": "0",
        })
        cls.source = cls.work_directory / "source.git"
        subprocess.run(
            [GIT, "clone", "--quiet", "--bare", "--no-hardlinks", "--no-tags",
             str(REPOSITORY), str(cls.source)],
            env=cls.environment, check=True, capture_output=True,
        )
        cls.git("config", "--global", f"url.{cls.source.as_uri()}.insteadOf", REMOTE_URL)
        cls.git("config", "--global", "protocol.file.allow", "always")
        cls.git("update-ref", 'refs/heads/feature/quote"check', "refs/heads/init-work")
        assert not cls.git("tag", "--list"), "The test source must not contain tags."

    @classmethod
    def git(cls, *arguments):
        return subprocess.run(
            [GIT, "--git-dir", str(cls.source), *arguments],
            env=cls.environment, check=True, capture_output=True, text=True,
        ).stdout.strip()

    def setUp(self):
        self.case_directory = self.work_directory / self._testMethodName
        self.project = self.case_directory / "student project with spaces"
        self.project.mkdir(parents=True)
        self.scratch = self.case_directory / "temporary"
        self.scratch.mkdir()
        self.environment = dict(type(self).environment, TMPDIR=str(self.scratch))
        self.invocation = 0

    @property
    def metadata(self):
        return self.project / ".tt" / "thesis-trail.json"

    def run_installer(self, *arguments, environment=None, piped=False):
        self.invocation += 1
        command = [BASH, "-s", "--"] if piped else [BASH, str(INSTALLER)]
        options = {"input": INSTALLER.read_text()} if piped else {"stdin": subprocess.DEVNULL}
        result = subprocess.run(
            [*command, *arguments], cwd=self.project,
            env=environment or self.environment, capture_output=True, text=True,
            timeout=30, **options,
        )
        for stream in ("stdout", "stderr"):
            (self.case_directory / f"run-{self.invocation}.{stream}.log").write_text(
                getattr(result, stream)
            )
        self.assertEqual(
            list(self.scratch.glob("thesis-trail.*")), [],
            "Installer temporary data was not cleaned up.",
        )
        return result

    def assert_metadata(self, branch):
        data = json.loads(self.metadata.read_text())
        self.assertEqual(set(data), {
            "schema_version", "repository", "version", "tag", "branch", "commit",
            "installed_at", "updated_at",
        })
        self.assertEqual(data["schema_version"], 1)
        self.assertEqual(data["repository"], REMOTE_URL)
        self.assertIsNone(data["version"])
        self.assertIsNone(data["tag"])
        self.assertEqual(data["branch"], branch)
        self.assertEqual(data["commit"], self.git("rev-parse", f"refs/heads/{branch}"))
        self.assertEqual(data["installed_at"], data["updated_at"])
        datetime.datetime.strptime(data["installed_at"], "%Y-%m-%dT%H:%M:%SZ")
        self.assertEqual(
            sorted(path.name for path in self.metadata.parent.iterdir()),
            ["thesis-trail.json"],
        )

    def test_main_and_existing_project_files(self):
        original = self.project / "notes.txt"
        original.write_text("Student notes must remain unchanged.\n")
        result = self.run_installer("--branch", "main")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assert_metadata("main")
        self.assertEqual(original.read_text(), "Student notes must remain unchanged.\n")
        self.assertEqual(sorted(path.name for path in self.project.iterdir()), [".tt", "notes.txt"])

    def test_init_work_from_standard_input(self):
        result = self.run_installer("--branch", "init-work", piped=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assert_metadata("init-work")

    def test_branch_name_is_json_escaped(self):
        branch = 'feature/quote"check'
        result = self.run_installer("--branch", branch)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assert_metadata(branch)

    def test_repeat_installation_preserves_metadata(self):
        first = self.run_installer("--branch", "main")
        self.assertEqual(first.returncode, 0, first.stderr)
        before = self.metadata.read_bytes(), self.metadata.stat().st_mtime_ns
        result = self.run_installer("--branch", "init-work")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("already exists", result.stderr)
        self.assertEqual((self.metadata.read_bytes(), self.metadata.stat().st_mtime_ns), before)

    def test_invalid_arguments_do_not_change_project(self):
        cases = [
            ["--update"], ["--yes"], ["--unknown"], ["--branch"], ["--tag"],
            ["--tag", "invalid"], ["--branch", "../invalid"],
            ["--branch", "main", "--tag", "v0.1.0"],
        ]
        for arguments in cases:
            with self.subTest(arguments=arguments):
                result = self.run_installer(*arguments)
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(list(self.project.iterdir()), [])

    def test_missing_branch_leaves_no_metadata(self):
        result = self.run_installer("--branch", "does-not-exist")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Could not retrieve branch", result.stderr)
        self.assertEqual(list((self.project / ".tt").iterdir()), [])

    def test_no_tags_does_not_fall_back_to_main(self):
        result = self.run_installer()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("No vX.Y.Z tags found", result.stderr)
        self.assertEqual(list((self.project / ".tt").iterdir()), [])

    def test_existing_invalid_json_is_not_overwritten(self):
        self.metadata.parent.mkdir()
        self.metadata.write_text("User data; not valid JSON.\n")
        result = self.run_installer("--branch", "main")
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.metadata.read_text(), "User data; not valid JSON.\n")

    def test_service_directory_symlink_is_rejected(self):
        outside = self.case_directory / "outside"
        outside.mkdir()
        (self.project / ".tt").symlink_to(outside, target_is_directory=True)
        result = self.run_installer("--branch", "main")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("symbolic link", result.stderr)
        self.assertEqual(list(outside.iterdir()), [])

    def test_missing_git_is_detected_before_changes(self):
        empty_path = self.case_directory / "empty-bin"
        empty_path.mkdir()
        environment = dict(self.environment, PATH=str(empty_path))
        result = self.run_installer("--branch", "main", environment=environment)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Required command not found: git", result.stderr)
        self.assertEqual(list(self.project.iterdir()), [])

    def test_unreachable_source_leaves_no_metadata(self):
        configuration = self.case_directory / "unreachable.gitconfig"
        configuration.write_text(
            f'[url "{(self.case_directory / "missing.git").as_uri()}"]\n'
            f'    insteadOf = {REMOTE_URL}\n'
            '[protocol "file"]\n    allow = always\n'
        )
        environment = dict(self.environment, GIT_CONFIG_GLOBAL=str(configuration))
        result = self.run_installer("--branch", "main", environment=environment)
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.metadata.exists())
        self.assertEqual(list((self.project / ".tt").iterdir()), [])

    def test_help_does_not_initialize_project(self):
        result = self.run_installer("--help")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("Usage:", result.stdout)
        self.assertEqual(list(self.project.iterdir()), [])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--work-dir", type=Path,
        default=REPOSITORY.parent / "thesis-trail-install-tests",
        help="Parent directory for preserved test projects and logs.",
    )
    arguments = parser.parse_args()
    arguments.work_dir.mkdir(parents=True, exist_ok=True)
    InstallationTests.work_directory = Path(tempfile.mkdtemp(
        prefix="run-", dir=arguments.work_dir.resolve(),
    ))
    print(f"Test artifacts: {InstallationTests.work_directory}", flush=True)
    unittest.main(argv=[__file__], verbosity=2)
