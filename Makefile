PCMENC?=pcmenc
BEEBASM?=beebasm

revo2.ssd: play.gap.s rev12.nogaps.wav.pcmenc
	$(BEEBASM) -i play.gap.s -do revo2.ssd -boot revo -v >out.txt

rev12.nogaps.wav.pcmenc: rev12.nogaps.wav
	$(PCMENC) -p 4 -cpuf 4000000 -dt1 111 -dt2 111 -dt3 111 rev12.nogaps.wav || true
	truncate --size=8448 rev12.nogaps.wav.pcmenc

rev12.nogaps.wav:
	perl revo2.pl <rev12000.2.wav|sox -t s16 -c 1 -r 12000 - rev12.nogaps.wav

clean:
	-rm -f revo2.ssd rev12.nogaps.wav rev12.nogaps.wav.pcmenc
