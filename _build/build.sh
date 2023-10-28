#!/usr/bin/bash

mkdir -p out
(echo "<pre>" ; find ; echo "</pre>") > out/index.html
