#!/usr/bin/env bash
# -*- coding: None -*-

if  command -v apt &> /dev/null
then
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get update -y
fi

if  command -v yum &> /dev/null
then
    echo "COMMAND could not be found"
fi

if  command -v pacman &> /dev/null
then
    sudo pacman -Syyuu
fi

