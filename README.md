# JavaCard Compiler and Flasher
Contained are 2 dockerfiles:
- `jcc/` contains the dockerfile for compiling JavaCard applets. Contained in the directory is also a small example cardlet.
- `jcflash/` contains the dockerfile for flashing a compiled cardlet onto a Sysmocom card. It may also work with other cards but I only tested this with a [sysmoISIM-SJA2](https://osmocom.org/projects/cellular-infrastructure/wiki/SysmoISIM-SJA2).

## Building the Images
1. `pushd .;`.
2. `cd ./jcc;`.
3. `docker build --progress=plain . -t tomasz-lisowski/jcc:1.1.0;`.
4. `popd;`
5. `pushd .;`
6. `cd ./jcflash;`.
7. `docker build --progress=plain . -t tomasz-lisowski/jcflash:1.0.0;`;
8. `popd;`

## Using the Images
- Compile with: `docker run -v <path_to_project>:/opt/main --tty --interactive --rm tomasz-lisowski/jcc:1.1.0;`.
- Flash with: `docker run --device=/dev/bus/usb/<usb_reader_path> --volume=<path_to_folder_with_cap_files>:/opt/main --tty --interactive --rm tomasz-lisowski/jcflash:1.0.0;`.

### Example
1. `docker run -v ./jcc/example:/opt/main --tty --interactive --rm tomasz-lisowski/jcc:1.1.0;`.
2. `docker run --device=/dev/bus/usb/001/007 --volume=./jcc/example/dist:/opt/main --tty --interactive --rm tomasz-lisowski/jcflash:1.0.0 install 0 3F6E30F32E6168FB5D79A9FD1049B8FA 5B62305BAFF239028F2B66CE4B7E5210 MyCardlet.cap F1935711CCCCCCCC F1935711CCCCCCCC 00FF 00FF 1 13 FF;`.
3. `docker run --device=/dev/bus/usb/001/007 --tty --interactive --rm tomasz-lisowski/jcflash:1.0.0 list 0 3F6E30F32E6168FB5D79A9FD1049B8FA 5B62305BAFF239028F2B66CE4B7E5210;`.
4. `docker run --device=/dev/bus/usb/001/007 --tty --interactive --rm tomasz-lisowski/jcflash:1.0.0 delete 0 3F6E30F32E6168FB5D79A9FD1049B8FA 5B62305BAFF239028F2B66CE4B7E5210 F1935711CC;`.

**IMPORTANT: The module AID passed to the delete operation must not include the instance AID (in this case instance AID is `CCCCCC`), but when passing the module AID to the install operation, the instance AID must be included. Using our example: `F1935711CCCCCCCC` for installing vs. `F1935711CC` for deleting.**

*The above KIC and KID values are just realistic-looking examples, but they do not come from any real card.*

## USB Reader Path
You can use a utility like `lsusb` to check the USB device path for your reader.
