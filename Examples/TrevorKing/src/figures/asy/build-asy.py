#!/usr/bin/env python3

import hashlib as _hashlib
import os as _os
import os.path as _os_path
import subprocess as _subprocess
import sys as _sys


ASY = ['asy', '-noprc', '-render', '0']


def load_cache(path):
    cache = {}
    try:
        with open(path, 'r') as f:
            for line in f:
                line = line.strip()
                if line.startswith('#') or not line:
                    continue
                original,hash = line.split('\t')
                cache[original] = hash
    except IOError as e:
        print(e)
    return cache

def save_cache(path, cache):
    with open(path, 'w') as f:
        for original,hash in sorted(cache.items()):
            f.write('{}\t{}\n'.format(original, hash))

def file_hash(path):
    with open(path, 'rb') as f:
        h = _hashlib.sha256(f.read())
    return str(h.hexdigest())

def find_originals(root):
    originals = {}
    for dirpath,dirnames,filenames in _os.walk(root, followlinks=True):
        if dirpath == _os_path.abspath(asydir):
            continue
        for filename in filenames:
            if filename.endswith('.asy'):
                path = _os_path.join(dirpath, filename)
                if _os_path.islink(path):
                    continue
                with open(path, 'rb') as f:
                    text = f.read()
                originals[path] = text
    return originals

def match_original(path, originals):
    with open(path, 'rb') as f:
        text = f.read()
    for o_path,o_text in originals.items():
        if o_text in text:
            return o_path
    raise KeyError(path)

def is_outdated(source, target, cache):
    if not _os_path.exists(target):
        return True
    hash = file_hash(source)
    if hash == cache.get(source, None):
        return False
    return True
    #source_time = _os.stat(source).st_mtime
    #target_time = _os.stat(target).st_mtime
    #return source_time > target_time

def symlink(source, link_name):
    if (_os_path.exists(link_name) and
        _os_path.realpath(link_name) != _os_path.realpath(source)):
        _os.remove(link_name)  # old link points somewhere else
    if not _os_path.exists(link_name):
        print('link {} -> {}'.format(link_name, source))
        _os.symlink(source, link_name)

def build_asy(path, originals, cache):
    original_path = match_original(path, originals)
    print('matched {} with {}'.format(path, original_path))
    original_dir = _os_path.dirname(original_path)
    install_dir,filename = _os_path.split(path)
    link_path = _os_path.join(original_dir, filename)
    symlink(path, link_path)
    root,ext = _os_path.splitext(filename)
    output_filename = root + '.tex'
    output_path = _os_path.join(original_dir, output_filename)
    if is_outdated(original_path, output_path, cache):
        print('rebuild {}'.format(path))
        args = ASY + [filename]
        p = _subprocess.Popen(args, cwd=original_dir)
        stdout,stderr = p.communicate()
        status = p.wait()
        assert status == 0, (status, stderr)
        cache[original_path] = file_hash(original_path)
    for output_filename in _os.listdir(original_dir):
        output_path = _os_path.join(original_dir, output_filename)
        if (output_filename.startswith(root) and
            not _os_path.islink(output_path)):
            install_path = _os_path.join(install_dir, output_filename)
            symlink(output_path, install_path)


if __name__ == '__main__':
    asydir = '.'
    if len(_sys.argv) >= 2:
        asydir = _sys.argv[1]

    cache_path = _os_path.join(asydir, '.cache')
    cache = load_cache(cache_path)
    originals = find_originals(
        root=_os_path.abspath(_os_path.join(asydir, '..')))
    filenames = _os.listdir(asydir)
    try:
        for filename in _os.listdir(asydir):
            source_path = _os_path.abspath(_os_path.join(asydir, filename))
            if _os_path.islink(source_path) or filename == '.cache':
                continue
            build_asy(source_path, originals, cache)
    finally:
        save_cache(cache_path, cache)
