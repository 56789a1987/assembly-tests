# x86 Assembly Testings

## Compile assembly scripts

- Install [NASM](https://www.nasm.us/) if you don't have it, and add it to PATH.

- Compile an assembly script to a boot image.
  ```sh
  nasm -o file.img file.asm
  ```

## Testing

Use a PC emulator

- For Virtual Box and VMware, mount the .img file to the floppy drive.

- For QEMU:
  ```sh
  qemu-system-x86_64 -drive file=/path/to/file.img,format=raw
  ```
  Some scripts require additional arguments.

## Other requirements

Some utils require [Python](https://www.python.org/) for processing source files.
