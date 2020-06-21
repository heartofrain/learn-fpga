.include "femtorv32.inc"
	
#################################################################################	
# NanoRv UART support
#################################################################################

.global	UART_putchar
.type	UART_putchar, @function
UART_putchar:
        sw a0,IO_UART_DATA(gp)
pcrx:	lw t0,IO_UART_CNTL(gp)
	andi t0,t0,512 # bit 9 = busy
	bnez t0,pcrx
	ret

.global	UART_getchar
.type	UART_getchar, @function
UART_getchar:
        lw a0,IO_UART_CNTL(gp)
	andi a0,a0,256 # bit 8 = data ready
        beqz a0,UART_getchar
        lw a0,IO_UART_DATA(gp)
	li t0, 10                  # <enter> generates CR/LF, we ignore LF.
	beq a0, t0, UART_getchar
        ret 

