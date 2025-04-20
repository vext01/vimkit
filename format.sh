#!/bin/sh

set -eu

# Note: stylua will read .editorconfig.
find . -name '*.lua' -exec stylua {} \;
