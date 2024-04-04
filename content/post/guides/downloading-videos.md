---
author: "totoroot"
title: "Downloading videos (the hard way)"
date: "2024-04-03"
description: "How to download videos that don't want to be downloaded"
categories: "Guides"
tags: [
    "Linux",
    "yt-dlp",
    "Videos",
    "Downloading",
    "Archiving"
]
slug: "downloading-videos"
image: ""
draft: false
---

# Downloading videos

Sometimes you wish to download videos that do not want to be downloaded.
Now, I'm not talking about the ones with loads of nudity, but mainly videos that are embedded on a page that is not public.

My partner does a lot of online video courses, that she only has a certain time to watch.
Sometimes she can't watch them in time and asks me whether I can download them, even though they can't easily be downloaded.

That means that the videos cannot just be saved to a device, by right-clicking the player and clicking "Save Video As...".

## Basic tips

For some videos, the right click is simply disabled.
That is possibly the easiest obstacle to overcome. Try holding down `<Ctrl>` when right-clicking.
This should open up the default context menu of your browser. If the option to save the video is not greyed out, than save the video.

If it was not that easy, my next go to option is `yt-dlp`, a well-maintained and feature-rich fork of the well-known `youtube-dl`.

Installation and usage instructions can be found on [the project's GitHub page](https://github.com/yt-dlp/yt-dlp).

If `yt-dlp` does not manage to download the video, do not despair.
However, the effort required to download the video, will only increase.

## Downloading videos from an embedded player (e.g. Vimeo)

For most players, even Vimeo, `yt-dlp` should do just fine for all public videos.

Especially for the embedded Vimeo player, videos are often private, which means that `yt-dlp` might not be able to download them as the video links only load when providing the associated token.

[Credit to StackExchange user Stefan_Fairphone](https://superuser.com/a/1822604)

Vimeo serves video and audio separately and in chunks. The URLs seem to contain short-lived tokens that are only available to you when you are authorized to view the video.

**Follow these instructions:**

1. Go to the Network tab of your browser's Developer Tools
1. Hit the play button
1. Search the network log for video and audio
1. Get the respective URLs* and strip away the query parameters, e.g. `https://6vod-adaptive.akamaized.net/.../parcel/video/466552c7.mp4`
1. Download video and audio (e.g. using `curl <URL> -O <audio|video>.mp4`)
1. Merge video and audio with `ffmpeg -i video.mp4 -i audio.mp4 -c copy output.mp4`

![Screenshot of the Network tab in Firefox's Developer Tools, highlighting the most often occurring file](https://i.stack.imgur.com/X92O0.png "Screenshot Network tab")

* Often, don't use the very first URL that appears, but the file that appears most often (i.e. `466552c7.mp4` in the screenshot above). The URLs correspond to the video resolution and the player will adjust it to your network connection.

## Downloading heavily segmented videos

[Credit to Reddit user ChrisWolfTravels](https://www.reddit.com/r/ffmpeg/comments/sigacg/comment/k970jef)

 The segmentation of videos into smaller chunks is a common technique used in adaptive streaming technologies like HLS (HTTP Live Streaming) and DASH (Dynamic Adaptive Streaming over HTTP). The purpose of this segmentation is to adapt the video quality dynamically based on the user's internet speed, ensuring smooth playback.

### Locating the master playlist file

There is a master playlist file that lists all available media files, corresponding to a different quality level of the video. These playlists contain the URIs of the segmented media files (.ts files in your case) along with their sequence and duration.

You need to find the appropriate playlist file that references all these segments. Typically, this would be a file with the `m3u8` file extension.

**Here’s how you can locate it:**

1. Open the Web Inspector in your browser while on the video page.
  In Firefox, you should be able to do this by hitting `<Ctrl>` + `<Shift>` + `<i>`.

1. Navigate to the Network Tab.

1. Play the Video to start loading the content.

1. Look for Files with the .m3u8 Extension. There might be several such files, so you might need to inspect a few. The one you're looking for will have entries pointing to the various .ts segment files. If you do not see the file and only see .ts files, refresh the webpage.

#### Example URL of a master playlist file of this type of player

`https://player02.getcourse.ru/player/<hash>/<hash>/media/480.m3u8?sid=&user-cdn=cdnvideo&version=10:2:1:0:cdnvideo&user-id=<numerical-id>&jwt=<json-web-token>`

1. Next, download the playlist file. I used `curl` for that.

```sh
curl -O "https://player02.getcourse.ru/player/<hash>/<hash>/media/480.m3u8?sid=&user-cdn=cdnvideo&version=10:2:1:0:cdnvideo&user-id=<numerical-id>&jwt=<json-web-token>"
```

Don't forget the double quotes, so that characters like `&` don't cause problems.

### Slowly downloading everything with `ffmpeg`

The Reddit comment mentioned above, suggested the following method, but I found it to be to slow, so I opted for something else explained below.

```sh
ffmpeg -protocol_whitelist file,https,tcp,tls,crypto -i "480.m3u8" -c copy output.mp4
```

This command tells `ffmpeg` to read the input from the HLS playlist and copy the codecs (-c copy) into an output file (output.mp4). Note that I needed to whitelist https.

### Quickly(er) downloading all video segments using `curl`

#### Modifying the master playlist file

This it how the master playlist file looked for my video.
Depending on the video length, this file might be quite long.

```m3u8
#EXTM3U
#EXT-X-TARGETDURATION:4
#EXT-X-ALLOW-CACHE:YES
#EXT-X-VERSION:3
#EXT-X-MEDIA-SEQUENCE:0
#EXT-X-PLAYLIST-TYPE:VOD

#EXTINF:3.000000,
https://qonv2yv2zi.a.trbcdn.net/sch/<hash>/<hash>/480/0.ts?host=vh-78&version=2&uid=<uid>&aid=<aid>&j=<jwt>&s=<hash>
.
.
.
#EXTINF:3.000000,
https://qonv2yv2zi.a.trbcdn.net/sch/<hash>/<hash>/480/3487.ts?host=vh-78&version=2&uid=<uid>&aid=<aid>&j=<jwt>&s=<hash>
#EXTINF:2.600000,
https://qonv2yv2zi.a.trbcdn.net/sch/<hash>/<hash>/480/3488.ts?host=vh-78&version=2&uid=<uid>&aid=<aid>&j=<jwt>&s=<hash>

#EXT-X-ENDLIST
```

We only need the URLs so it's time for some `sed` wizardry!!

One method could be to extract all lines that start with something like `https` (very useful in this case).

```sh
sed -n '/^https.*/p' 480.m3u8 > urls.txt
```

Another option to extract every second line could be

```sh
sed -n '0~2!p' 480.m3u8 > urls.txt
```

Of course `sed` can modify files in place, by supplying the `-i` argument, but even a `sed` wizard is fallible and might want to use some safeguards.

#### Actually downloading video segments using `curl`

Every URL corresponds to a video file only a couple seconds long, with the file ending `.ts`, so it might be a good idea to create a temporary directory to not pollute the current working directory.

```sh
mkdir -p segments && cd segments
xargs -n 1 curl -O < ../480.m3u8
```

#### Watching the download progress

I case I have to download longer videos (the last two were around 3 hours long), I like to watch the progress of the downloads.

I like to use [viddy](https://github.com/sachaos/viddy), a modern watch command, to watch the progress of files being downloaded as it allows me to see easily see what changed with highlighting.
It also has many other awesome features so check it out.

In another terminal tab or window run:

```sh
viddy -d -n "10s" "ls -1rv"
```

The video files should be numerically sorted, so the download progress should be easy to follow.

Of course, you can also just wait for the `curl` command to finish and then check on the results if you're more of a patient kind than I am.

### Listing files before merging

Now we need a list of all files as an input for `ffmpeg`.

```sh
for f in *.ts(n); do echo "file '$f'" >> segments.txt; done
```

Use [`zsh`'s glob qualifiers](https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers) to list all downloaded segments in a text file named `segments.txt`.

We use `*.ts(n)` to glob all files ending on `.ts` numerically.

`(n)` is the glob qualifier for sorting decimal integers numerically in `zsh`.

### Sanity checking the resulting list

```sh
wc -l segments.txt
cat segments.txt
tac segments.txt
```

I wanted to mention this here, since I often forget `tac` exists and it can be quite useful.

### Merging video segments

```sh
ffmpeg -f concat -i segments.txt -c copy video.mp4
```

Do not forget to check the video for errors once you are done.
