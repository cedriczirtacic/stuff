#!/bin/env perl -w
my @alphanum = ( ('a'..'z'), ('A'..'Z'), (0..9));
my @flag = ( 193, 35, 9, 33, 1, 9, 3, 33, 9, 225 );

sub encode($) {
    my $char = shift;
    return ((((ord($char) << 5) | (ord($char) >> 3)) ^ 111) & 255);
}

foreach(@flag) {
    foreach my $char(@alphanum) {
        if (encode($char) == $_) {
            print $char;
        }
    }
}
print "\n";
