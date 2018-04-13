#!/usr/bin/env perl
#
use strict;
use warnings;
use utf8;
use feature 'unicode_strings';

use Data::Dumper;

BEGIN {
    exit(1) if ($#ARGV != 0);
}

# zero width non-printing characters
my %zero_chars = (
	zwsp => "\x{200B}", # 1
	zwnj => "\x{200C}", # 0
	zwj  => "\x{200D}", # letter
	zwnb => "\x{FEFF}"  # word
);

# functions
sub tozerow($);
sub wtozw($);

my $secret = $ARGV[0];
die("strings len must be > 0\n") if (length($secret) == 0);

my $output = pack("a*", tozerow($secret));
print $output;

# transform string to zero width chars
sub tozerow($) {
    my $string = shift;
    $string =~ s/^\s*(.+?)\s*$/$1/g;

    my @zwords;
    foreach (split / /, $string) {
        push @zwords, wtozw($_);
    }

    return join $zero_chars{'zwnb'}, @zwords;
}

# word to zero width
sub wtozw($) {
    my $word = shift;
    my @zws;

    foreach (split //, $word) {
        my $bits = unpack("B*",$_); # get bits
        print $bits, "\n" if exists $ENV{DEBUG};
        foreach my $bit(split //, $bits) {
            if ($bit == "0") {
                push @zws, $zero_chars{'zwnj'};
                print Dumper $zero_chars{'zwnj'} if exists $ENV{DEBUG} ;
            } else {
                push @zws, $zero_chars{'zwsp'};
                print Dumper $zero_chars{'zwsp'} if exists $ENV{DEBUG} ;
            }
        }
        print $/ if exists $ENV{DEBUG};
        push @zws, $zero_chars{'zwj'}
    }
    return join "", @zws;
}

__END__
