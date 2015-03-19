Parallelize Commands
====================
Controlled parallelization of arbitrary command line tools.


Introduction
-----------
To increase the degree of capacity utilization and to take full advantage of the underlying hardware it is sometimes necessary to execute several jobs in parallel. One solution could be the use of queying system (e.g. Torque or Sungrid) but on single servers or workstations one often requires a more simple solution.

This tool provides a convenient solution to run several commands on a single server or workstation in parallel and to control the number of processes that are running at the same time. It uses the Perl ```fork()``` implementation and consists of a single Perl script with no dependencies.


Demo
-----------
The script ```parallelize_cmds``` takes at least to parameters. The first parameter is an integer indicating the number of jobs to be run at the same time. The parameters 2 to n are the actual jobs that have to be run. A parallalization of 3 jobs (2 at the same time) would be for example:

```./parallelize_cmds 2 "echo 'hello'" "echo 'world'"```

Commands that contain spaces need to be framed with double quotes. If more or longer commands have to be executed, a more convenient could be to save everything into a ```.sh``` file and executed this. For 5 commands the bash would contain for example:

```
#!/bin/bash

./parallelize_cmds 2 \
"echo 'hello'" \ 
"echo 'world'" \
"echo 'how'" \
"echo 'are'" \
"echo 'you'"
```
