# snake-bootloader

A snake game running from a x86 bootloader.
The code is under 256 bytes long.

## Demo

![](https://github.com/yorncl/snake-bootloader/blob/master/meta/snake-asm.gif)

### Build

You will need make and nasm to build the binary.

Just run `make`. It will produce a raw binary.

### Running it

You can run it using qemu or on real hardware.

#### Qemu
If you have `qemu-system-x86_64` installed, just hit `make run`.

If this command doesn't work, you will need to manually specify the drive containing the compiled binary and indicate that it is in raw format to QEMU.

#### Real hardware

(WARNING : I haven't tested it further for now, it might break, I recommend using qemu)

You can use `dd` to burn it on your usb, like so :

`dd if=./snake-asm of=/dev/yourusb bs=256`

It will erase the first 256 bytes of your key.
Your usb key should be bootable after that.
