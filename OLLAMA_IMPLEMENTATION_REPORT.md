# Ollama Implementation Report

## Executive Summary

Built the first Kujo Ollama package with a native client surface and an explicit AI SDK provider driver. Version 0.1.0 is early/experimental.

## Current Ollama API evidence

Official Ollama REST API documentation and the official ollama-python and ollama-js clients were inspected on 2026-08-26. Verified local http://localhost:11434, cloud https://ollama.com, native /api/chat, /api/generate, /api/embed, legacy /api/embeddings, /api/tags, /api/ps, /api/show, /api/pull, /api/push, /api/create, /api/copy, /api/delete, and /api/version. Native streams are NDJSON. Cloud uses OLLAMA_API_KEY; local native requests do not require authentication. Web search/fetch are outside this focused package.

## Architecture

    flowchart TD
      A[Kujo application] --> N[Native Ollama client]
      A --> S[Kujo AI SDK]
      S --> D[ollama-native driver]
      N --> API[Ollama /api protocol]
      D --> API
      D --> C[AI SDK core policy and normalized contract]

## Native API coverage

| Operation | Implemented | Tested Offline | Live Smoke | Notes |
|---|---:|---:|---:|---|
| chat/generate/embed/embeddings | yes | yes | skipped | native response in data |
| stream | yes | yes | skipped | NDJSON aggregation |
| list/running/show/version | yes | yes | skipped | native paths |
| pull/push/create/copy/delete | yes | request surface | skipped | no destructive live tests |
| tools/format/think/keep_alive | yes | driver/request mapping | skipped | model-dependent |

## Public exports and Kennel

Native exports are in src/ollama.kujo; provider exports are in src/provider.kujo. Root shims support direct source imports. Kennel pins AI SDK to commit 0767672022cb4f4c8648c4b250903e75e09129e2. The local file source flow is documented in README.

## Authentication and security

Local HTTP is allowed only for localhost. Remote hosts require HTTPS. URL credentials, query/fragment data, and control characters are rejected. Bearer auth is sent only to ollama.com subdomains. Errors redact configured keys. Drivers emit descriptors and semantic data only.

## AI SDK driver

Implemented describe, validate, encode_chat, decode_chat, decode_error, decode_stream, encode_embeddings, and decode_embeddings. done_reason maps to finish_reason; prompt_eval_count and eval_count map to usage; message.tool_calls maps to normalized tool calls. The optional compatibility helper targets /v1 and is separate.

## Tests and live validation

Deterministic suites cover configuration, local no-auth, cloud key scope, unsafe host rejection, redaction, native NDJSON, driver hooks, chat/tool/usage mapping, embeddings, and compatibility separation. Run bash scripts/release_quality_gate.sh for exact totals. Live Ollama validation skipped: environment unavailable unless explicitly configured.

## AI SDK changes

None.

## Known limitations

The native client returns a response envelope rather than typed Python/JavaScript response objects. Streaming is buffered through injected response chunks. Lifecycle progress does not yet expose a dedicated progress iterator. The package is not published to the operated public Kennel registry. Live validation is not default CI.

## Provider package lessons

Keep native fidelity and AI SDK normalization separate; make the driver a small public hook bundle; pin dependencies; use transport fixtures; make no-auth local behavior explicit; document provider-specific exceptions; and put security policy enforcement in AI SDK core.

## Ready for Anthropic Reference Validation?

NO

Blocking list:

- Kennel manifest validation passes, but clean fixture add/install still fails in Kennel while resolving the pinned AI SDK commit from the HTTPS GitHub source.
- The final package gate passes after the last source/test edits.
- Live Ollama validation is unavailable in this environment.
- Native lifecycle streaming/progress ergonomics remain early.
