#!/usr/bin/env python3
import os
import gzip
import shutil

HOME = os.path.expanduser("~")
HISTFILE = os.path.join(HOME, ".bash_history")
BAKFILE = os.path.join(HOME, ".bash_history.bak")
MAX_SIZE = 10 * 1024 * 1024  # 10 MB
MAX_BACKUPS = 6

def ensure_file_exists(filepath):
    if not os.path.exists(filepath):
        open(filepath, 'a').close()

def read_lines(filepath):
    if not os.path.exists(filepath):
        return []
    with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
        return [line.rstrip('\n') for line in f]

def rotate_backups():
    # Remove oldest if it exists
    oldest = f"{BAKFILE}.{MAX_BACKUPS}.gz"
    if os.path.exists(oldest):
        os.remove(oldest)

    # Shift backups .5.gz -> .6.gz, etc.
    for i in range(MAX_BACKUPS - 1, 0, -1):
        old = f"{BAKFILE}.{i}.gz"
        new = f"{BAKFILE}.{i+1}.gz"
        if os.path.exists(old):
            os.rename(old, new)

    # Move main bak to .1 and gzip it
    shutil.move(BAKFILE, f"{BAKFILE}.1")
    with open(f"{BAKFILE}.1", 'rb') as f_in, gzip.open(f"{BAKFILE}.1.gz", 'wb') as f_out:
        shutil.copyfileobj(f_in, f_out)
    os.remove(f"{BAKFILE}.1")

def main():
    ensure_file_exists(HISTFILE)
    ensure_file_exists(BAKFILE)

    # Read current lines
    bak_lines = set(read_lines(BAKFILE))
    hist_lines = read_lines(HISTFILE)

    # Find new lines not in BAK
    new_lines = [l for l in hist_lines if l not in bak_lines]

    if new_lines:
        # Append new lines to bak
        with open(BAKFILE, 'a', encoding='utf-8') as f:
            for line in new_lines:
                f.write(line + "\n")

    # Check size
    if os.path.getsize(BAKFILE) > MAX_SIZE:
        rotate_backups()
        # Create a fresh bak file after rotation
        ensure_file_exists(BAKFILE)

if __name__ == "__main__":
    main()
