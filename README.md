<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/adilhtepe/sotto/main/brand/sotto-logo-dark.svg">
    <img alt="Sotto" src="https://raw.githubusercontent.com/adilhtepe/sotto/main/brand/sotto-logo.svg" height="72">
  </picture>
</p>

# Sotto

**VBAN audio, sotto voce.** An open toolkit for the VBAN network audio protocol:
- a zero-allocation C SDK;
- players and virtual sound cards for Linux, Windows and macOS;
- an Android library;
- an OpenWrt hub that routes audio, including securely over the internet.

This repository ties the project together. Each part lives in its own repository and is included
here as a submodule:

| Path | Repository | What it is |
|---|---|---|
| `sdk/` | `sotto-sdk` | C99 SDK: protocol, lock-free jitter buffer, mixer, secure VBAN (Noise + ChaCha20-Poly1305), tests |
| `app/` | `sotto-app` | `sotto`: VBAN to and from any sound device on Windows, macOS and Linux |
| `linux/` | `sotto-linux` | `snd-vban` ALSA kernel sound card, and "Sotto in" / "Sotto out" on PipeWire |
| `windows/` | `sotto-windows` | "Sotto out" virtual sound card for Windows (Scream-based driver) |
| `macos/` | `sotto-macos` | "Sotto Out" / "Sotto In" virtual devices for macOS (CoreAudio plug-in) |
| `android/` | `sotto-android` | Kotlin library for Android apps |
| `hub/` | `sotto-hub` | OpenWrt hub: routing, volume, LuCI, secure VBAN CA, eBPF fast path, internet access |
| `site/` | (here) | The website, published with GitHub Pages |

```bash
git clone --recursive <url of this repository>
```

## How the pieces fit
- **The SDK is the core.** The app, the Linux card, the Android library and the hub all build it
  from their own `sdk` submodule. A fix in the SDK reaches them when their submodule is updated.
- **Devices to the hub.** Devices talk plain VBAN on a trusted LAN. Anywhere else, including the
  internet, they use secure VBAN with certificates from the hub's CA.
- **Bridging.** The hub sends plain VBAN to Voicemeeter and other plain receivers, so nothing
  existing breaks.

## Builds
Each repository builds on GitHub Actions:

| Repository | What CI does |
|---|---|
| SDK | 2 Linux, 2 macOS and 4 Windows toolchains, MinGW, ESP-IDF and Arduino |
| App | Linux, macOS and Windows, with a UDP smoke test |
| Linux | Kernel module; a VM test of the module; PipeWire against a real daemon |
| Windows | The driver, with the WDK |
| macOS | The plug-in, loaded into CoreAudio on the runner |
| Android | JVM tests and the release AAR |
| Hub | Daemon, eBPF, Python and LuCI tests |

This repository checks that everything resolves together and publishes the website.

## Acknowledgements
See [ACKNOWLEDGEMENTS.md](ACKNOWLEDGEMENTS.md): VB-Audio for VBAN, the open-source VBAN
implementations we learned from, Monocypher, miniaudio, Scream, the Noise Protocol Framework, and
the tools that made testing possible. Sotto is not affiliated with VB-Audio.
