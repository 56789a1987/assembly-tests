Load raw data from drive and display it as an image in VGA mode.

## QEMU start args

```sh
qemu-system-x86_64 -blockdev driver=file,node-name=f0,filename=/path/to/main.img -device floppy,drive-type=144,drive=f0
```

## Rebuild the image

- Install the python library `pillow` if you don't have it.
  ```sh
  pip install pillow
  ```
- Put your image in the current directory and name it `image.png`, the image size must be **320x200**.
- Go to `utils` directory and run the following command.
  ```sh
  python image.py
  ```
- The converted image will be saved as `image.bin`.
