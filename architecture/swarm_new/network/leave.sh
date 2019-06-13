#!/bin/bash
docker swarm leave -f
echo "----------------Containers----------------"
docker ps -a
echo
echo "------------------Images------------------"
docker images
echo
echo "-----------------Volumes------------------"
docker volume ls
