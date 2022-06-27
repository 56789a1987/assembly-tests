Play a song using PC speaker

## QEMU start args

```sh
qemu-system-x86_64 -soundhw pcspk -drive file=/path/to/file.img,format=raw 
```

## Rebuild the song data

- Go to `utils` directory and run the following command.
  ```sh
  python song.py
  ```
- The converted song will be saved as `song.bin`.

The MIDI convertor binaries are from [craigsapp/midifile](https://github.com/craigsapp/midifile)
