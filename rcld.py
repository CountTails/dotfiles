#! /usr/bin/env python3

import os
import sys
import tomllib
import typing
import argparse
import subprocess


class BaseDotfileLinkerException(Exception):
    """Base exception for errors regarding the dotfiles linking script"""


class NoSuchConfigurationException(BaseDotfileLinkerException):
    """Exception raised when an expected configuration is missing"""


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
        if 'files' in package_info:
            files.update(package_info.get('links'))
        return files

    def get_package_setup(self, package_name: str) -> typing.Mapping:
        setups = {}
        package_info = self.get_package(package_name)
        if 'setup' in package_info:
            setups.update(package_info.get('setup'))
        return setups


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
    parser_prune.set_defaults(func=prune_config)
    parser_prune.set_defaults(repo=ConfigsRepo())

    return parser.parse_args()


def link_config(args):
    for packge in args.packages:
        print(f'Linking package: {packge}')
        try:
            for file in args.repo.get_package_links(packge):
                if args.force:
                    exited_process = subprocess.run([
                        'ln',
                        '-sf',
                        file['Source'],
                        file['Target']
                        ])
                else:
                    exited_process = subprocess.run([
                        'ln',
                        '-s',
                        file['Source'],
                        file['Target']
                    ])
                exited_process.check_returncode()
                print(f'\tSuccessfully linked {packge}.{file}')
            print(f'Successfully linked package: {packge}\n')
            print('Additional setup:')
            for step, text in enumerate(args.repo.get_package_setup(packge)['Instructions'], 1):
                print(f'\t{step}: {text}')
        except subprocess.CalledProcessError:
            print(f'\tLink command for {packge}.{file} failed!')
            sys.exit(1)
    sys.exit(0)


def prune_config(args):
    for packge in args.packages:
        print(f'Unlinking package: {packge}')
        try:
            for file in args.repo.get_package_links(packge):
                if args.force:
                    exited_process = subprocess.run([
                        'rm',
                        '-f',
                        file['Target']
                        ])
                else:
                    exited_process = subprocess.run([
                        'rm',
                        file['Target']
                    ])
                exited_process.check_returncode()
                print(f'\tSuccessfully unlinked {packge}.{file}')
            print(f'Successfully unlinked package: {packge}\n')
        except subprocess.CalledProcessError:
            print(f'\tLink command for {packge}.{file} failed!')
            sys.exit(1)
    sys.exit(0)


def rcld():
    cli_args = cli()
    cli_args.func(cli_args)


if __name__ == '__main__':
    rcld()
