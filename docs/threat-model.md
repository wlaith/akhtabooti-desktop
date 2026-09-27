# Threat model and data handling

Akhtabooti is used by people who may be at elevated risk, on documents that may
put others at risk. This document states plainly what the application does with
your data, what it protects against, and what it does not.

## What the application can do

The webview can ask the Rust side to perform exactly two operations. There are no
others:

| Operation       | What it does                                                                    |
| --------------- | ------------------------------------------------------------------------------- |
| `scan_path`     | Reads a file or walks a directory, extracts text, returns the identifiers found |
| `export_report` | Opens a native save dialog and writes the report where you choose               |

The save dialog is opened by the Rust side, not the frontend, so the destination
path is never supplied by the webview. There is no command that writes to a path
chosen by page content.

## Data handling

- **Read:** only the files and folders you explicitly add to a scan.
- **Written:** only the JSON report, only to the location you pick in the save
  dialog. Nothing else is written to disk.
- **Sent anywhere:** nothing. The application makes no network requests. It does
  not check for updates, report errors, or collect analytics.
- **Retained:** nothing. Findings are held in memory for the duration of the run
  and discarded when the application closes. There is no database, cache or log
  of scan results.

The content security policy in `src-tauri/tauri.conf.json` restricts the webview
to `'self'` and the local IPC channel, so the interface cannot load or contact a
remote origin even if a bug allowed content to try.

## What this protects against

- Personal data leaving the machine as a side effect of scanning it.
- A content-injection bug escalating into writing arbitrary files.
- Findings persisting on disk after you close the application.

## What this does not protect against

- **An attacker who already controls your device.** Akhtabooti has no defence
  against malware, a compromised account, or someone with physical access.
- **The report you export.** Once written, the JSON report contains the personal
  data you were looking for, in plain text. Treat it as sensitive. Protecting it
  afterwards is your responsibility.
- **Incomplete detection.** Detection is heuristic. It will miss personal data
  and it will flag things that are not personal data. Treat the output as a
  starting point for human review, never as proof that a file is clean.
- **Metadata and file names.** Scanning reads document text. Personal data held
  only in file names, embedded metadata or images is not reliably found.
- **The supply chain.** Text extraction runs through Apache Tika, a large native
  dependency. We pin it to a known revision and publish build provenance, but a
  compromise upstream would affect Akhtabooti.

## Platform notes

The macOS build requires the `com.apple.security.cs.disable-library-validation`
entitlement. The bundled Tika library is produced by GraalVM and carries no Team
ID, so the hardened runtime would otherwise refuse to load it. This relaxes one
macOS protection for the bundle. Removing the need for it depends on signing the
native library with the same Team ID as the application.

## Reporting a problem

See [SECURITY.md](../SECURITY.md).
