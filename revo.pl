#!/usr/bin/perl -w
undef $/;
$/=\44;<>;
f(15,181,80);
f(52,162,80);

sub f {
    ($n,$q,$r)=@_;
    $/=\($q*2);
    my @a;
    for $m (1..$n) {
        $_=<>;
	print substr($_,0,$r*2),"\0"x(($q-$r)*2);
    }
}
