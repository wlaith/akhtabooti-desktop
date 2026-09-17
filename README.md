<div align="center">
  <img src="public/logo.png" alt="" width="88" height="88">
  <h1>Akhtabooti</h1>
  <p><strong>Find personal data in your files — without any of it leaving your computer.</strong></p>
</div>

Akhtabooti is a desktop application that scans files and folders for personally
identifiable information (PII) — email addresses, phone numbers and other personal
identifiers — and reports what it found and where.

It is built for civil society organisations, newsrooms and human rights groups that
need to know what personal data they are holding before they share, archive or
publish it.

## Everything stays on your machine

This is the property that matters most, so it is worth stating plainly:

- Your files are read locally and never uploaded.
- Findings are held in memory and written only where you choose to export them.
- The application makes no network requests. It does not phone home, check for
  updates, or send telemetry.
- Nothing is retained between runs. Closing the app discards the results.

You do not have to take our word for it — the application is open source, and
`src-tauri/src/lib.rs` contains the complete set of operations it can perform.

## What it does

1. **Choose what to scan.** Add any mix of individual files and folders.
2. **Run the scan.** Each path is processed independently, with per-path progress,
   and can be cancelled at any time.
3. **Review findings.** Filter by category, search by path, and inspect which
   identifiers were found in which file.
4. **Export a report.** Save selected or all findings as a JSON file.

Text is extracted with [Apache Tika](https://tika.apache.org/), so common document
formats are supported — PDF, Word, Excel, HTML, JSON and plain text among them.
Files that cannot be read are reported separately rather than silently skipped.

## Installing

Builds for macOS, Linux (`.deb` / `.rpm`) and Windows (`.msi` / `.exe`) are published
on the [releases page](https://github.com/wlaith/akhtabooti-desktop/releases).

> **macOS:** code signing and notarisation are still being set up. Until that work
> lands, macOS builds are not signed with a Developer ID and will be blocked by
> Gatekeeper. If you need to run Akhtabooti on macOS today, build it from source.

## Building from source

Requirements:

- [Node.js](https://nodejs.org/) 20 or later
- [Rust](https://www.rust-lang.org/tools/install) (stable toolchain)
- Platform dependencies for Tauri — see the
  [Tauri prerequisites guide](https://tauri.app/start/prerequisites/)

On Debian or Ubuntu you will also need:

```sh
sudo apt-get install libwebkit2gtk-4.1-dev libappindicator3-dev librsvg2-dev patchelf
```

Then:

```sh
npm install
npm run tauri dev      # run in development
npm run tauri build    # produce an installable bundle
```

The first build takes a while. Akhtabooti depends on
[`akhtabooti-core`](https://github.com/wlaith/akhtabooti-core), which compiles a
native Apache Tika library through GraalVM — this is a large, one-time cost that
subsequent builds reuse.

## Project layout

```
src/                     Vue 3 frontend (Composition API, TypeScript, Tailwind)
  components/            One directory per component
  composables/           Scan, stepper and theme logic
src-tauri/               Tauri application shell
  src/lib.rs             The Rust commands exposed to the frontend
  scripts/               Native library relocation and bundle verification
```

## Security

Found a vulnerability? Please report it privately — see [SECURITY.md](SECURITY.md).
Do not open a public issue for security problems.

When filing an ordinary bug, never attach documents containing real personal data.
Synthetic examples only.

## Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) before
opening a pull request.

## Licence

Licensed under the [Apache License 2.0](LICENSE).
