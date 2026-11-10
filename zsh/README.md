# My ZSH configuration

## Introduction

This repo contains the configuration setup that I use to run [ZSH](https://www.zsh.org)

**Key Features**

- Environment setup for various package managers (brew, cargo, go, etc.)
- Useful alias and function definitions with a alias lookup tool (`aliasfor`)
- Plugin discovery and loading
- Prompt configured using the [Starship Cross-Shell Prompt](https://starship.rs)

**Prerequisites**

Before installing, make the

- A Z shell interpreter is installed
- A backup of any existing `~/.zshrc` is created

**Project Structure**

```plaintext
├── bootstrap          # setup and maintenance scripts
├── config             # configuration files
└── README.md          # this file
```

## Getting started

**Configuration**

Configuration is handled using the Z shell scripting language. The configuration can be found in the `config/` directory. The files define components of the entire Z shell configuration. The `config/init.zsh` sources the individual components in a particular order to bring together the final configuration for the interactive session.

**Installation**

This configuration utilizes the conventional `~/.zshrc` for configuration interactive sessions and `~/.zshenv` for configuration the environment. The scripts in the `bootstrap` directory will handle the mapping of the files in the `config` directory to the correct corresponding conventional file. A simple `source ~/.zshrc` should allow the new configuration to take affect.
