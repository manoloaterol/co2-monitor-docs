#!/bin/sh
# Builds both languages into site/, plus a root page that sends visitors to
# their browser's language. Run from this folder: ./build.sh
set -e
cd "$(dirname "$0")"
MKDOCS="${MKDOCS:-.venv/bin/mkdocs}"

rm -rf site
"$MKDOCS" build --strict -f en/mkdocs.yml
"$MKDOCS" build --strict -f es/mkdocs.yml

cat > site/index.html <<'HTML'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>CO₂ Monitor</title>
<meta http-equiv="refresh" content="0; url=en/">
<script>
  var lang = (navigator.language || "en").slice(0, 2);
  location.replace(lang === "es" ? "es/" : "en/");
</script>
</head>
<body><a href="en/">English</a> · <a href="es/">Español</a></body>
</html>
HTML
echo "Built into site/. Preview: python3 -m http.server -d site 8000"
