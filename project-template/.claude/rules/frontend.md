---
paths:
  - "src/**/*.tsx"
  - "components/**"
  - "app/**"
---
<!-- Front-end zone rules — loaded only when a file matching `paths` is touched.
     NOTE: keep these globs FRONT-END ONLY. A broad `src/**/*.ts` was avoided on
     purpose: in a monorepo it also matches backend files (e.g. src/api/*.ts) and
     would wrongly attach "verify UI with Playwright" to server code. Widen it to
     your own front-end folders (e.g. src/features/**) if your layout differs. -->

React + TypeScript strict. No `any` without an inline justification comment.
Co-locate component tests. Verify UI changes with Playwright before marking done.
