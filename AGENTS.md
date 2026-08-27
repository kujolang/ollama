# Ollama package agent guidance

- Public native exports live in `src/ollama.kujo`; the AI SDK adapter lives in `src/provider.kujo`.
- Native request/response fidelity belongs in `src/ollama.kujo`. Do not add Ollama branches to AI SDK core.
- The provider driver is descriptor/decoder-only. It never performs I/O or bypasses AI SDK policy.
- Keep local Ollama unauthenticated. Only `https://ollama.com` receives `Authorization: Bearer` from `OLLAMA_API_KEY`.
- Add deterministic transport fixtures before live tests. Live tests are opt-in and must not download, publish, or delete user resources.
- Blocking checks are `bash scripts/release_quality_gate.sh` and the Kennel install smoke.
