#!/bin/bash

# Install dependencies using Homebrew with Brewfile
brew bundle

# Generate source code by Sourcery
sourcery

# Done! Open your workspace
open SteinsKit.xcworkspace
