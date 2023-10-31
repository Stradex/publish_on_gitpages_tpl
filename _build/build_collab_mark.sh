#!/bin/bash

pip install jupyter nbconvert

LOCAL_POSTS="`pwd`/articulos"
NEXTJS_POSTS="`pwd`/site/src/app/articulos"
PAGEJS_TEMPLATE="`pwd`/site/src/app/_blog_template.js"

# Copying files from local posts folder into NextJS project posts folder
cp -r "$LOCAL_POSTS"* $NEXTJS_POSTS



# Check if the target is not a directory
if [ ! -d "$NEXTJS_POSTS" ]; then
  exit 1
fi

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


# Loop through files in the target directory
# for file in "$NEXTJS_POSTS"/*; do
#   if [ -f "$file" ]; then
#     filename=$(basename "$file")
#     filename_no_ext="${filename%.*}"
#     extension="${filename##*.}"
#     dest_folder=$OUT_DIR/"$filename_no_ext"
#     if [ "$extension" == "mdx" ]; then
#         mkdir -p "$dest_folder"
#         cp "$file" "$dest_folder/page.mdx"
#     elif [ "$extension" == "md" ]; then
#         mkdir -p "$dest_folder"
#         cp "$file" "$dest_folder/page.mdx"
#     elif [ "$extension" == "ipynb" ]; then
#         mkdir -p "$dest_folder"
#         cp $PAGEJS_TEMPLATE "$dest_folder/page.js"
#         jupyter nbconvert -y --output-dir=$dest_folder --to html --template=../colab_web_tpl/tpl --theme=dark --output jupyter.html $file
#     fi
#   fi
# done

# cd ..

echo "BUILD COLLAB AND MARKDOWN OK"