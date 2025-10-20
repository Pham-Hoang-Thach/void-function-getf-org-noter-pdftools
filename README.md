# Patch: Fix `org-noter-pdftools` Error — *void-function getf*

This Emacs Lisp patch fixes a common compatibility issue when using [`org-noter`](https://github.com/org-noter/org-noter) together with [`org-pdftools`](https://github.com/fuxialexander/org-pdftools) and  
[`pdf-tools`](https://github.com/politza/pdf-tools).

## 🧩 Problem

After Emacs is updated, users encounter this error when opening PDF links inside Org documents managed by `org-noter` or `org-pdftools`:

## 🧠 Root Cause

- The function `org-pdftools-open-pdftools` in `org-pdftools` internally calls `getf`,  
  which was defined in the legacy `cl` library (used in older Emacs versions).
- In modern Emacs (≥27), `getf` is no longer defined by default — it has been replaced by `cl-getf` in `cl-lib`.
- This causes the `void-function getf` error whenever you open a PDF link.

## 🩹 The Fix

This patch redefines `org-pdftools-open-pdftools` to use `cl-getf` and safely overrides the original function after `org-pdftools` loads.

- Add the following to your `init.el` or `config.org`:

```emacs-lisp
(load "~/.emacs.d/lisp/fix-void-function-getf-org-noter-pdftools.el")
```

- Alternatively, you can copy the contents of this file into your Emacs configuration file.
  
## 💡 Technical Notes

- `cl-getf` is the modern, namespaced equivalent of getf provided by `cl-lib`.

- This patch ensures compatibility with all current Emacs releases (27–30+).

- The fix uses `advice-add`:override to safely replace the old implementation without altering the original `org-pdftools` source code.

# Tested Environment

- Debian 12 / WSL2: Ubuntu 22.04 LTS

- Emacs: 30.1

- Orgmode: 9.7.11
