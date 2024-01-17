#!/bin/bash

reponse=1

while [ "$reponse" -eq 0 ];
do
	curl 192.168.1.2
	reponse=$?
done