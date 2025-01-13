CC = /usr/bin/arm-linux-gnu-gcc
AS_ARM = /usr/bin/arm-linux-gnu-as
LD_ARM = /usr/bin/arm-linux-gnu-ld
CFLAGS = -march=armv2a -Wall
LD_FLAGS = -Bstatic -fix-v4bx

PROG1 = small_program_sum
PROG2 = sum


all : $(PROG1) $(PROG2)

%.o : %.c
	$(CC) $(CFLAGS) -mno-thumb-interwork -g -o $@ -c $^

%.o : %.s
	$(AS_ARM) $(CFLAGS) -g -o $@ -c $^

$(PROG1) : $(PROG1).o
	$(LD_ARM) $(LD_FLAGS) -T section.lds -g -o $@ $^

$(PROG2) : $(PROG2).o
	$(LD_ARM) $(LD_FLAGS) -T sections.lds -g -o $@ $^


OBJDUMP = /usr/bin/arm-linux-gnu-readelf

objdump :
	echo "OBJDUMP" > $(PROG1).dump
	$(OBJDUMP) -A $(PROG1) >> $(PROG1).dump
	$(OBJDUMP) -x .text $(PROG1) >> $(PROG1).dump
	$(OBJDUMP) -x .data $(PROG1) >> $(PROG1).dump
	echo "OBJDUMP" > $(PROG1).dump
	$(OBJDUMP) -A $(PROG2) >> $(PROG2).dump
	$(OBJDUMP) -x .text $(PROG2) >> $(PROG2).dump
	$(OBJDUMP) -x .data $(PROG2) >> $(PROG2).dump

.PHONY : all objdump
