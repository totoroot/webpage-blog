---
title: "Backing up data on an Android device"
date: 2022-11-05T11:29:22+01:00
draft: true
---

# Preparing the ground

This week I wiped MIUI off my daily driver smartphone, a Xiaomi Redmi Note 7, and installed LineageOS.

To install a custom ROM like LineageOS (other well-known examples are [Ubuntu Touch](https://ubuntu-touch.io/), [/e/OS](https://e.foundation/e-os/) or [LineageOS for microG](https://lineage.microg.org/)), you need to unlock the phone's bootloader. Depending on the maker and model of your smartphone, this can be a rather tedious process, or straightforward and not take long.

Since all user data is gone and the Xiaomi smartphone gets reset to factory default settings, once you unlock your booloader, before deciding to do so, one should back up all data.

# Backing up

Even though I use [Nextcloud](https://nextcloud.com/athome/) and [Syncthing](https://syncthing.net/) to synchronize a lot of my phone's data to my desktop PC and server to back it up regularly, I wanted to make sure that I had backed up absolutely everything before wiping my device.

For backing up my user data, contact and apps, I found a rather elegant solution that did not involve uploading any of my data to a cloud provider.
I discovered this [wonderful tool on GitHub](https://github.com/mrrfv/linux-android-backup/), which automated a lot of what I thought I would have to do manually.

The use of the tool was rather straightforward and in my case worked exactly how the README described it. The most difficult part was getting the phone to play nice, by giving the necessary permissions and allowing all the [ADB](https://developer.android.com/studio/command-line/adb) commands to access and control the phone from the computer.

## What are ADB and Fastboot?

ADB and fastboot are two components of the Android SDK Platform-Tools.

ADB stands for Android Debug Bridge. It’s a command-line utility that allows you to do the following stuff:

- Control your Android device over USB from your computer
- Copy files back and forth
- Install and uninstall apps
- Run shell commands
- and much more

Fastboot is a command-line tool for flashing a recovery image or a custom ROM to an Android device, boot an Android device to fastboot mode, etc…

## Installing the tooling

Since my NixOS desktop did not recognize my Android phone for whatever reason, I did not want to spend a lot of time troubleshooting and opted for backing up to my Kubuntu notebook.

I had to install the ADB packages with the following command:

```
sudo apt install android-tools-adb android-tools-fastboot
```

For creating the backup only `android-tools-adb` was needed, but since I wanted to flash a custom ROM later, I opted for installing `android-tools-fastboot` right away as well.

Since enabling ADB control smartphone is dependent on the OS, and is therefore a device-specific process, I will not go into more details. Search for "enable ADB debugging" followed by the brand name of your phone's maker (e.g. Xiaomi) or the name of your phone's OS (e.g. MIUI) to get instructions for your OS.

For Xiaomi devices [this](https://help.airdroid.com/hc/en-us/articles/360045329413-How-to-Enable-USB-debugging-on-Xiaomi-) is a good guide.

## Unlocking the bootloader

I won't go into detail how to unlock the bootloader, as I want to focus on backing up and restoring data, but I found this [guide for unlocking the bootloader on Xiaomi phones](https://www.guidetoroot.com/unlock-bootloader-on-any-xiaomi-phones/) helpful.

had two more recent #Signal backup files from my old phone with all my chats and their attachments.
The files both had 7.7GiB and contained over 20.000 messages.
I've been using Signal since 2014/15. I had to disable the automatic backups, since the backup functionality is properly broken in many ways.
