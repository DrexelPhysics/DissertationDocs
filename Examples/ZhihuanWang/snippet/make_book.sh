#!/bin/bash
pdfjam --booklet true --nup 2x1 --noautoscale false thesis.pdf --landscape --scale 1.05 --twoside --suffix 'offset' && xpdf thesis-offset.pdf
