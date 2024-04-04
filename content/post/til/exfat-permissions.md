---
title: "exFAT has no file permissions"
date: 2023-04-26T12:25:26+02:00
draft: true
---

# exFAT has no file permissions

For copying things on my filesystem I like to use `rsync`. Using the right flags, it is just more reliable than the standard utility `cp` and has useful features like copying to another machine via SSH.

I even have `cp` aliased to `rsync -avz`.

According to `rsync`'s manual page, this does the following:

> This would recursively transfer all files from the directory src/bar on the machine foo into the /data/tmp/bar directory on the local machine. The files are transferred in archive mode, which ensures that symbolic links, devices, attributes, permissions, ownerships, etc. are preserved in the transfer. Additionally, compression will be used to reduce the size of data portions of the transfer.

Today I attached an external disk to my machine, that I use to transfer data between my work notebook running macOS to my private machines.
Since disks formatted to `ext4` are not supported by macOS, I formatted the disk to the `exFAT` file system.


