#!/usr/bin/perl -w

use strict;
use warnings;

defined($ARGV[0]) || die "Must specify run names";
my @runnames = @ARGV; # -> column names

open(RUNTIME, ">runtime.tex") || die "Could not open >runtime.tex";
print RUNTIME "\\documentclass{article}\n";
print RUNTIME "\\begin{document}\n";
print RUNTIME "\\begin{table}\n";
print RUNTIME "\\caption{Running time for mapping 8M simulated reads against human chromosomes 22 and 2 and the whole human genome.}\n";
print RUNTIME "\\begin{tabular}{l";
for(my $i = 0; $i <= $#runnames; $i++) {
	print RUNTIME "r";
}
print RUNTIME "}\n";
print RUNTIME "\\hline\n";
print RUNTIME " & Chr 22 & Chr 2 & Whole Genome \\\\ \\hline \n";

open(MEMORY, ">memory.tex") || die "Could not open >memory.tex";
print MEMORY "\\documentclass{article}\n";
print MEMORY "\\begin{document}\n";
print MEMORY "\\begin{table}\n";
print MEMORY "\\caption{Peak virtual and resident memory usage for mapping 8M simulated reads against human chromosomes 22 and 2 and the whole human genome.}\n";
print MEMORY "\\begin{tabular}{l";
for(my $i = 0; $i <= $#runnames; $i++) {
	print MEMORY "r";
}
print MEMORY "}\n";
print MEMORY "\\hline\n";
print MEMORY " & Human Chromosome 22 & Human Chromosome 2 & Whole Human Genome \\\\ \\hline \n";

sub readlines {
	my $f = shift;
	my @ret;
	open(FILE, $f) || die "Could not open $f";
	while(<FILE>) {
		chomp;
		push(@ret, $_)
	}
	return @ret;
}

sub readfline {
	my $f = shift;
	my $l = shift;
	my @ret;
	open(FILE, $f) || die "Could not open $f";
	while(<FILE>) {
		chomp;
		push(@ret, $_)
	}
	return $ret[$l] if $l <= $#ret;
	return "";
}

sub toMinsSecsHrs {
	my $s = shift;
	my $hrs  = int($s / 60 / 60);
	my $mins = int(($s / 60) % 60);
	my $secs = int($s % 60);
	while(length($secs) < 2) { $secs = "0".$secs; }
	if($hrs > 0) {
		while(length($mins) < 2) { $mins = "0".$mins; }
		return $hrs."h:".$mins."m:".$secs."s";
	} else {
		return $mins."m:".$secs."s";
	}
}

my @names = ("Bowtie",
             "Maq with -n 1",
             "Maq",
             "Soap with -v 1",
             "Soap");

# Output 
for(my $i = 0; $i < 5; $i++) {
	print RUNTIME "$names[$i] & ";
	for(my $j = 0; $j <= $#runnames; $j++)  {
		my $n = $runnames[$j];
		my $l = readfline("$n.results.txt", $i);
		if($l eq "") {
			print RUNTIME "- ";
		} else {
			my @s = split(/ /, $l);
			my @s2 = split(/,/, $s[1]);
			print RUNTIME toMinsSecsHrs($s2[0])." ";
		}
		if($j < $#runnames) { print RUNTIME "& "; }
	}
	print RUNTIME " \\\\ \\hline \n";
}

# Output 
for(my $i = 0; $i < 5; $i++) {
	print MEMORY "$names[$i] & ";
	for(my $j = 0; $j <= $#runnames; $j++)  {
		my $n = $runnames[$j];
		my $l = readfline("$n.results.txt", $i);
		if($l eq "") {
			print MEMORY "- ";
		} else {
			my @s = split(/ /, $l);
			my @s2 = split(/,/, $s[1]);
			print MEMORY "$s2[1] ($s2[2]) ";
		}
		if($j < $#runnames) { print MEMORY "& "; }
	}
	print MEMORY " \\\\ \\hline \n";
}

print RUNTIME "\\end{tabular}\n";
print RUNTIME "\\end{table}\n";
print RUNTIME "\\end{document}\n";

print MEMORY "\\end{tabular}\n";
print MEMORY "\\end{table}\n";
print MEMORY "\\end{document}\n";

close(RUNTIME);
close(MEMORY);
