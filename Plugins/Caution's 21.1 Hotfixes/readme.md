# Caution's 21.1 Hotfixes

This folder contains a collection of performance hotfixes and quality of life improvements for Pokémon Essentials v21.1.

## Features

- **Plugin Compilation Threading**: Optimizes the PluginManager's compile stage by utilizing a fixed-size thread pool to perform file reading and Zlib deflation in parallel, significantly cutting down compile time.

## Changelog

- **[Date]**: Initial creation. Added multi-threading support to `PluginManager.compilePlugins` to drastically speed up sequential file I/O operations and Zlib deflating during the plugin compilation phase.
