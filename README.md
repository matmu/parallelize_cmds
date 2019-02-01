Parallelize Commands
====================
Controlled parallelization of arbitrary command line tools.


Introduction
-----------
To use your hardware resources more efficiently, you can run multiple commands in parallel. This can be achieved on the command line by spawning sub-processes with ```&``` and to wait for the spawned processes to terminate using ```wait```. However, this approach doesn't allow to control for the number of processes that run in parallel.

This script provides a convenient solution to run multiple commands in parallel and to control the number of processes that are running at the same time. It uses the Perl ```fork()``` implementation and consists of a single Perl script with no dependencies.


Example
-----------
The script ```parallelize_cmds``` needs at least three parameters. The first parameter is an integer indicating the maximum number of commands to be run at the same time. The second parameter is 0 or 1 depending on whether you pass you commands as 3rd to n parameter (0) or whether you pass a file as 3rd parameter in which each line represents a command (1). A parallalization of 3 jobs (2 at the same time) would be for example:

```./parallelize_cmds 2 0 "echo 'hello'" "echo 'world'" "echo '!'"```

Commands that contain spaces need to be framed with double quotes. If more or longer commands have to be executed, a more convenient could be to save it into a ```.sh``` file. For 5 commands the bash would contain for example:

```
#!/bin/bash

./parallelize_cmds 2 0 \
"echo 'hello'" \ 
"echo 'world'" \
"echo 'how'" \
"echo 'are'" \
"echo 'you'"
```

Alternatively, if you chose to run the script with a file ```test.sh``` containing your commands

```
echo 'hello'
echo 'world'
echo 'how'
echo 'are'
echo 'you'
```

you would execute the script with

```./parallelize_cmds 2 1 test.sh```
