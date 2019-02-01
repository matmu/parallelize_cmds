#!/usr/bin/perl

use strict;
use warnings;


# -----------------------------------------------
# Author: Matthias Munz
# -----------------------------------------------


if (!defined $ARGV[0] || !defined $ARGV[1] || !defined $ARGV[2]){
	print STDERR "Arguments required: n_forks is_list [list | cmd1 cmd2 ...]\n";
	exit(0);
}

my ($n_forks, $is_list, @list_or_cmds) = @ARGV;


print "Jobs in parallel: ".$n_forks."\n";


my @cmds;
if($is_list eq "1"){
	my ($list) = @list_or_cmds;
	die "File '$list' doesn't exist\n" if(!defined $list or !-e $list);
	
	open(IN, "<".$list) or die "Cannot open file '$list': $!\n";
	while(<IN>){
		chomp($_);
		if(defined $_ and $_ ne ""){
			push(@cmds, $_);
		}
	}
	close IN;
}
elsif($is_list eq "0"){
	@cmds = @list_or_cmds;
}

print "Number of jobs: ".@cmds."\n";


my $forkmanager = Parallel::SystemFork -> new();
$forkmanager -> add_job($_) for @cmds;
$forkmanager -> run_jobs($n_forks);
$forkmanager -> wait();


package Parallel::SystemFork;


# -----------------------------------------------
# Constructor
sub new {
# -----------------------------------------------
	my ($class, $configs) = @_;
	
	my $self = {};
	
	$self -> {'pids'} = {};
	$self -> {'job_increment'} = 0;
	$self -> {'cmds'} = {};
	$self -> {'finished_jobs'} = [];
	
	bless($self, $class);
	
	$SIG{CHLD} = 'IGNORE';
	
	return($self);
}


# -----------------------------------------------
sub add_job {
# -----------------------------------------------	
	my ($self, $cmd) = @_;
	
	my $job_id = $self -> _new_job_id();
	
	$self -> {'cmds'} -> {$job_id} = $cmd;
	
	return $job_id;
}


# -----------------------------------------------
sub run_jobs {
# -----------------------------------------------
	my ($self, $n) = @_;
	
	
	while (keys(%{$self -> {'cmds'}})){
		
		my @job_ids = sort {$a <=> $b} keys(%{$self -> {'cmds'}});
		
		foreach my $job_id (@job_ids){
						
			my $current_n = $self -> _update_jobs();
			
			if (!defined $n || $current_n  < $n){
					
				my $cmd = $self -> {'cmds'} -> {$job_id};
				
				my $pid = fork();
						
				if ($pid){		
						
							
					# Parent
					delete $self -> {'cmds'} -> {$job_id};
					$self -> {'pids'} -> {$pid} = $job_id;
				}
				elsif (defined $pid && $pid == 0){
					
					
					# Run job
					system($cmd);

					exit(0);		
				}
				else {
					die "Couldn't fork: $!\n";
				}
			}	
		}
	}
}


# -----------------------------------------------
sub wait {
# -----------------------------------------------
	my ($self) = @_;
	
	my @pids = keys(%{$self -> {'pids'}});
	
	foreach (@pids){
		waitpid($_, 0);
		
		push(@{$self -> {'finished_jobs'}}, $self -> {'pids'} -> {$_});
		delete($self -> {'pids'} -> {$_});
	}
}


# -----------------------------------------------
sub _update_jobs {
# -----------------------------------------------
	my ($self) = @_;
	
	my @pids = keys(%{$self -> {'pids'}});
	
	foreach (@pids){
		if (!kill(0 => $_)){
			
			waitpid($_, 0);
			
			push(@{$self -> {'finished_jobs'}}, $self -> {'pids'} -> {$_});
			delete($self -> {'pids'} -> {$_});	
		}
	}
	
	my $pids = keys(%{$self -> {'pids'}});
	
	return $pids;
}


# -----------------------------------------------
sub _new_job_id {
# -----------------------------------------------
	my ($self) = @_;

	my $job_increment = $self -> {'job_increment'};
	$job_increment++;
	$self -> {'job_increment'} = $job_increment;
	
	return $job_increment;
}


1;
