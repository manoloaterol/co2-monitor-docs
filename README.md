# CO₂ Monitor — documentation site

The user manual, in English and Spanish, built with
[MkDocs](https://www.mkdocs.org) and the
[Material](https://squidfunk.github.io/mkdocs-material/) theme.

## Layout

```
base.yml          shared settings: theme, colours, Markdown extensions, language switch
en/mkdocs.yml     English site: title, navigation
en/docs/          English pages
es/mkdocs.yml     Spanish site
es/docs/          Spanish pages, same file names as English
shared/           logo and CSS, linked into both docs/assets/
build.sh          builds both into site/en and site/es, plus a root page
                  that redirects by browser language
```

Each language is a separate MkDocs build. The language selector in the
header links the two (`extra.alternate` in `base.yml`); no i18n plugin is
used. Keep the **same file names** in both languages.

## Set up

```sh
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
```

## Work on it

One language, reloading on every change:

```sh
.venv/bin/mkdocs serve -f en/mkdocs.yml
```

`mkdocs serve` serves a single language, so the language selector does not
work there. To try the whole site, build it and serve `site/`:

```sh
./build.sh
python3 -m http.server -d site 8000
```

`build.sh` uses `--strict`: a broken link or anchor fails the build.

## Versions

`requirements.txt` pins MkDocs 1.6.1 and Material 9.7.7. Material has been
in maintenance mode since November 2025 and does not work with MkDocs 2.0.
Its successor, [Zensical](https://zensical.org), reads the same `mkdocs.yml`;
moving to it is planned once it is stable.

## Still to fill in

Search the pages for `TODO`: photos, dimensions, shop links, firmware
licence and repository, releases URL, support contact.
