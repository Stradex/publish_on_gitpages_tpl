#!/usr/bin/bash

cd site
npm ci --legacy-peer-deps
echo "INSTALLED DEPENDENCIES OK"
cd ..