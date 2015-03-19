Parallelize Commands
====================
Controlled parallelization of any command line tools.


Introduction
-----------
The absence of queuying systems like Torque or Sungrid requires other possibilities to run jobs in parallel and in a controlled environment.

This tool provides a simple solution to run several commands on a single server or workstation in parallel and to controle the number of processes that are running at the same time. It uses the Perl ```fork()``` implementation and consists of a single Perl script with no dependencies.


