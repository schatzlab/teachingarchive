#!/usr/bin/perl -w

my $shift = 5;

if (scalar @ARGV > 0)
{
  $shift = shift @ARGV;
  print STDERR "Mutating every $shift bp\n";
}

my $seq = "";
while (<>)
{
  chomp;
  $seq .= $_;
}

my %rc;
$rc{A} = "T";
$rc{T} = "A";
$rc{C} = "G";
$rc{G} = "C";

for (my $i = 0; $i < length($seq); $i+=$shift)
{
  substr($seq, $i, 1) = $rc{substr($seq, $i, 1)};
}

print "$seq\n";



