#!/usr/bin/env python3
import errno
import os
import logging
import shutil
import sys

SELF = os.path.dirname(os.path.realpath(__file__))


class SymLinker(object):
    def __init__(self, dest_dir=None, dotfiles_dir=None, include=None,
                 verbose=False):
        self.dest_dir = dest_dir or os.environ["HOME"]
        self.dotfiles_dir = dotfiles_dir
        self.backup_dir = os.path.join(self.dotfiles_dir, "backup")
        self.include = include or [line.strip() for line in open("dotfiles.txt")]
        self.verbose = verbose

    @property
    def dotfiles_dir(self):
        return self._dotfiles_dir

    @dotfiles_dir.setter
    def dotfiles_dir(self, value):
        if not value:
            try:
                value = sys.argv[1]
            except IndexError:
                value = SELF

        value = os.path.realpath(value)
        self._dotfiles_dir = value

    def resolve(self, path=None):
        from_path = self.source_path(path)

        if path:
            self._link(path)

        if not os.path.isdir(from_path):
            return

        listdir = os.listdir(from_path)

        if not path:
            def included(x):
                return x in self.include

            def not_dotfile(x):
                return not x.startswith('.')

            listdir = filter(included, listdir)
            listdir = filter(not_dotfile, listdir)

        for name in sorted(listdir):
            rel_path = os.path.join(path, name) if path else name
            if self.verbose:
                logging.info("Checking: {}".format(rel_path))
            self.resolve(path=rel_path)

    def _link(self, path):
        from_path = self.source_path(path)
        to_path = self.dest_path(path)

        if os.path.isdir(from_path):
            # Ensure target exists and is a directory
            if not os.path.lexists(to_path):
                os.makedirs(to_path)
            elif os.path.isdir(to_path):
                return True
        else:
            try:
                os.symlink(from_path, to_path)
                logging.info("Linked: {} to {}".format(path, to_path))
            except OSError as ex:
                if ex.errno != errno.EEXIST:
                    logging.error("Could not link: {} ({})".format(path, ex))
                    return False

                if os.path.samefile(from_path, to_path):
                    # Already linked, and the same
                    return True

                if os.path.islink(to_path) or os.path.isfile(to_path):
                    # Only backup and remove if target isn't a directory
                    self._backup(path)

                # Try again ...
                try:
                    os.symlink(from_path, to_path)
                    logging.info("Linked: {} to {}".format(path, to_path))
                except (shutil.Error, OSError) as ex:
                    logging.error("Could not link: {} ({})".format(path))
                    return

        if os.path.isdir(from_path) != os.path.isdir(to_path):
            logging.error("Could not link: {} (Source/dest type mismatch)"
                          .format(path))
            return False

        logging.info("Created: {}".format(to_path))
        return True

    def _backup(self, path, remove=False):
        from_path = self.dest_path(path)
        to_path = self.backup_path(path)
        if not os.path.exists(os.path.dirname(to_path)):
            os.makedirs(os.path.dirname(to_path))
        logging.info("Backing up: {}".format(path))
        if os.path.exists(to_path):
            if os.path.isfile(from_path) != os.path.isfile(to_path):
                if os.path.isfile(to_path):
                    os.unlink(to_path)
                else:
                    shutil.rmtree(to_path)
        shutil.move(from_path, to_path)

    def source_path(self, path):
        if path:
            return os.path.join(self.dotfiles_dir, path)
        else:
            return self.dotfiles_dir

    def dest_path(self, path):
        assert path is not None
        return os.path.join(self.dest_dir, '.{}'.format(path))

    def backup_path(self, path):
        assert path is not None
        return os.path.join(self.backup_dir, path)


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    linker = SymLinker()
    linker.resolve()
