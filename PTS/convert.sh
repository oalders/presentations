#!/bin/bash

# wget https://github.com/hakimel/reveal.js/archive/master.tar.gz
# tar -xzvf master.tar.gz
# mv reveal.js-master reveal.js

pandoc -t revealjs -s -o PTS.html PTS.md
