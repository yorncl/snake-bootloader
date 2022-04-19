NAME=snake-asm
SRC=snake.asm

QEMU=qemu-system-x86_64
AS=nasm
ASFLAGS= -f bin

all : $(NAME)

$(NAME): $(SRC)
	$(AS) $(ASFLAGS) $(SRC) -o $(NAME)

run: $(NAME)
	$(QEMU) -drive format=raw,file=$(NAME)

clean:
	$(RM) $(NAME) $(IMG)

re: clean all

.PHONY: all run clean re
