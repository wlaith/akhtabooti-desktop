# Contributing to Akhtabooti

Thanks for your interest. Akhtabooti helps civil society organisations find
personal data in their own files, so correctness and privacy matter more here
than they might elsewhere.

## Before you start

- **Never attach real personal data** to an issue, pull request or test fixture.
  Construct synthetic examples instead. This applies to screenshots too.
- For anything security-related, do not open a public issue — follow
  [SECURITY.md](SECURITY.md).
- For a substantial change, open an issue first so we can agree on the approach
  before you spend time on it.

## Development setup

Requirements: Node.js 20+, a stable Rust toolchain, and the
[Tauri prerequisites](https://tauri.app/start/prerequisites/) for your platform.

```sh
npm install
npm run tauri dev
```

The first build compiles a native Apache Tika library through GraalVM and takes
a long time. Later builds reuse it.

## Making a change

1. Branch from `development`.
2. Keep the change focused. One concern per pull request — it makes review
   faster and a revert cheaper.
3. Match the existing style: Vue 3 Composition API with `<script setup>`,
   TypeScript, one directory per component, logic in composables.
4. Check it builds before pushing:

   ```sh
   npm run build                                    # typecheck + bundle
   cargo check --manifest-path src-tauri/Cargo.toml
   ```

5. Write commit messages in the conventional style already used here —
   `feat:`, `fix:`, `chore:`, `docs:` — and explain _why_ in the body, not just
   what.

## Pull requests

Describe what changed and why, and say how you tested it. If the change affects
what the application reads, writes or sends, say so explicitly — that is the part
reviewers will look at hardest.

CI must pass before merge.

## Reporting bugs

Use the bug report template. The most useful reports include the version, your
operating system, what you expected, and what happened instead.
