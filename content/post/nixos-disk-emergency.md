---
title: "NixOS Disk Emergency"
date: 2022-09-27T11:40:42+02:00
draft: true
---

After gifting a new computer to my brother (a little SFF PC with a Ryzen 3400G and 32GB of DDR4 RAM) a while ago and moving all of his data to his new 1 TB NVMe SSD, I got to take care of his old computer.

I removed a 1 TB 3.5 inch HDD from his old case that he used for storage and took it with me. I wiped his data off of it and found out that 

sudo hdparm -tT /dev/sdd                                                                                 ~/dev/webpages/webpage-blog main

/dev/sdd:
 Timing cached reads:   23988 MB in  2.00 seconds = 12012.83 MB/sec
 Timing buffered disk reads: 636 MB in  3.01 seconds = 211.52 MB/sec
  
I want to give a shoutout and a big thank you to @julm@framapiaf.org for helping me recover my borked #NixOS install yesterday :nixos: 
I messed around with my disks and forgot to change my hardware config, so upon next reboot a disk  that I had already shredded, could not be mounted, and I ended up in systemd's emergency mode 
More on it in a rare post on my blog:
