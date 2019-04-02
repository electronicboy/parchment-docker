# PaperMC Parchment boot docker image

## What is this

This dockerfile is designed to provide a way to bootstrap servers using the parchment API

## Environment variables

| variable | default | description |
|:-|:-|:-|
| project  | paper | Controls which project to use |
| version | latest | Controls which version to use |
| build | latest | controls which build to use |

## volumes

| volume | usage |
|:-|:-|
| /home/server/root | server root |
