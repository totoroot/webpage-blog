---
title: "exFAT has no file permissions"
date: 2023-04-26T12:25:26+02:00
draft: false
description: "exFAT has no file permission and how to use rsync"
categories: TIL
tags: [
    "Drives",
    "exFAT",
    "File Systems",
    "rsync",
    "Archiving",
    "Permissions"
]
slug: "exfat-rsync"
---

# exFAT has no file permissions

For copying things on my filesystem I like to use `rsync`. Using the right flags, it is just more reliable than the standard utility `cp` and has useful features like copying to another machine via SSH.

I even have `cp` aliased to `rsync -avz`.

According to `rsync`'s manual page, this does the following:

> This would recursively transfer all files from the directory src/bar on the machine foo into the /data/tmp/bar directory on the local machine. The files are transferred in archive mode, which ensures that symbolic links, devices, attributes, permissions, ownerships, etc. are preserved in the transfer. Additionally, compression will be used to reduce the size of data portions of the transfer.

## The problem

Today I attached an external disk to my machine, that I use to transfer data between my work notebook running macOS to my private machines.
Since disks formatted to `ext4` are not supported by macOS, I formatted the disk to the `exFAT` file system.

When transferring my data, I noticed that all my files now had changed permissions. On the external hard drive they were all showing up as `777`. Turns out, this is by design.

exFAT, as an extension of FAT, is not capable of storing access control metadata. The file system itself therefore does not have the concepts of permissions, owners and groups.

This is why all the files on an exFAT volume appear to be 777 permissions. It's basically saying "this volume is wide-open, because we can't not make it wide-open due to the file system format".

Don't believe me? Try running `chown` on a file stored on an exFAT-formatted drive.

## The fix

So when trying to sync files to an exFAT drive using `rsync`, instead of `-avz`, use `-rltDvz`;

**What does `-avz` do?**

```
--archive, -a            archive mode is -rlptgoD (no -A,-X,-U,-N,-H)
--verbose, -v            increase verbosity
--compress, -z           compress file data during the transfer
```

```
--recursive, -r          recurse into directories
--links, -l              copy symlinks as symlinks
--perms, -p              preserve permissions
--times, -t              preserve modification times
--group, -g              preserve group
--owner, -o              preserve owner (super-user only)
-D                       same as --devices --specials
```

**What does `-rltDvz` do?**

`
--recursive, -r          recurse into directories
--links, -l              copy symlinks as symlinks
--times, -t              preserve modification times
-D                       same as --devices --specials
--verbose, -v            increase verbosity
--compress, -z           compress file data during the transfer
`
