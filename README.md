Parallelize Commands
====================
Controlled parallelization of arbitrary command line tools.


Introduction
-----------
The absence of queuying systems like Torque or Sungrid requires other possibilities to run jobs in parallel and in a controlled environment.

This tool provides a simple and convenient solution to run several commands on a single server or workstation in parallel and to controle the number of processes that are running at the same time. It uses the Perl ```fork()``` implementation and consists of a single Perl script with no dependencies.


Demo
-----------
The script ```parallelize_cmds``` takes at least to parameters. The first parameter is an integer indicating the number of jobs to be run at the same time. The parameters 2 to n are the actual jobs that have to be run. A parallalization of 3 jobs (2 at the same time) would be: for example

```./parallelize_cmds 2 "echo 'hello'" "echo 'world'"```

