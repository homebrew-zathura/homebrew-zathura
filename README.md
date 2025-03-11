# Zathura
Homebrew formulae to install Zathura and supporting PDF plugins on macOS.

## Tap this repository
```sh
brew tap homebrew-zathura/zathura
```

## Install zathura

> [!warning]
> While using the guide below, please do not use the `--HEAD` flag while installing Zathura.

If you want a comprehensive guide on installing zathura, check out [@ejmastnak](https://github.com/ejmastnak)'s guide [here](https://ejmastnak.com/tutorials/vim-latex/pdf-reader/#zathura-macos)

---

```sh
brew install zathura
```

(or Optionally) with Synctex:
```sh
brew install zathura --with-synctex
```

### Install and link one of the two plugins
In order to render PDFs, `zathura` requires either `mupdf` or `poppler`.

For MuPDF:
```sh
brew install zathura-pdf-mupdf
mkdir -p $(brew --prefix zathura)/lib/zathura
ln -s $(brew --prefix zathura-pdf-mupdf)/libpdf-mupdf.dylib $(brew --prefix zathura)/lib/zathura/libpdf-mupdf.dylib
```

For Poppler:
```sh
brew install zathura-pdf-poppler
mkdir -p $(brew --prefix zathura)/lib/zathura
ln -s $(brew --prefix zathura-pdf-poppler)/libpdf-poppler.dylib $(brew --prefix zathura)/lib/zathura/libpdf-poppler.dylib
```

## Copying to clipboard
Add the following to your `~/.config/zathura/zathurarc`:
```sh
set selection-clipboard clipboard
```
Thanks to [geigi](https://github.com/geigi) (see [#5](https://github.com/zegervdv/homebrew-zathura/issues/5))

# Uninstall
Homebrew will throw errors unless you uninstall plugins before Zathura.

```sh
brew uninstall --force zathura-pdf-mupdf
brew uninstall --ignore-dependencies --force girara
brew uninstall zathura
```

Optionally untap the repo

```sh
brew untap $(brew tap | grep zathura)
```

## Roadmap
- [ ] Frameless windows
- [ ] Better app bundle and icon
- [x] More plugin support (CB and EPUP formats, full list [here](https://archlinux.org/packages/?q=zathura-))
