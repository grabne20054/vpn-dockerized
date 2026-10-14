#!/bin/bash

ufw allow 1194/udp
ufw allow OpenSSH

ufw disable
ufw enable