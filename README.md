Parallelize commands
====================
Controlled parallelization of arbitrary command line tools.


Introduction
-----------
To use your hardware resources more efficiently, you can run multiple commands in parallel. It can be achieved on the command line by spawning sub-processes with ```&``` and waiting afterwards for the spawned processes to terminate using ```wait()```. However, this approach doesn't allow to control for the number of processes that run in parallel.

The script ```parallelize_cmds.pl``` provides a convenient solution to run multiple commands in parallel and to control the number of jobs that are running at the same time. It uses the Perl ```fork()``` implementation and consists of a single Perl script with no dependencies.

Other, more complicated solutions are to you use ```xargs``` with the parameters ```-P``` und ```-n``` ([Stackoverflow article](https://stackoverflow.com/questions/28357997/running-programs-in-parallel-using-xargs)) or to use GNU Parallel ([here](https://www.gnu.org/software/parallel/)).


Usage
-----------
The script ```parallelize_cmds.pl``` requires at least three parameters. The first parameter is an integer indicating the maximum number of commands to be run at the same time. The second parameter is either ```0``` or ```1``` depending on whether you pass you commands as 3rd to n parameter (0) or whether a file as 3rd parameter in which each line represents a command (1). A parallalization of 3 jobs (2 at the same time) would be for example:


### Pass jobs as arguments
```./parallelize_cmds.pl 2 0 "echo 'hello'" "echo 'world'" "echo '!'"```

Commands that contain spaces need to be framed with double quotes. If many or longer commands have to be executed, a more convenient is to save it into a ```.sh``` file. For 5 commands the bash would contain for example:

```
#!/bin/bash

./parallelize_cmds.pl 2 0 \
"echo 'hello'" \ 
"echo 'world'" \
"echo 'how'" \
"echo 'are'" \
"echo 'you'"
```

### Run jobs from file
Alternatively, if you chose to run the script with a file ```test.sh``` containing your commands

```
echo 'hello'
echo 'world'
echo 'how'
echo 'are'
echo 'you'
```

the script is exectued with

```./parallelize_cmds.pl 2 1 test.sh```
