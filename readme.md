# Cluster Server (Galena)

This repo is meant to make a cluster server from main-line raspberry pi (this will be tested RPi 5 8GB) and use as nodes Raspberry Pi Zero line (this will be tested with two raspberry Zero 2W), this server solution can use up to 4 raspberry pi zeros. This also uses "[ClusterHAT](https://clusterhat.com)".

> NOTE: This will be tested on newest version of Raspbian downloaded through RPi Imager (with 64b OS).

## Structure

This repo has four folders "Main", "Side", "AllNodes" and "Client"

- Main is used for your main / master node.
- Side is used for your side / slave nodes.
- AllNodes is used for any server side node.
- Client is what you install onto your computer. (These are mostly used for automatization, automatically uploading to NAS etc.)

## Constructs

Construct is small JSON-like structure file that tells the node what services you want to have managed by this code. How often it runs / what / how etc.
