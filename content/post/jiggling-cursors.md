---
author: "totoroot"
title: "Jiggling Cursors"
date: "2023-03-22"
description: "Replicating something rare on my Linux machines - a thing I like about macOS"
categories:
tags: [
    "Linux",
    "macOS",
    "Cursor",
    "KDE",
    "Plasma",
    "KWin",
    "GNOME",
    "Accessibility"
]
slug: ""
image: "/jiggling-cursors/macos-cursor.png"
draft: false
---

# Jiggling cursors

I have to use macOS at work, whereas I prefer using Linux systems at home.

There are not many things I fancy about macOS, but one such thing is a feature that I have found to be very helpful at times. When you violently shake your cursor, or in other words, jiggle it, it grows in size, thereby making it a lot easier to locate.

This is documented in [Apple's official documentation](https://support.apple.com/en-in/guide/mac-help/mchlp2920/mac).


## Making a case for its usefulness

It would surprise me if you had never come into a situation, where you didn't know upon first glance where the cursor was on your screen. Even more so with displays getting bigger and screen resolutions getting higher.

I for one have lost my cursor on my ultrawide display plenty of times and even though I mainly navigate my operating system using the keyboard, I have not yet taken the plunge and switched to a web browser like [qutebrowser](https://www.qutebrowser.org/), which you can truly fully navigate using a keyboard.

> I've tried the browser extension [Surfingkeys](https://github.com/brookhong/Surfingkeys) on Firefox before, but couldn't really get the hang of it. Perhaps it is something you would like to try?

## Options on Linux

At the time of writing this, I'm mostly using KDE Plasma as a desktop environment on my Linux machines. On my main desktop computer, I've been using [Hyprland](https://hyprland.org/) since switching to Wayland, but am still considering trying out [Sway](https://swaywm.org/) or [River](https://github.com/riverwm/river) at one point.

For that reason I would like to find a solution that works for window managers as well, but as of now, these are the options I've found:

- For **KDE Plasma**, KWin already comes with functionality to highlight the cursor. I've found [this answer on StackExchange](https://unix.stackexchange.com/a/570608) to be a good explanation with helpful screenshots. Default configuration for activating the functionality seems to be pressing \<Ctrl\>+\<Meta\> and moving the mouse.

> I'm aware that this is not exactly the same as the feature on macOS, but it is similarly helpful. In [this thread on Reddit](https://www.reddit.com/r/kde/comments/k62cxr/shake_to_find_pointer_alternative_for_kde/) someone else was interested in replicating the macOS feature on KDE and another user suggested forking KWin and adding an alternative effect (e.g. growing cursor) to [the existing cursor effect](https://github.com/KDE/kwin/tree/master/src/effects/trackmouse). Maybe you would be interested in contributing exactly that?

- If you're running **GNOME**, you might want to give [this extension](https://github.com/jeffchannell/jiggle) a try.

I'll try and update this as soon as I find a solution for other desktop environments and window managers as well.

Cheers,\
Matthias

---

*Title image by [Caspar Camille Rubin](https://unsplash.com/@casparrubin?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/photos/fPkvU7RDmCo?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)*
