#!/bin/bash
cp aaa.png iTunesArtwork.png
cp iTunesArtwork.png Icon.png
cp Icon.png Icon@2x.png
cp Icon.png Icon-120.png
cp Icon.png Icon-72.png
cp Icon.png Icon-80.png
cp Icon.png Icon-Small.png
cp Icon.png Icon-Small@2x.png
cp Icon.png Icon-Small-50.png
sips -z 57 57 Icon.png
sips -z 114 114 Icon@2x.png
sips -z 120 120 Icon-120.png
sips -z 72 72 Icon-72.png
sips -z 80 80 Icon-80.png
sips -z 29 29 Icon-Small.png
sips -z 58 58 Icon-Small@2x.png
sips -z 50 50 Icon-Small-50.png
sips -z 512 512 iTunesArtWork.png
