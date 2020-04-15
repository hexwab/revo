#!/usr/bin/perl -w
undef $/;
$/=\44;<>;
f(15,181,256/3);
f(52,162,256/3);

sub f {
    ($n,$q,$r)=@_;
    $/=\($q*2);
$e=0;
    my @a;
    for $m (1..$n) {
        $_=<>;
	$e+=$r;
	$i=85;#int($e);
	$e-=$i;
	#print $i;
	print substr($_,0,$i*2);#,"\0"x(($q-$r)*2);
    }
}
