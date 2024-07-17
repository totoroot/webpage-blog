---

title: "Declarative and reproducible Homelab on NixOS ❄️"
enableMenu: true
enableChalkboard: false
enableTitleFooter: false
enableZoom: false
enableSearch: true
theme : "blood"
customTheme : "dracula"
transition: "slide"
highlightTheme: "simple"
logoImg: "assets/images/steirernix.svg"
slideNumber: false
separator: '^\r?\n---\r?\n$'
verticalSeparator: '^\r?\n----\r?\n$'
---

# Homelab on NixOS

#### Declarative and reproducible ❄️

<!-- Notes in standard format are currently rendered as regular text with evilz/vscode-reveal. This is a known bug (https://github.com/evilz/vscode-reveal/issues/295) and the following HTML tag can be used as a workaround. -->

<aside class="notes" data-markdown="">

After last year's great attendance at my introductory talk on Nix and NixOS, I thought I'd follow up with a more detailed explanation of how you can leverage NixOS for something that would otherwise be very tedious to set up.

Before I introduce myself, I would like to thank the organisers of the Grazer Linuxtage and everyone helping for once again making it possible for me to present something I and hopefully all of you are interested in.

</aside>

---

### Follow this live

<img data-src="assets/images/qrcode.svg" width=47%>

<a href="https://blog.thym.at/glt24">https://blog.thym.at/glt24</a>

<aside class="notes" data-markdown="">

You can follow the presentation live in your browser and go through the slides at your own pace. The slides will stay avaiable under this URL afterwards as well, so you can go through all of the mentioned resources whenever you feel ready to start your Nix journey.

</aside>

---

## Who am I?

- Student at Graz University of Technology 🎓
- DevOps Engineer/Automation Specialist at [smaXtec](https://smaxtec.com/en/) 🐄
- Linux Advocate and Avid User of FOSS 🐧
- Daily Driving NixOS since 2020 ❄️

---

## What is a homelab?

----

#### What is a homelab?

<aside class="notes" data-markdown="">

Firstly, a lab or laboratory is a place where you can safely do experiments. But not quite like this.

</aside>

<img data-src="assets/images/lab.jpg" width=70%>

Photo by <a href="https://unsplash.com/@nci?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">National Cancer Institute</a> on <a href="https://unsplash.com/photos/grayscale-photo-of-man-and-woman-inside-laboratory-gKT3ooTuS_w?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>

----

## What is a homelab?

<aside class="notes" data-markdown="">

Quick question. How many of you would say that they work in IT or a related field? Please raise your hands if you do.

Most of you will probably agree that playing with production equipment at work is not a good idea.

So many of us will opt to build a "production" environment at home, that becomes our lab. A enviroment we can safely do experiments in.

</aside>

----

#### What is a homelab?

<aside class="notes" data-markdown="">

In case you have never heard the term, homelab or home server is the name given to a server (or multiple server setup) that resides locally in your home and where you host several applications and virtualized systems for testing and developing or for home and functional usage.

It can be a repurposed professional server that you acquired from a company or university which discarded them due to their age but are still usable.

Of course this server can also be a Raspberry Pi or similar single board computer, a desktop tower or some small form factor PC.

Maybe all of that with some networking equipment like switches and stuff.

</aside>

<img data-src="assets/images/homelab-big.jpg" width=40%>
<img data-src="assets/images/homelab.jpg" width=40%>

----

#### What is a homelab?

<img data-src="assets/images/homelab-mini.jpg" width=80%>

----

#### What is a homelab?

<img data-src="assets/images/homelab-sizeable.jpg" width=80%>

---

## What is Nix? <img data-src="assets/images/nix-snowflake.png" width=10%>

Not to be confused with *nix

----

## What is Nix? <img data-src="assets/images/nix-snowflake.png" width=10%>

<aside class="notes" data-markdown="">

Last year I already held a talk at Linuxtage in which I tried to give an overview of all of these.

If you haven't seen that talk and are interested, the recording is still available on YouTube and on the Chaos Computer Clubs media server, where this years recordings will also be uploaded.

</aside>

- Nix Language
- Nix Package Manager
- Nix Package Library - Nixpkgs
- Nix Operating System - NixOS
- ...

---

## What is NixOS? <img data-src="assets/images/nix-snowflake.png" width=10%>

- Started as research project by Eeelco Dolstra in 2003
- Took off after first stable release branch in 2013 (13.10)
- Stable releases in May and November (e.g. Raccoon - 22.11)
- Receive bugfixes and security updates for 7 months


<aside class="notes" data-markdown="">

NixOS is a Linux distribution that has been around since 2003 and was started by Eelco Dolstra as a research project. The distribution only really took off after the first stable release in 2013.

On NixOS you can follow several different channels.

There is a stable release of NixOS twice a year in May and November, with a code name like Raccoon and a version number like 22.11 for the November release of 2022.

Every stable release will receive bugfixes and security updates for seven months.

After using stable channels for about a year, I have been using the unstable channel since then and have not really had problems, besides the occasional failing build.

While it is not recommended, it is also possible to directly follow the master branch of Nixpkgs.

It features atomic upgrades and rollbacks.

</aside>

----

## NixOS <img data-src="assets/images/nix-snowflake.png" width=10%>

```nix
services = {

  # Start a systemd service for each incoming SSH connection
  openssh.startWhenNeeded = true;

  # Enable periodic SSD TRIM to extend life of mounted SSDs
  fstrim.enable = true;

  # Suspend when power button is short-pressed
  logind.extraConfig = ''
    HandlePowerKey=suspend
  '';
};
```

<aside class="notes" data-markdown="">

NixOS relies heavily on systemd, but there is experimental support for other init systems.

</aside>


----

## Landing page <img data-src="assets/images/nix-snowflake.png" width=10%>

```nix
{ ... }:

{
  services.homepage-dashboard = {
    enable = true;
    listenPort = 8082;
  };
}
```

----

### Landing page <img data-src="assets/images/nix-snowflake.png" width=10%>

<img data-src="assets/images/homepage-dashboard-default.png" width=100%>

----

### Notifications <img data-src="assets/images/nix-snowflake.png" width=10%>

```nix
{ ... }:

let
  domain = "mydomain.at";
  ntfyPort = 6780;
  ntfyMetricsPort = 9095;
  ntfyHost = "notifications.${domain}";
in
{
  services.ntfy-sh = {
    enable = true;
    group = "ntfy";
    user = "ntfy";
    settings = {
      base-url = "https://${ntfyHost}";
      listen-http = ":${toString ntfyPort}";
      behind-proxy = true;
      auth-file = "/var/lib/ntfy/user.db";
      # cache-file = "/var/cache/ntfy/cache.db";
      attachment-cache-dir = "/var/cache/ntfy/attachments";
      auth-default-access = "deny-all";
      upstream-base-url = "https://ntfy.sh";
      # Set to "disable" to disable web UI
      # See https://github.com/binwiederhier/ntfy/issues/459
      web-root = "app";
      # Enable metrics endpoint for Prometheus
      enable-metrics = true;
      metrics-listen-http = ":${toString ntfyMetricsPort}";
    };
  };

  user.extraGroups = [ "ntfy" ];

  environment.systemPackages = [ services.ntfy-sh.package ];

  networking.firewall.allowedTCPPorts = [ ntfyPort ];
}
```

----

#### Notifications <img data-src="assets/images/nix-snowflake.png" width=10%>

<img data-src="assets/images/ntfy.png" width=60%>

----

#### Notifications <img data-src="assets/images/nix-snowflake.png" width=10%>

<img data-src="assets/images/notification.png" width=85%>

----

#### Home Assistant

```nix
{ ... }:

let
  port = 7901;
  version = "2023.12.2";
in
{
  virtualisation.oci-containers.containers = {
    home-assistant = {
      image = "ghcr.io/home-assistant/home-assistant:${version}";
      volumes = [
        "/var/lib/home-assistant:/config"
        "/etc/localtime:/etc/localtime:ro"
      ];
      extraOptions = [
        "--device=/dev/ttyUSB0"
        "--network=host"
      ];
      ports = [
        "${toString port}:${toString port}"
      ];
      autoStart = true;
    };
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ port ];}
```

----

#### Home Assistant

<img data-src="assets/images/home-assistant-dashboard.png" width=100%>

---

## Some service modules

<img data-src="assets/images/logos/homeassistant.svg" width=9%>
<img data-src="assets/images/logos/esphome.svg" width=9%>
<img data-src="assets/images/logos/jellyfin.svg" width=9%>
<img data-src="assets/images/logos/uptimekuma.svg" width=9%>
<img data-src="assets/images/logos/adguard.svg" width=9%>
<img data-src="assets/images/logos/pihole.svg" width=9%>
<img data-src="assets/images/logos/prometheus.svg" width=9%>
<img data-src="assets/images/logos/grafana.svg" width=9%>
<img data-src="assets/images/logos/vaultwarden.svg" width=9%>
<img data-src="assets/images/logos/gitlab.svg" width=9%>
<img data-src="assets/images/logos/gitea.svg" width=9%>
<img data-src="assets/images/logos/forgejo.svg" width=9%>
<img data-src="assets/images/logos/influxdb.svg" width=9%>
<img data-src="assets/images/logos/transmission.svg" width=9%>
<img data-src="assets/images/logos/radarr.svg" width=9%>
<img data-src="assets/images/logos/wireguard.svg" width=9%>
<img data-src="assets/images/logos/nginx.svg" width=9%>
<img data-src="assets/images/logos/nginxproxymanager.svg" width=9%>
<img data-src="assets/images/logos/caddy.svg" width=9%>
<img data-src="assets/images/logos/traefikproxy.svg" width=9%>
<img data-src="assets/images/logos/minecraft.svg" width=9%>

---

### NixOS User Group Austria

<a class="navigate-right">
    <img data-src="assets/images/qrcode-nixos-at.svg" width=40%>
</a>

<a href="https://nixos.at">https://nixos.at</a>

----

### NixOS User Group Austria

<a class="navigate-right">
    <img data-src="assets/images/website-screenshot.png" width=80%>
</a>


----

### NixOS User Group Austria

<a class="navigate-right">
    <img data-src="assets/images/next-meetup.png" width=80%>
</a>

----

### Mentioned Resources

- [My modular, messy NixOS configuration](https://codeberg.org/totoroot/dotfiles)
- [Awesome Self-Hosted](https://github.com/awesome-selfhosted/awesome-selfhosted) - Community-maintained list of Free Software network services and web applications which can be hosted on your own servers
- [Awesome Nix](https://nix-community.github.io/awesome-nix/) - Community-maintained link list with helpful resources

---

### Attributions

- Image of mini homelab of Reddit user buster072 - [Reddit](https://www.reddit.com/r/homelab/comments/acuija/my_mini_homelab_with_a_synology_disk_station_and/)
- Image of sizeable homelab of Reddit user lusid1 - [Reddit](https://www.reddit.com/r/homelab/comments/cig23v/the_little_homelab_under_my_desk_2019_edition/)
- Image of large homelab of Reddit user JaredBanyard - [Reddit](https://www.reddit.com/r/homelab/comments/f59oi0/homelab_cubed/)
- Image of production-grade "homelab" - [EPM](https://www.epmmarshall.com/homelab-intro/)
- Brand Logos - [Simple Icons](https://simpleicons.org/)

---

# Thanks!

curl -sL [https://matthias.thym.at](https://matthias.thym.at)/card \
\
[https://blog.thym.at/p/glt24](https://blog.thym.at/p/glt24/)

