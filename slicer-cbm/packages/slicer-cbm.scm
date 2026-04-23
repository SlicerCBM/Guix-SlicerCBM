;; SPDX-License-Identifier: BSD-3-Clause
;; Copyright (c) 2026, SlicerCBM Contributors
;; https://github.com/SlicerCBM/SlicerCBM

(define-module (slicer-cbm packages slicer-cbm)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system cmake)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (systole packages slicer))

(define-public slicer-cbm
  (let ((commit   "9a294a5c7c73a7ea68e8f4f5429475315cf3ed35")
        (revision "0"))
    (package
      (name "slicer-cbm")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/SlicerCBM/SlicerCBM")
               (commit commit)))
         (file-name (git-file-name name commit))
         (sha256
          ;; To refresh this hash after bumping `commit` above, run:
          ;;   guix download --git --commit=<commit> \
          ;;     https://github.com/SlicerCBM/SlicerCBM
          ;; and paste the printed base32 string here.
          (base32 "1ym29fb6sn3lbs5phl6rn7j8wgjs1bffpdwga95s0xb5qk0jpg0b"))))
      (build-system cmake-build-system)
      (arguments
       ;; Build against slicer-5.10 (Python 3.12, VTK_WRAP_PYTHON=ON,
       ;; Slicer_USE_PYTHONQT=ON — all set by the slicer-5.10 package itself).
       ;; Upstream SlicerCBM's .ruff.toml also targets Python 3.12, so 5.10
       ;; is the matching canonical Slicer for this extension.
       (list
        #:tests? #f
        #:configure-flags
        #~(list "-DCMAKE_BUILD_TYPE=Release"
                "-DBUILD_TESTING:BOOL=OFF"
                (string-append "-DSlicer_DIR="
                               #$(this-package-input "slicer-5.10")
                               "/lib/Slicer-5.10"))))
      ;; UseSlicer.cmake transitively needs Qt5/VTK/ITK/Python/… at configure
      ;; time, so inherit slicer-5.10's full input set (matches the in-tree
      ;; make-slicer-scripted-module-5.10 factory in guix-systole).
      (inputs
       (modify-inputs (package-inputs slicer-5.10)
         (prepend slicer-5.10)))
      (propagated-inputs (list slicer-5.10))
      (home-page "https://slicercbm.org")
      (synopsis "3D Slicer extension for computational biophysics in medicine")
      (description
       "SlicerCBM provides tools for creating and solving computational models
of biophysical systems in 3D Slicer, with focus on clinical and biomedical
applications.  Modules cover brain mesh generation and surface cell
selection, tissue material properties, electrical conductivity,
computational-grid and tetrahedral-mesh generation, electrode placement,
fuzzy classification, MTLED simulation, tumour resection and brain
remodelling, surface triangulation, and visualisation.  All modules are
scripted (Python-only) and built with @code{slicerMacroBuildScriptedModule}
against the @code{slicer-5.10} package (Python 3.12, PythonQt enabled)
from the @code{guix-systole} channel.")
      (license license:bsd-3))))
