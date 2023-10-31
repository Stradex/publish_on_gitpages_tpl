#!/bin/bash

# Installing jupyter nbconvert so we can convert Google Collab files into html
pip install jupyter nbconvert

LOCAL_POSTS="`pwd`/articulos"
NEXTJS_POSTS="`pwd`/site/src/app/articulos"
PAGEJS_TEMPLATE="`pwd`/site/src/app/_blog_template.js"

# Copying files from local articulos folder into NextJS project articulos folder
cp -r "$LOCAL_POSTS"/* "$NEXTJS_POSTS"

# Check if the target is not a directory
if [ ! -d "$NEXTJS_POSTS" ]; then
  exit 1
fi

# Iterate through NextJS articulos folder so we can convert the necessary Google Collab files
# And also rename the necessary page.mdx files
function iterate() {
  local dir="$1"

  for file in "$dir"/*; do
    if [ -f "$file" ]; then
      filename=$(basename "$file")
      extension="${filename##*.}"
      directory=$(dirname "$file")
      if [ "$extension" == "mdx" ] || [ "$extension" == "md" ]; then
        mv -f "$file" "$directory/page.mdx"
      elif [ "$extension" == "ipynb" ]; then
        cp $PAGEJS_TEMPLATE "$directory/page.js"
        jupyter nbconvert -y --output-dir=$directory --to html --template=colab_web_tpl/tpl --theme=dark --output jupyter.html $file
      fi
      echo "$file"
    elif [ -d "$file" ]; then
      iterate "$file"
    fi
  done
}

iterate $NEXTJS_POSTS

echo "BUILD COLLAB AND MARKDOWN OK"