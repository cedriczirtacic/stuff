#!/usr/bin/env perl -w

use Data::Dumper;

my @passwd;

sub check_passwd (@)
{
    my $val = 0;
    my @pass = @_;
    foreach (@pass) {
        $val += ord($_);
    }
    
    return (0) if ($val > 0x1f8);
    if ($val == 0x1f8) {
        printf "FOUND! Pass: %s\n", join("",@pass);
        return (1);
    }

    return (0);
}

AGAIN:
    for (0..6) { #let's keep it short
        my $l = 0;
        while ($l < 65) { $l = int(rand(126)); }
        push @passwd, chr($l);

        #print @passwd,$/;
        exit(0) if check_passwd(@passwd);
    }
    undef @passwd;
    goto AGAIN;
__END__

