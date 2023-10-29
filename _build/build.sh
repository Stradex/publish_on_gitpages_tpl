#!/usr/bin/bash

which make

OUT_DIR="`pwd`/out"
mkdir -p $OUT_DIR
(echo "<pre>" ; find ; echo "</pre>") > out/index.html

echo "BUILD Colab/Jupyter"
pip install jupyter nbconvert
jupyter nbconvert -y --output-dir=./_build/html --to html --template=colab_web_tpl/tpl --theme=dark *.ipynb
#XXX:move to colab_web_tpl repo

echo "BUILD plantuml"
curl -Lo plantuml.jar 'https://github.com/plantuml/plantuml/releases/download/v1.2023.12/plantuml-1.2023.12.jar'
java -jar plantuml.jar -o "$OUT_DIR" -tsvg -darkmode _build/test*.uml

echo "BUILD Next"

