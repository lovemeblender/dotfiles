#!/usr/bin/env bash

# This script needs execution permission:
# chmod +x brew.sh

echo "Installing Homebrew"
cd /usr/local; mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
echo "Homebrew successfully installed"

echo "Updating Homebrew"
brew update
echo "Homebrew updated"

echo "Upgrading Homebrew"
brew upgrade
echo "Homebrew upgraded"

# Cask

brew tap caskroom/cask
brew install brew-cask
brew tap caskroom/versions
brew cask install xquartz

echo "Installing brew packaging"
brew install coreutils
brew install moreutils
brew install findutils
brew install tig
brew install git
brew install node
brew install python3
brew install wget
brew install screen
brew install mysql
brew install postgresql
brew install mongodb
brew install ruby
brew install rbenv
brew install heroku
brew install maven
brew install redis
brew install spark
brew install tree
brew install emacs
brew install the_silver_searcher
brew install --with-x11 homebrew/science/r
brew install docker docker-compose

# Non-essentials/Uncommented if needed
# brew install leiningen
# brew install racket
# brew install jq

echo "Basic brew packages installed."

echo "Installing cask packages"
brew cask install haskell-platform
brew cask install --appdir=/Applications rstudio
brew cask install --appdir=/Applications iterm2
brew cask install --appdir=/Applications google-chrome
brew cask install --appdir=/Applications slack
brew cask install --appdir=/Applications spotify
brew cask install --appdir=/Applications sublime-text
brew cask install --appdir=/Applications postman
brew cask install --appdir=/Applications skype
brew cask install --appdir=/Applications the-escapers-flux

echo "Cask apps installed."
