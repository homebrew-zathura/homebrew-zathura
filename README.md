# Zathura

Homebrew formulae to install Zathura and supporting PDF plugins on macOS.

## Tap this repository

```sh
brew tap homebrew-zathura/zathura
```

## Install zathura

> ![NOTE]
> If you want a comprehensive guide on installing zathura, check out [@ejmastnak](https://github.com/ejmastnak)'s guide [here](https://ejmastnak.com/tutorials/vim-latex/pdf-reader/#zathura-macos)

Zathura uses a plugin based system for supported document types
which means that you need install not only zathura itself,
but at least one plugin. At this moment zathura has 5 official plugins:

- `zathura-cb` for Comic Book Archive files (.cbr, .cbz, .cbt, etc.)
- `zathura-djvu` for DjVu files (.djvu, .djv)
- `zathura-pdf-mupdf` for PDF files (.pdf) via MuPDF backend
- `zathura-pdf-poppler` for PDF files (.pdf) via Poppler backend
- `zathura-ps` for PostScript files (.ps, .eps)

To use zathura as PDF viewer you need either `zathura-pdf-mupdf`
or `zathura-pdf-poppler` plugin. It is not recommended to install
both plugins since zathura will use only one of them, and which
one depends on the implementation and may change at any time.

### Install zathura

> ![warn]
> Installing zathura with `--HEAD` flag is deprecated and will not work. Please use the commands below.

```sh
brew install zathura
```

(or Optionally) with Synctex:

```sh
brew install zathura --with-synctex
```

### Install plugins

Install all required plugins. Note that `zathura` requires either
`zathura-pdf-mupdf` or `zathura-pdf-poppler` plugin in order to
render PDFs.

```sh
brew install [zathura-cb] [zathura-djvu] [zathura-pdf-mupdf] [zathura-pdf-poppler] [zathura-ps]
```

After you install all required plugins you need to put them in
a directory where zathura can find them. To do this, run the
following command. You have to run this command only after
installing new plugins.

```sh
d=$(brew --prefix zathura)/lib/zathura ; mkdir -p $d ; for n in cb djvu pdf-mupdf pdf-poppler ps ; do p=$(brew --prefix zathura-$n)/lib$n.dylib ; [[ -f $p ]] && ln -s $p $d ; done
```

### App bundle

To use zathura as macOS application, run following command.
You have to run this command each time you're installing new
plugins to update bundle info.

```sh
curl https://raw.githubusercontent.com/homebrew-zathura/homebrew-zathura/refs/heads/master/convert-into-app.sh | sh
```

If this does not work, try downloading the script from the repo
and running it manually.

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
