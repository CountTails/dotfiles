#! /usr/bin/env python3

import os
import sys
import tomllib
import typing
import argparse
import subprocess
import time


class BaseDotfileLinkerException(Exception):
    """Base exception for errors regarding the dotfiles linking script"""


class NoSuchConfigurationException(BaseDotfileLinkerException):
    """Exception raised when an expected configuration is missing"""


class ConfigurationLinkFailure(BaseDotfileLinkerException):
    """Exception raised when a link command fails to succeed"""


class ConfigurationPruneFailure(BaseDotfileLinkerException):
    """Exception raised when a prune command fails to succeed"""


class ConfigsRepo:
    """
        Represents the directory that contains package configurations and their settings
    """
    __directory__: str = os.path.dirname(os.path.abspath(sys.argv[0]))
    __settings__: str = 'dotfiles.toml'

    def __init__(self):
        with open(f"{self.__directory__}/{self.__settings__}", "rb") as f:
            self._data: typing.Mapping = tomllib.load(f)

    def get_package(self, package_name: str) -> typing.Mapping:
        if package_name in self._data:
            return self._data[package_name]
        raise NoSuchConfigurationException(
                f'No such package name: {package_name}'
                )

    def get_package_links(self, package_name: str) -> typing.Mapping:
        files = {}
        package_info = self.get_package(package_name)
        if 'links' in package_info:
            files.update(package_info.get('links'))
        return files

    def get_package_setup(self, package_name: str) -> typing.Mapping:
        setups = {}
        package_info = self.get_package(package_name)
        if 'setup' in package_info:
            setups.update(package_info.get('setup'))
        return setups


class LinkCommand:
    def __init__(self, options, link_source, link_target):
        self._args = []
        self._args.append('/bin/ln')
        self._args.append('-s')
        if options.force:
            self._args.append('-f')
        self._args.append(link_source)
        self._args.append(link_target)

    def exec(self):
        try:
            print(f'\tExecuting: {" ".join(self._args)}')
            subprocess.run(
                    args=self._args,
                    capture_output=True,
                    check=True,
                    )
            time.sleep(1)
        except subprocess.CalledProcessError as err:
            print(f'\tCommand failed: {" ".join(self._args)}')
            raise ConfigurationLinkFailure(
                f'Command: {" ".join(self._args)} exited with code {err.returncode}.'
                f' Captured output:\n{err.stderr}'
                    ) from err


class UnlinkCommand:
    def __init__(self, options, link_to_prune):
        self._args = []
        self._args.append('/bin/rm')
        if options.force:
            self._args.append('-f')
        self._args.append(link_to_prune)

    def exec(self):
        try:
            print(f'\tExecuting: {" ".join(self._args)}')
            subprocess.run(
                    args=self._args,
                    capture_output=True,
                    check=True,
                    )
            time.sleep(1)
        except subprocess.CalledProcessError as err:
            print(f'\tCommand failed: {" ".join(self._args)}')
            raise ConfigurationPruneFailure(
                f'Command: {" ".join(self._args)} exited with code {err.returncode}.'
                f' Captured output:\n{err.stderr}'
                    ) from err


def cli():
    parser = argparse.ArgumentParser(
            prog='rcld',
            description='A script for managing configuration file links'
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
            help='prune the listed package configurations(s)'
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
    for packge in args.packages:
        print(f'Linking package: {packge}')
        for file, link in args.repo.get_package_links(packge).items():
            cmd = LinkCommand(
                args,
                f'{args.repo.__directory__}/{link["Source"]}',
                os.path.expanduser(link['Target']),
                )
            cmd.exec()
            print(f'\tLinked file: {packge}.{file}')
        print(f'Successfully linked: {packge}')


def prune_config(args):
    for package in args.packages:
        print(f'Unlinking package: {package}')
        for file, link in args.repo.get_package_links(package).items():
            cmd = UnlinkCommand(
                    args,
                    os.path.expanduser(link['Target'])
                    )
            cmd.exec()
            print(f'\tUnlinked file: {package}.{file}')
        print(f'Successfully unlinked: {package}')


def rcld():
    cli_args = cli()
    cli_args.func(cli_args)


if __name__ == '__main__':
    rcld()
