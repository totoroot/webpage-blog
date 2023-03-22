---
title: "OPNV Graz"
author: "totoroot"
description: Public Transport Map Graz
date: 2022-01-13
categories: Maps
tags: [
    "Mapping",
    "OSM",
    "OpenStreetMap",
    "Leaflet"
]
image: "/opnv-map.png"
draft: false
---

This embedded [Leaflet](https://leafletjs.com/) map as well as the markers were added by using [HUGO shortcodes](https://gohugo.io/content-management/shortcodes/). Displayed is the [OPNV layer](https://tileserver.memomaps.de/) created by [MeMoMaps](https://memomaps.de/en/homepage/) from [leaflet-providers](https://leaflet-extras.github.io/leaflet-providers/preview/).

{{< leaflet-loader >}}

{{< leaflet-opnv mapHeight="600px" mapWidth="100%" mapLat="47.07878" mapLon="15.42719">}}

{{< leaflet-marker markerLat="47.0760986" markerLon="15.4367620" markerContent="Schloßbergbahn Bergstation">}}

{{< /leaflet-opnv >}}
