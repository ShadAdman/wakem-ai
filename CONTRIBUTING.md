# Contributing to Wakem

Welcome to the Wakem project! We're excited to have you here.

## The Vision: Why multiple languages?

Wakem is a specialized CLI infrastructure tool designed for **Predictive AI Warmup**. Our goal is to make local AI development as seamless as possible. To achieve this, we want to build a robust ecosystem that is accessible to as many engineers as possible.

We provide four official implementations:
- **[Kotlin/Native](wakem-k/)**
- **[Rust](wakem-r/)**
- **[Golang](wakem-g/)**
- **[TypeScript/Node.js](wakem-t/)**

By maintaining parity across these languages, we lower the barrier to entry for contributors. Whether you're a systems programmer, a backend developer, or a full-stack engineer, there's a place for you in the Wakem ecosystem.

## How to Contribute

We follow a **"Pick Your Flavor"** contribution model:

1.  **Choose your language**: Select the implementation you are most comfortable with.
2.  **Focus on your domain**: You are only responsible for developing, debugging, and testing in your selected language.
3.  **We handle the rest**: Once your PR is approved and merged, the core maintainers will take the responsibility of applying those logic changes, bug fixes, or new features to the other implementations.

You don't need to know all four languages to make a meaningful impact!

## Guidelines

### Opening Issues
- When reporting a bug or suggesting a feature, please clearly state which implementation(s) it affects.
- Include `[Kotlin]`, `[Rust]`, `[Go]`, or `[TypeScript]` in the issue title.

### Pull Requests
- Mention the target language in the PR title (e.g., `[Rust] Add support for custom keep-alive settings`).
- Ensure your changes follow the existing module structure and naming conventions to maintain parity.
- Provide a detailed description of the changes and how you've tested them in your environment.

## Parity is Key

While we encourage creative solutions, the core logic and public interfaces of the CLI must remain consistent across all implementations. This ensures that a `wakem project create` command behaves exactly the same way whether the user is running the Rust binary or the Node.js package.

## Testing Strategy

To ensure consistency and high quality across all platforms, we use a unified testing strategy. Each platform implementation contains a `test/` directory designed for end-to-end and integration testing.

### Test Environment Setup

The `test/` directory simulates a user's environment by providing a local `.wakem` storage:
- **Path**: `<platform-root>/test/.wakem`
- **Config**: Contains `config.json` with the active project set to the platform itself (e.g., `wakem-r`).
- **Project**: A pre-configured project pointing back to the source root (`../../`) allowing the tool to index its own source as a test subject.

### Verification Workflow

When developing or debugging, you should verify your changes using this local environment. 

1. **Indexing**: The strategy relies on indexing the core modules. The implementation must discover skills directly from the source root (searching for `.md` files).
2. **Prompts**: Use the standard troubleshooting prompt:
   > "Ready yourself for troubleshooting and bug-fixing tasks by indexing the core modules."
3. **Execution**: Run the CLI with the `HOME` environment variable set to the `test` directory to use the isolated configuration.

### Runtime Requirements
- **Runtime**: Ollama
- **Model**: `gemma4`

All contributors are encouraged to run these verification steps before submitting a PR to ensure that core features like skill discovery and project management are functioning correctly.

---

Thank you for helping us make Wakem better!
