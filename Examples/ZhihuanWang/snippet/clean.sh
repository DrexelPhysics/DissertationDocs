#!/bin/bash

rm -vf figures/scratch/*
rm -vf bu.* bu[0-9]* root.b[bl]* root.[ailnop]* root.toc
find -L . -name '*.aux' -exec rm -vf '{}' \;
