# Provider Package Pattern Draft

This is evidence from Ollama, not Provider Package Contract v1. Anthropic must validate it.

## Repository structure

Use one obvious native module, one provider-driver module, examples, deterministic tests, and a release gate. Avoid wrappers that hide request encoding.

## Public API and configuration

Expose familiar provider operations plus create_client. Store host, timeout, transport, and auth policy in a client dictionary. Validate endpoint scheme, credentials, query strings, fragments, and control characters before transport.

## Kennel

Use early semantic versioning, a pinned AI SDK commit, explicit exports, package status metadata, source/include boundaries, and a package-level offline gate.

## Adapter and driver tests

The provider factory owns metadata and the driver bundle. Tests call every hook directly, then prove chat, stream, embeddings, tool calls, usage, finish reason, and error mapping through AI SDK.

## Fixtures and live smoke

Inject transports and use small deterministic payloads. Live checks are opt-in, model-configurable, skip when unavailable, and never download, publish, or delete user resources.

## Examples and security

Every provider should have quickstart, native chat/stream/tools/structured-output/embeddings/model discovery, AI SDK, and cloud examples. AI SDK core remains authoritative for endpoint policy, protected headers, transport, retries, limits, final normalization, and redaction.

## Native-versus-normalized boundary

Native APIs preserve provider fidelity. The driver maps only common semantics and keeps provider-specific data in raw_provider.

## Ollama-specific exceptions

Ollama uses native /api NDJSON, optional Bearer only for ollama.com, think, format, keep_alive, prompt_eval_count, eval_count, and model lifecycle endpoints. These are not universal conventions.

## Candidate universal conventions

Pinned dependency, src/provider.kujo, explicit driver contract/version, fixture transport, offline gate, opt-in live smoke, endpoint-safe client factory, and separate native/normalized documentation are candidates for a future contract.
