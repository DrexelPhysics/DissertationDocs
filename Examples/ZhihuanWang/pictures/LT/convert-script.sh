#!/bin/bash

for f in *.jpg; do
  convert ./"$f" ./"${f%.jpg}.pdf"
done

for f in *.png; do
  convert ./"$f" ./"${f%.png}.pdf"
done
