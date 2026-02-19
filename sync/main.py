from __future__ import annotations

import argparse
import hashlib
import re
import shutil
import subprocess
import sys
import urllib.request
from pathlib import Path


URL_RE = re.compile(r'^(?P<indent>\s*)url\s+"(?P<url>[^"]+)"\s*$')
SHA_RE = re.compile(r'^(?P<indent>\s*)sha256\s+"(?P<sha>[^"]+)"\s*$')


def _resolve_url(url: str, formula_path: Path) -> str:
    if "#{__dir__}" in url:
        url = url.replace("#{__dir__}", str(formula_path.parent))
    return url


def _read_url_bytes(url: str, formula_path: Path) -> bytes:
    if url.startswith("file://"):
        path_str = url[len("file://") :]
        path = Path(path_str)
        if not path.is_absolute():
            path = (formula_path.parent / path).resolve()
        return path.read_bytes()

    with urllib.request.urlopen(url, timeout=60) as response:
        return response.read()


def _sha256_hex(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def update_formula_sha256(formula_path: Path) -> bool:
    content = formula_path.read_text(encoding="utf-8")
    lines = content.splitlines()
    updated = False

    idx = 0
    while idx < len(lines):
        match = URL_RE.match(lines[idx])
        if not match:
            idx += 1
            continue

        url = _resolve_url(match.group("url"), formula_path)

        sha_idx = idx + 1
        while sha_idx < len(lines):
            sha_match = SHA_RE.match(lines[sha_idx])
            if sha_match:
                data = _read_url_bytes(url, formula_path)
                new_sha = _sha256_hex(data)
                indent = sha_match.group("indent")
                lines[sha_idx] = f'{indent}sha256 "{new_sha}"'
                updated = True
                idx = sha_idx + 1
                break
            sha_idx += 1
        else:
            idx += 1

    if updated:
        formula_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return updated


def _brew_path() -> str | None:
    return shutil.which("brew")


def _run_build_tests(formula_files: list[Path]) -> int:
    brew = _brew_path()
    if not brew:
        print("brew not found in PATH; cannot run build tests.", file=sys.stderr)
        return 1

    for formula in formula_files:
        try:
            subprocess.run(
                [brew, "reinstall", "--build-from-source", str(formula)],
                check=True,
            )
        except subprocess.CalledProcessError as exc:
            print(f"Build test failed for {formula}: {exc}", file=sys.stderr)
            return exc.returncode or 1
    return 0


def _parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Sync formula sha256 values.")
    parser.add_argument(
        "--test-only",
        action="store_true",
        help="Only run the build tests, skipping updates.",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = _parse_args(sys.argv[1:] if argv is None else argv)
    repo_root = Path(__file__).resolve().parents[1]
    formula_dir = repo_root / "Formula"
    if not formula_dir.is_dir():
        print(f"Formula directory not found at {formula_dir}", file=sys.stderr)
        return 1

    formula_files = sorted(formula_dir.glob("*.rb"))
    if not formula_files:
        print("No formula files found.", file=sys.stderr)
        return 1

    if not args.test_only:
        any_updates = False
        for formula in formula_files:
            try:
                if update_formula_sha256(formula):
                    any_updates = True
                    print(f"Updated sha256 in {formula}")
            except Exception as exc:
                print(f"Failed to update {formula}: {exc}", file=sys.stderr)
                return 1

        if not any_updates:
            print("No updates made.")

    return _run_build_tests(formula_files)


if __name__ == "__main__":
    raise SystemExit(main())
