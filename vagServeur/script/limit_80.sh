#!/bin/bash

#limiter le nombre de connexions http
ufw limit 80
ufw --force reload
ufw status verbose
