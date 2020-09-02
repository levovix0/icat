# Package

version       = "0.1.0"
author        = "levovix0"
description   = "Позволяет просмотреть картинку в терминале"
license       = "MIT"
srcDir        = "src"
bin           = @["icat"]

# Dependencies

requires "nim >= 1.2.4"
requires "cligen", "with"
requires "nimpng", "colorize"
