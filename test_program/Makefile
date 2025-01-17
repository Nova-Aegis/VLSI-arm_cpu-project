CC = /usr/bin/arm-linux-gnu-gcc # replace with your arm gcc compiler
AS_ARM = /usr/bin/arm-linux-gnu-as # replace with your arm asm compiler
LD_ARM = /usr/bin/arm-linux-gnu-ld # replace with your arm linker
CFLAGS = -march=armv2a
LD_FLAGS = -Bstatic -fix-v4bx

PROG1 = small_program_sum
PROG2 = sum


all : $(PROG1) $(PROG2)

%.o : %.c
	$(CC) $(CFLAGS) -mno-thumb-interwork -g -o $@ -c $^

%.o : %.s
	$(AS_ARM) $(CFLAGS) -g -o $@ -c $^

$(PROG1) : $(PROG1).o
	$(LD_ARM) $(LD_FLAGS) -T sections.lds -g -o $@ $^

$(PROG2) : $(PROG2).o
	$(LD_ARM) $(LD_FLAGS) -T sections.lds -g -o $@ $^

.PHONY : all
