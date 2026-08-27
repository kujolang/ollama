# Ollama for Kujo

Native Ollama support for Kujo, with an optional normalized Kujo AI SDK integration.

## Install

An operated public package registry is not available yet, so this release is installed from its immutable GitHub tag:

```sh
kujo run /path/to/kennel/kennel.kujo --interpreter -- add github:kujolang/ollama@v0.1.9 --alias ollama
kujo run /path/to/kennel/kennel.kujo --interpreter -- install
```

The `[registry]` URLs in `kennel.toml` are intentionally empty until a public registry service is operated. Do not use `kennel add ollama` yet. Kujo automatically discovers installed roots from the nearest `kennel.lock`; see `scripts/verify_installed_package.sh` for the clean-room installation proof.

## 30-second quick start

```kujo
from ollama import chat

response := chat({
    "model": "some-installed-model",
    "messages": [
        {"role": "user", "content": "Hello!"}
    ]
})

print(response["data"]["message"]["content"])
```

Use an installed model name.

## Native API

create_client, chat, generate, embed, embeddings, list_models, running_models, show_model, pull, push, create_model, copy_model, delete_model, and version map to native Ollama API endpoints. Native results retain Ollama response data, including messages, tool calls, done, done_reason, counts, timings, and model metadata.

Use create_client with host, timeout, api_key, and transport options. Localhost HTTP is allowed for local development. Remote endpoints must use HTTPS.

## AI SDK integration

ollama_provider({"model": "..."}) supplies an explicit ai-sdk-provider-driver 1.0.0 descriptor. It encodes Kujo messages for /api/chat and /api/embed, decodes native NDJSON, maps tool calls and usage, and leaves transport policy, retries, redaction, and final normalized contracts to AI SDK core.

Use ollama_provider for normalized workflows. Use the native API for model lifecycle, thinking controls, structured output, provider metadata, and other Ollama-specific behavior. The optional ollama_openai_compatible_provider targets /v1 and is not the primary implementation.

## Streaming, tools, structured output, embeddings

Native chat streaming is newline-delimited JSON, not OpenAI SSE. client_chat_stream exposes events, output_text, and final. Tool schemas go in tools; JSON or JSON Schema goes in format; reasoning controls go in think; batch embeddings use input arrays.

## Local and cloud authentication

Local Ollama sends no Authorization header. https://ollama.com reads OLLAMA_API_KEY when no explicit key is supplied and sends Bearer authentication. Keys are not included in examples or returned error bodies. Custom HTTPS hosts do not receive the key automatically.

## Testing

    bash scripts/release_quality_gate.sh

The default gate is offline and uses deterministic transports/fixtures. Optional live validation is separate and does not download or delete user resources.

See PROVIDER_PACKAGE_PATTERN_DRAFT.md and OLLAMA_IMPLEMENTATION_REPORT.md.
