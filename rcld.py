#! /usr/bin/env python3

import os
import sys
import tomllib
import typing
import argparse
import subprocess
import logging


LOGGER = logging.getLogger(__name__)
HANDLER = logging.StreamHandler()
HANDLER.setFormatter(logging.Formatter('%(levelname)s: %(message)s'))
LOGGER.addHandler(HANDLER)
LOGGER.setLevel(logging.WARNING)


class BaseDotfileLinkerException(Exception):
    """Base exception for errors regarding the dotfiles linking script"""


class NoSuchConfigurationException(BaseDotfileLinkerException):
    """Exception raised when an expected configuration is missing"""


class ShellCommandFailure(BaseDotfileLinkerException):
    """Exception raised when a shell command has a nonzero exit code"""


class ConfigsRepo:
    """
        Represents the directory that contains package configurations and their settings
    """
    __directory__: str = os.path.dirname(os.path.abspath(sys.argv[0]))
    __settings__: str = 'dotfiles.toml'

    def __init__(self):
        with open(f"{self.__directory__}/{self.__settings__}", "rb") as f:
            self._data: typing.Mapping = tomllib.load(f)

    def get_package_info(self, package_name: str) -> typing.Mapping:
        if package_name in self._data:
            return self._data[package_name]
        raise NoSuchConfigurationException(
                f'No such package name: {package_name}'
                )


class ShellCommand:

    def __init__(self):
        self._executed = False
        self._program = None
        self._options = []
        self._args = []

    def set_executable(self, binary: str):
        LOGGER.debug("New executable: %s", binary)
        self._program = binary

    def add_option(self, flag: str):
        LOGGER.debug("New option: %s", flag)
        self._options.append(flag)
        LOGGER.debug("Options to pass: %s", " ".join(self._options))

    def add_argument(self, arg: str):
        LOGGER.debug("New argument: %s", arg)
        self._args.append(arg)
        LOGGER.debug("Arguments to pass: %s", " ".join(self._args))

    @property
    def cmd(self):
        return [self._program] + self._options + self._args

    def run(self):
        try:
            LOGGER.debug("Running command: %s", " ".join(self.cmd))
            subprocess.run(
                    args=self.cmd,
                    capture_output=True,
                    check=True
                    )
            self._executed = True
            LOGGER.debug("Command execution successful")
        except subprocess.CalledProcessError as err:
            LOGGER.error(
                    "Command %s exited with code %d",
                    " ".join(self.cmd),
                    err.returncode
                    )
            raise ShellCommandFailure(
                    f'Command: {" ".join(self.cmd)} exited with code {err.returncode}. '
                    f'Captured output:\n{err.stderr}'
                    ) from err


def cli():
    parser = argparse.ArgumentParser(
            prog='rcld',
            description='A script for managing configuration file links'
            )
    parser.add_argument(
            '-v',
            '--verbose',
            action='store_true',
            help='cause the program to increase logging'
            )
    parser.add_argument(
            '-q',
            '--quiet',
            action='store_true',
            help='cause the program to minimize logging'
            )
    subparsers = parser.add_subparsers(required=True)

    parser_link = subparsers.add_parser(
            'link',
            help='link the listed package configuration(s)'
            )
    parser_link.add_argument(
            '-f',
            '--force',
            action='store_true',
            help='overwrite an existing link'
            )
    parser_link.add_argument(
            'packages',
            nargs='+'
            )
    parser_link.set_defaults(func=link_config)
    parser_link.set_defaults(repo=ConfigsRepo())

    parser_prune = subparsers.add_parser(
            'unlink',
            help='prune the listed package configuration(s)'
            )
    parser_prune.add_argument(
            'packages',
            nargs='+'
            )
    parser_prune.add_argument(
            '-f',
            '--force',
            action='store_true',
            help='forceably remove a link'
            )
    parser_prune.set_defaults(func=prune_config)
    parser_prune.set_defaults(repo=ConfigsRepo())

    return parser.parse_args()


def link_config(args):
    def do_package_setup(package_info):
        LOGGER.info("Setting up package: %s", package_info['PackageName'])

        def make_required_dirs(directories: typing.List[str]):
            LOGGER.debug('Directories to create: %d', len(directories))
            for d in directories:
                cmd = ShellCommand()
                cmd.set_executable('/bin/mkdir')
                cmd.add_option('-p')
                cmd.add_argument(os.path.expanduser(d))
                LOGGER.info("Creating directory: %s", os.path.expanduser(d))
                cmd.run()

        if 'setup' not in package_info:
            return
        if 'RequiredDirectories' in package_info['setup']:
            make_required_dirs(package_info['setup']['RequiredDirectories'])

    def create_package_links(package_info, cmd_args):
        LOGGER.info("Linking up package: %s", package_info['PackageName'])
        for _, link in package_info['links'].items():
            cmd = ShellCommand()
            cmd.set_executable('/bin/ln')
            cmd.add_option('-s')
            if cmd_args.force:
                cmd.add_option('-f')
            cmd.add_argument(f"{cmd_args.repo.__directory__}/{link['Source']}")
            cmd.add_argument(os.path.expanduser(link['Target']))
            LOGGER.info(
                    'Linking file: %s -> %s',
                    os.path.expanduser(link['Target']),
                    link['Source']
                    )
            cmd.run()

    for packge in args.packages:
        package_info = args.repo.get_package_info(packge)
        do_package_setup(package_info)
        create_package_links(package_info, args)


def prune_config(args):
    def prune_package_links(package_info, cmd_args):
        LOGGER.info("Unlinking package: %s", package_info['PackageName'])
        for _, link in package_info['links'].items():
            cmd = ShellCommand()
            cmd.set_executable('/bin/rm')
            if cmd_args.force:
                cmd.add_option('-f')
            cmd.add_argument(os.path.expanduser(link['Target']))
            LOGGER.info("Unlinking file: %s", os.path.expanduser(link['Target']))
            cmd.run()

    for package in args.packages:
        package_info = args.repo.get_package_info(package)
        prune_package_links(package_info, args)


def rcld():
    try:
        cli_args = cli()
        if cli_args.verbose:
            LOGGER.setLevel(logging.DEBUG)
        if cli_args.quiet:
            LOGGER.setLevel(logging.CRITICAL)
        cli_args.func(cli_args)
        sys.exit(0)
    except BaseDotfileLinkerException as err:
        LOGGER.error('%s', str(err))
        sys.exit(1)


if __name__ == '__main__':
    rcld()
