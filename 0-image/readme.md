Load raw data from drive and display it as an image in VGA mode

## Testing

Use a PC emulator

- For Virtual Box and VMware, mount the .img file to the floppy drive

- For QEMU:
  ```sh
  qemu-system-x86_64 -blockdev driver=file,node-name=f0,filename=/path/to/main.img -device floppy,drive-type=144,drive=f0
  ```

## Compile the binary

- Install [NASM](https://www.nasm.us/) if you don't have it, and add it to PATH
- Run the following command
  ```sh
  nasm -o main.img main.asm
  ```
- The compiled binary will be saved as `main.img`

## Replace the image

- Install [Python](https://www.python.org/) if you don't have it
- Install the python library `pillow` if you don't have it
  ```sh
  pip install pillow
  ```
- Put your image in the current directory and name it `image.png`, the image size must be **320x200**
- Run the following command
  ```sh
  python image.py
  ```
- The converted image will be saved as `image.bin`
