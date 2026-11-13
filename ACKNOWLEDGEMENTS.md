# Acknowledgements

Sotto stands on other people's work. Thank you to all of them.

**The protocol**
- **VB-Audio Software** (Vincent Burel) designed VBAN and publishes its specification:
  [VBANProtocol_Specifications.pdf](https://vb-audio.com/Voicemeeter/VBANProtocol_Specifications.pdf).
  VBAN and Voicemeeter are VB-Audio's. Sotto is an independent implementation and is not affiliated
  with or endorsed by VB-Audio.

**Implementations we studied** (how real devices behave where the specification is silent)
- [quiniouben/vban](https://github.com/quiniouben/vban)
- [rkinnett/ESP32-VBAN-Network-Audio-Player](https://github.com/rkinnett/ESP32-VBAN-Network-Audio-Player)
- [norihiro/vst3-vban](https://github.com/norihiro/vst3-vban)
- [Orizine/ESP32-VBAN-2-WAY](https://github.com/Orizine/ESP32-VBAN-2-WAY)
- [VBAN-manager/VBAN-Wolfson](https://github.com/VBAN-manager/VBAN-Wolfson) and
  [VBAN-manager/VBAN-Manager](https://github.com/VBAN-manager/VBAN-Manager)
- and the other VBAN projects on GitHub, including thib3113/vban, vban-cmd and VBAN-Key

**Code we include, unmodified, under its own license**
- [Monocypher](https://monocypher.org) by Loup Vaillant, Michael Savage and Fabio Scotoni
  (BSD-2-Clause or CC0): all the cryptography in secure VBAN.
- [miniaudio](https://miniaud.io) by David Reid (public domain or MIT-0): the audio device layer
  of the `sotto` app.
- [Scream](https://github.com/duncanthrax/scream) by duncanthrax and contributors, itself based
  on Microsoft's MSVAD sample (Ms-PL): the base of the Windows virtual sound card.

**Specifications and test data**
- The [Noise Protocol Framework](https://noiseprotocol.org) by Trevor Perrin: the secure VBAN
  handshake.
- The [cacophony](https://github.com/haskell-cryptography/cacophony) test vectors: the proof that
  our Noise handshake is right.
- Apple's AudioServerPlugIn documentation and NullAudio example: the reference for the macOS
  plug-in.

**Platforms and tools**
Linux, ALSA and PipeWire; OpenWrt and LuCI; tc/eBPF and iproute2; QEMU and
[virtme-ng](https://github.com/arighi/virtme-ng), which let us test kernel code safely; Android, Kotlin and the NDK;
CMake and GitHub Actions.
