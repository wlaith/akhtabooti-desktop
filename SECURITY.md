# Security Policy

Akhtabooti is used to handle sensitive documents, often by people at elevated risk.
We take security reports seriously and will work with you to resolve them.

## Reporting a vulnerability

**Please do not open a public issue for a security problem.**

Report it privately through GitHub's private vulnerability reporting:

1. Go to the [Security tab](https://github.com/wlaith/akhtabooti-desktop/security)
2. Select **Report a vulnerability**

This creates a private advisory visible only to you and the maintainers.

Please include:

- What the issue is and why you believe it is a security problem
- Steps to reproduce it
- The version of Akhtabooti and your operating system
- Any proof-of-concept you have

**Never include real personal data in a report.** If you need to demonstrate the
issue with a document, construct one with synthetic data.

## What to expect

- We aim to acknowledge a report within **5 working days**.
- We will confirm whether we can reproduce the issue and tell you our assessment
  of its severity.
- We will keep you updated while we work on a fix, and let you know when it ships.
- With your permission we will credit you in the advisory and release notes. Tell
  us if you would rather remain anonymous.

We ask that you give us a reasonable opportunity to release a fix before
disclosing the issue publicly.

## Supported versions

Akhtabooti is pre-1.0 and under active development. Security fixes are applied to
the most recent release only. We recommend always running the latest version.

| Version | Supported |
| ------- | --------- |
| 0.1.x   | Yes       |

## Scope

In scope:

- The Akhtabooti desktop application in this repository
- Its build and release pipeline
- [`akhtabooti-core`](https://github.com/wlaith/akhtabooti-core), the scanning engine

Out of scope:

- Vulnerabilities in upstream dependencies that we do not control — please report
  those to the relevant project, though we appreciate being told as well
- Findings that require an attacker to already have full control of the user's
  machine

## What Akhtabooti does and does not protect against

Akhtabooti helps you **discover** personal data in files you already hold. It does
not encrypt, redact or delete anything, and it is not a defence against an attacker
with access to your device. Detection is heuristic: it will miss some personal data
and flag some things that are not personal data. Treat its output as a starting
point for review, not as a guarantee.
