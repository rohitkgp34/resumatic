import sys
from subprocess import check_output as shell
command = ["docker", "node", "ls"]
nodes = shell(command).decode().split("\n")[1:]
n = len(nodes)

for i in range(n):
	nodes[i] = nodes[i].split(" ")
count = 0
if sys.argv[1]=="me":
	for i in range(n):
		if "*" in nodes[i]:
			print(nodes[i][4])
			break
else:
	for i in range(n):
		if "*" not in nodes[i]:
			count+=1
			if str(count)==sys.argv[1]:
				print(nodes[i][5])
				break

