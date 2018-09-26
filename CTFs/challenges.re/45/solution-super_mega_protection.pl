#!/bin/env perl -w
#
use Data::Dumper;
my @key;

sub check_serial(@)
{
    my @key = @_;
    my $key_size = $#key + 1;
    my $ret = 0x0;

    $rcx = 0xffff;
    foreach (@key) {
        $rdx = ord $_;
        $rsi = $rcx ^ $rdx;
        $rcx = $rcx >> 0x1;
        $r8 = $rcx ^ 0x8408;
        if (($rsi & 0x1) == 0x0) {
                $r8 = $rcx;
        }
        $rcx = $rdx >> 0x1 ^ $r8;
        $r8 = $r8 >> 0x1;
        $rsi = $r8 ^ 0x8408;
        if (($rcx & 0x1) == 0x0) {
                $rsi = $r8;
        }
        $rcx = $rdx >> 0x2 ^ $rsi;
        $rsi = $rsi >> 0x1;
        $r8 = $rsi ^ 0x8408;
        if (($rcx & 0x1) == 0x0) {
                $r8 = $rsi;
        }
        $rcx = $rdx >> 0x3 ^ $r8;
        $r8 = $r8 >> 0x1;
        $rsi = $r8 ^ 0x8408;
        if (($rcx & 0x1) == 0x0) {
                $rsi = $r8;
        }
        $rcx = $rdx >> 0x4 ^ $rsi;
        $rsi = $rsi >> 0x1;
        $r8 = $rsi ^ 0x8408;
        if (($rcx & 0x1) == 0x0) {
                $r8 = $rsi;
        }
        $rcx = $rdx >> 0x5 ^ $r8;
        $r8 = $r8 >> 0x1;
        $rsi = $r8 ^ 0x8408;
        if (($rcx & 0x1) == 0x0) {
                $rsi = $r8;
        }
        $rcx = $rdx >> 0x6 ^ $rsi;
        $rsi = $rsi >> 0x1;
        $r8 = $rsi ^ 0x8408;
        if (($rcx & 0x1) == 0x0) {
                $r8 = $rsi;
        }
        $rsi = $r8 >> 0x1;
        $rcx = $rsi ^ 0x8408;
        if (($r8 & 0x1) == $rdx >> 0x7) {
                $rcx = $rsi;
        }
    }
    # last part
    $rcx = (~$rcx)&0xffffffff;
    $eax = ($rcx << 0x8)&0xffffffff;
    $ecx = (($rcx&0xff00)>>0x8)+$eax;
    $ret = $ecx & 0xffff;

    if ($ret == 0xe425) {
        printf " \$ret: 0x%08x\n", $ret;
        open(FD, ">other.key");
        printf "FOUND! Key: other.key\n";

        $solution = join("",@key);
        printf FD "%s%s", $solution,"\x00"x(132-length($solution));
        close(FD);
        return(1);
    }
    return (0);
}

AGAIN:
    foreach (0..15) {
        my $l = 0;
        while($l<65){$l = int(rand(122))};
        push @key, chr $l;

        exit(0) if check_serial(@key);
    }
    undef @key;
    goto AGAIN;
print $/
__END__
