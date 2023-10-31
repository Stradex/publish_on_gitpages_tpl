#!/bin/bash

pip install jupyter nbconvert

LOCAL_POSTS="`pwd`/posts"
NEXTJS_POSTS="`pwd`/site/posts"

# Copying files from local posts folder into NextJS project posts folder
cp -r "$LOCAL_POSTS"* $NEXTJS_POSTS

cd site

# Define the target directory
OUT_DIR="`pwd`/src/app/articulos"
directory="`pwd`/posts"
pattern="*.mdx"
PAGEJS_TEMPLATE="`pwd`/src/app/_blog_template.js"

# Check if the target is not a directory
if [ ! -d "$directory" ]; then
  exit 1
fi

# Loop through files in the target directory
for file in "$directory"/*; do
  if [ -f "$file" ]; then
    #mkdir -p "$OUT_DIR/"
    filename=$(basename "$file")
    filename_no_ext="${filename%.*}"
    extension="${filename##*.}"
    dest_folder=$OUT_DIR/"$filename_no_ext"
    if [ "$extension" == "mdx" ]; then
        mkdir -p "$dest_folder"
        cp "$file" "$dest_folder/page.mdx"
    elif [ "$extension" == "md" ]; then
        mkdir -p "$dest_folder"
        cp "$file" "$dest_folder/page.mdx"
    #elif [ "$extension" == "ipynb" ]; then
    #    mkdir -p "$dest_folder"
    #    cp $PAGEJS_TEMPLATE "$dest_folder/page.js"
    #    jupyter nbconvert -y --output-dir=$dest_folder --to html --template=colab_web_tpl/tpl --theme=dark --output jupyter.html $file
    fi
  fi
done

cd ..

echo "BUILD COLLAB AND MARKDOWN OK"