# mappingInR-Workshop


### Mac OS Installation

## installing from DMG files


##using homebrew
if you need to install homebrew
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

then install some necessary libraries, R, and R Studio

```sh
brew install gcc
brew tap homebrew/science
brew install r
brew install cask
brew cask install xquartz
brew cask install rstudio
```

clone this repo, if you haven't already
```sh
git clone https://github.com/jrpepper/mappingInR-Workshop.git
```

cd into the repo directory and install some R packages
```sh
cd mappingInR-Workshop
cat install_packages.R | R --no-save
```

