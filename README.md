<h1 align="center">wakem</h1>

<p align="center">
  <video src="wakem.mp4" width="800" autoplay loop muted></video>
</p>
<p align="center"><i>(Demo video - optimized for 2x playback speed internally)</i></p>

<p align="center">
  <b>The official wakem ecosystem</b>
</p>

---

## What is Wakem?

**Wakem** is a specialized CLI infrastructure tool designed for **Predictive AI Warmup**. 

If you use local AI models (like Ollama, Llama.cpp, or LocalAI), you've likely experienced the "cold start" problem: the first time you ask a question, you wait several seconds for the model to load into VRAM and process the initial context. 

**Wakem eliminates this wait.** It acts as a bridge between your intent to work and your AI's readiness. By the time you start your IDE or terminal, Wakem has already:
1. Predicted which model you'll need.
2. Loaded that model into VRAM.
3. Primed it with your project's files, skills (Markdown files), and your specified prompts.

### What Wakem is NOT
*   **NOT a Generative AI:** Wakem does not generate text, code, or images. It doesn't have its own "brain."
*   **NOT a Chatbot:** While it handles prompts, it doesn't "talk" to you. It talks to your AI backend to prepare it for you.
*   **Purely Infrastructure:** It is a DIY tool for managing your local inference environment efficiently.

---

## How it Works

Wakem operates on a **Context -> Predict -> Prime -> Warm** cycle:

1.  **Context Analysis**: When you "use" a project, Wakem scans the directory for structure and markers.
2.  **Skill Discovery**: It identifies skills by scanning for all Markdown (`.md`) files within your specified project directory.
3.  **Prediction Engine**: Using internal rules, it determines which of your installed models is best suited for the current project.
4.  **Priming**: It sends your predefined prompts and project context to the model, ensuring it understands your requirements before you even start working.
5.  **Warmup**: It maintains a connection to your backend (like Ollama) to ensure the model stays active in memory according to your `keep_alive` settings.

---

## Wakem Commands

The CLI is organized into logical groups to manage every aspect of the warmup process.

### `wakem project`
Manage your development environments.
*   `create <name> <path>`: Link a local directory to a Wakem project.
*   `use <name>`: Switch the active project.
*   `list`: See all managed projects.
*   `config-runtime`: Specify which models are preferred for this specific project.

### `wakem prompt`
Manage the "briefing" text sent to models during warmup.
*   `add "text"`: Add a new warmup instruction.
*   `list`: Review current prompts.
*   `delete <id>`: Remove old prompts.

### `wakem warm`
The core action. Manually triggers the prediction and loading of models for the current project. Use this just before you start a task.

### `wakem runtime`
Control your AI backend (default is Ollama).
*   `status`: Check if the backend is reachable.
*   `models`: List all models available for warming.
*   `config-url`: Set a custom API endpoint (e.g., a remote GPU server).

### `wakem daemon`
The "Set it and Forget it" mode. Starts a background process that periodically checks your active project and ensures the models are warmed up without manual intervention.

---

## Implementations

Wakem is available in three official high-performance implementations:

- **[Kotlin/Native](wakem-k/)**: Built with Kotlin Multiplatform for high-performance native binaries.
- **[Rust](wakem-r/)**: A memory-safe, zero-cost abstraction implementation.
- **[Golang](wakem-g/)**: Statically-linked binaries with zero external dependencies.

---

## Project Structure
- `wakem-k`: Kotlin/Native implementation.
- `wakem-r`: Rust implementation.
- `wakem-g`: Go implementation.
