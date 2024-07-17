---

title: "Securely access your home server from anywhere"
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

# Secure access

<!-- Notes in standard format are currently rendered as regular text with evilz/vscode-reveal. This is a known bug (https://github.com/evilz/vscode-reveal/issues/295) and the following HTML tag can be used as a workaround. -->

<aside class="notes" data-markdown="">

In full this lightning talk's title is "Securely access your home server from anywhere".

</aside>

---

### Follow this live

<img data-src="assets/images/qrcode-lightning.svg" width=47%>

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

## Conventional Setup

<img data-src="assets/images/conventional-networking-setup-upscaled.png" width=77%>

<aside class="notes" data-markdown="">

This is a conventional setup like many of you might have at home. Nowadays in many cases the modem and router will be one box provided to you by your internet service provider.

Perhaps it's a FRITZ!Box with a fibre optic connector or a standard DSL/ADSL modem connected via a good ol' copper cable.

Quick question. How many of you have a static public IP at home?

Many people use dynamic DNS solutions like DuckDNS to forward traffic to their router and then forward individual ports to their servers or other devices.

</aside>

----

### Issues with Conventional Setup

- Dynamic DNS not the most reliable
- **Exposed port(s) on home network** 👀

<aside class="notes" data-markdown="">

This setup is somewhat insecure as you would typically have have an open port on a device in your home network.

That might not be a problem for many years, until it suddenly becomes one, as that port could randomly become a target of some bad actor.

</aside>

---

<img data-src="assets/images/port-forwarding.png" width=35%>

---

## Improved setup

<img data-src="assets/images/proposed-networking-setup-upscaled.png" width=77%>

----

### Issues with Conventional Setup

- WireGuard can be difficult to setup and manage
  - Key distribution for all nodes
  - NAT Traversal and Firewall Exceptions

---

## Proposed Setup

- Small rented VPS with public IP
- WireGuard data plane
- Tailscale clients (most platforms)
- Headscale coordination server on VPS
- Reverse proxy on VPS

---

### Rented VPS with public IP <img data-src="assets/images/netcup-logo.png" width=15%>

<img data-src="assets/images/netcup-1.png" width=20%>
<img data-src="assets/images/netcup-2.png" width=35%>

<aside class="notes" data-markdown="">
- Small rented VPS with public IP
- WireGuard data plane
- Tailscale clients (most platforms)
- Headscale coordination server on VPS
- Reverse proxy on VPS
</aside>

---

### WireGuard data plane

<img data-src="assets/images/wireguard.jpg" width=77%>

<aside class="notes" data-markdown="">
- Small rented VPS with public IP
- WireGuard data plane
- Tailscale clients (most platforms)
- Headscale coordination server on VPS
- Reverse proxy on VPS
</aside>

----

### WireGuard data plane

<img data-src="assets/images/vpn-mesh.svg" width=77%>

<aside class="notes" data-markdown="">
- Small rented VPS with public IP
- WireGuard data plane
- Tailscale clients (most platforms)
- Headscale coordination server on VPS
- Reverse proxy on VPS
</aside>

---

### Tailscale clients

<img data-src="assets/images/coordination-server.svg" width=77%>

<aside class="notes" data-markdown="">
- Small rented VPS with public IP
- WireGuard data plane
- Tailscale clients (most platforms)
- Headscale coordination server on VPS
- Reverse proxy on VPS
</aside>

---

### Headscale coordination server

<img data-src="assets/images/headscale.png" width=77%>

<aside class="notes" data-markdown="">
- Small rented VPS with public IP
- WireGuard data plane
- Tailscale clients (most platforms)
- Headscale coordination server on VPS
- Reverse proxy on VPS
</aside>

---

### Reverse Proxy

<img data-src="assets/images/reverse-proxy.png" width=77%>

<aside class="notes" data-markdown="">
- Small rented VPS with public IP
- WireGuard data plane
- Tailscale clients (most platforms)
- Headscale coordination server on VPS
- Reverse proxy on VPS
</aside>

----

### Reverse Proxy Options

- [Caddy](https://caddyserver.com/)
- [Træfik](https://doc.traefik.io/traefik/)
- [Nginx](https://nginx.org/en/)
- [Nginx Proxy Manager](https://nginxproxymanager.com/)
- [frp](https://github.com/fatedier/frp)

---

### Mentioned Resources

- [Blog post from Paritosh Bhatia](https://paritoshbh.me/blog/tailscale-my-homelab-and-need-for-securing-home-network)
- [WireGuard](https://www.wireguard.com/) - Fast, Modern, Secure VPN Tunnel
- [Tailscale Blog](https://tailscale.com/blog/how-tailscale-works) - Blog post "How Tailscale works"
- [Tailscale Client](https://github.com/tailscale/tailscale) - Tailscale GitHub repository
- [Headscale](https://headscale.net/) - Open source, self-hosted implementation of the Tailscale control server

---

### Attributions

- Network diagrams from Paritosh Bhatia - [Blog post](https://paritoshbh.me/blog/tailscale-my-homelab-and-need-for-securing-home-network
)
- Port-forwarding diagram - [Blog post](https://ash.ms/2022/10/03/a-self-hosters-guide-to-port-forwarding-and-ssh-tunnels/)
- Reverse proxy diagram - [Blog post](https://securityboulevard.com/2023/04/what-is-reverse-proxy-how-does-it-works-and-what-are-its-benefits/)

---

# Thanks!

curl -sL [https://matthias.thym.at](https://matthias.thym.at)/card \
\
[https://blog.thym.at/p/glt24](https://blog.thym.at/p/glt24/)
