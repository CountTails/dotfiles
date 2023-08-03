#! /usr/bin/env python3

import os
import sys
import tomllib
import typing
import argparse


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

    def get_package_options(self, package_name: str) -> typing.Mapping:
        options = {}
        package_info = self.get_package(package_name)
        if 'options' in package_info:
            options.update(package_info.get('options'))
        return options

    def get_package_files(self, package_name: str) -> typing.Mapping:
        files = {}
        package_info = self.get_package(package_name)
        if 'files' in package_info:
            files.update(package_info.get('files'))
        return files

    def get_package_setup(self, package_name: str) -> typing.Mapping:
        setups = {}
        package_info = self.get_package(package_name)
        if 'setup' in package_info:
            setups.update(package_info.get('setup'))
        return setups


class LinkConfig:
    pass


class LinkPrune:
    pass


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
            'package',
            nargs='+'
            )

    parser_prune = subparsers.add_parser(
            'unlink',
            help='prune the listed package configurations(s)'
            )
    parser_prune.add_argument(
            'package',
            nargs='+'
            )

    return parser.parse_args()


def rcld():
    cli_args = cli()
    print(cli_args)
    repo = ConfigsRepo()
    print(repo._data)


if __name__ == '__main__':
    rcld()
