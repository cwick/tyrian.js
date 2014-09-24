#!/bin/bash

# Deploys the latest version of Tyrian.js to the Github page.
# Run this script from the project root directory

export BROCCOLI_ENV='production'

git co master &&\
rm -rf production_build && broccoli build production_build &&\
git co gh-pages                   &&\
cp -a production_build/assets .   &&\
cp -a production_build/src .      &&\
cp -a production_build/lib .      &&\

git add assets src lib            &&\
git commit -m"Automated build and deploy" &&\
git push                          &&\
git co master                     &&\

rm -rf production_build
