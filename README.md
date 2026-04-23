# SlicerCBM Guix Channel

This [Guix channel](https://guix.gnu.org/manual/en/html_node/Channels.html)
provides a package for [SlicerCBM](https://github.com/SlicerCBM/SlicerCBM) —
Computational Biophysics for Medicine in 3D Slicer.

| Package      | Version | Description |
|--------------|---------|-------------|
| `slicer-cbm` | git     | SlicerCBM extension (all 24 scripted modules) built against `slicer-5.10` from [guix-systole](https://github.com/SystoleOS/guix-systole) |

## Installing

Add both channels to `~/.config/guix/channels.scm` — `systole` provides Slicer,
this channel provides the extension:

```scheme
(cons* (channel
         (name 'systole)
         (url "https://github.com/SystoleOS/guix-systole.git")
         (branch "main"))
       (channel
         (name 'slicer-cbm)
         (url "https://github.com/SlicerCBM/Guix-SlicerCBM.git")
         (branch "main"))
       %default-channels)
```

Then pull and install:

```sh
guix pull
guix install slicer-cbm
Slicer                    # CBM modules appear under "Physics / CBM.*"
```

`SLICER_ADDITIONAL_MODULE_PATHS` (a native search path declared by
[`slicer-5.10`](https://github.com/SystoleOS/guix-systole/blob/main/systole/systole/packages/slicer.scm))
auto-discovers the installed scripted-module directory, so no extra wiring
is needed once both packages are in the profile.

## Development

Build from a local checkout without adding the channel:

```sh
git clone https://github.com/SystoleOS/guix-systole
git clone https://github.com/SlicerCBM/Guix-SlicerCBM

guix build -L guix-systole/systole -L Guix-SlicerCBM slicer-cbm
```

Lint the package:

```sh
guix lint -L guix-systole/systole -L . slicer-cbm
```

## Related channels

- [`guix-systole`](https://github.com/SystoleOS/guix-systole) — 3D Slicer
  and its full dependency tree (VTK, ITK, CTK, Qt5, …) packaged for Guix.
  This channel is a hard dependency.
- [`guix-mvox`](https://github.com/benzwick/guix-mvox) — MFEM and MVox
  mesh voxeliser. Required at runtime for SlicerCBM modules that call
  out to MVox (e.g. `MVoxMeshGenerator`).

## License

The package definitions in this repository are BSD-3-Clause, matching
upstream SlicerCBM. See [SlicerCBM's LICENSE](https://github.com/SlicerCBM/SlicerCBM/blob/master/LICENSE).
