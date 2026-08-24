# Cluster Server (Galena)

This repo is meant to make a cluster server from main-line raspberry pi (this will be tested RPi 5 8GB) and use as nodes Raspberry Pi Zero line (this will be tested with two raspberry Zero 2W), this server solution can use up to 4 raspberry pi zeros. This also uses "[ClusterHAT](https://clusterhat.com)".

> NOTE: This will be tested on newest version of Raspbian downloaded through RPi Imager (with 64b OS Lite;).

## Structure

This repo has four folders "Main", "Side", "AllNodes" and "Client"

- Main is used for your main / master node.
- Side is used for your side / slave nodes.
- AllNodes is used for any server side node.
- Client is what you install onto your computer. (These are mostly used for automatization, automatically uploading to NAS etc.)

> NOTE: just because something is in specific directory doesn't have to mean it's incompatible, it's more so recommendation and where I'll be testing that.

## Constructs

Construct is small JSON-like structure file that tells the node what services you want to have managed by this code. How often it runs / what / how etc.

## Notes / things to look for

- SSH sends language environments, in `/etc/ssh/ssh_config`. Change `SendEnv LANG LC_*` to just `SendEnv LANG`. This will warning in SSH, which I recommend doing. It might have better / different solution but this worked for me. [Source](https://dev.to/yugabyte/ssh-and-warning-setlocale-lcctype-cannot-change-locale-utf-8-no-such-file-or-directory-5cnf)
