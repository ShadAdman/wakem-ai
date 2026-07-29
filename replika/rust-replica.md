# Rust Replica Implementation Plan: Wakem-rs (Detailed)

This document provides a highly detailed mapping of the **Wakem** (Kotlin/KMP) project to **Rust**. It includes exact data structures, trait definitions, and CLI command specifications to ensure a faithful replication.

---

## 1. Core Data Models (`wakem-core`)

The following structs and enums should be implemented with `serde` for JSON/JSONL serialization.

### `Project` Struct
```rust
#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Project {
    pub id: String,
    pub name: String,
    pub description: String,
    pub source_path: Option<String>,
    pub skill_path: Option<String>,
    pub runtime_type: RuntimeType,
    pub target_models: Vec<String>,
    pub enable_prediction: bool,
    pub last_warmup_timestamp: i64,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub enum RuntimeType {
    Ollama,
}
```

### Supporting Models
```rust
#[derive(Debug, Serialize, Deserialize)]
pub struct Skill {
    pub id: String,
    pub name: String,
    pub description: String,
    pub content: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Prompt {
    pub id: String,
    pub text: String,
    pub timestamp: i64,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ModelPrediction {
    pub model_name: String,
    pub confidence: f32,
    pub rationale: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct WarmupPlan {
    pub id: String,
    pub project_id: String,
    pub models_to_load: Vec<String>,
    pub priming_prompts: Vec<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct GlobalConfig {
    pub active_project_id: Option<String>,
    pub ollama_url: String,
    pub daemon_interval_minutes: u32,
    pub warmup_cooldown_minutes: u32,
    pub settings: HashMap<String, String>,
}
```

---

## 2. Interface Definitions (Traits)

Rust traits replace Kotlin interfaces. Use `async-trait` for asynchronous functions.

### `ProjectManager` Trait
```rust
#[async_trait]
pub trait ProjectManager {
    async fn create_project(&self, name: &str, source_path: Option<&str>) -> Result<Project>;
    async fn list_projects(&self) -> Result<Vec<Project>>;
    async fn get_project(&self, name: &str) -> Result<Option<Project>>;
    async fn delete_project(&self, name: &str) -> Result<()>;
    async fn update_project(&self, project: &Project) -> Result<()>;
}
```

### `AIRuntime` Trait
```rust
#[async_trait]
pub trait AIRuntime {
    async fn check_health(&self) -> Result<bool>;
    async fn list_models(&self) -> Result<Vec<String>>;
    async fn warmup(&self, model: &str, keep_alive: &str, wait: bool) -> Result<bool>;
}
```

### `SkillLoader` & `PromptManager`
```rust
pub trait SkillLoader {
    fn list_skills(&self, project: &Project) -> Result<Vec<Skill>>;
}

pub trait PromptManager {
    fn add_prompt(&self, project: &Project, text: &str) -> Result<Prompt>;
    fn list_prompts(&self, project: &Project) -> Result<Vec<Prompt>>;
    fn delete_prompt(&self, project: &Project, id: &str) -> Result<()>;
}
```

---

## 3. CLI Command Specification

Use `clap` with the `derive` API to implement the following command tree.

### Main Commands
| Command | Action |
| :--- | :--- |
| `wakem project` | Manage projects (CRUD and config) |
| `wakem skill` | Manage and view skills |
| `wakem prompt` | Manage warmup prompts |
| `wakem predict` | Run prediction engine for current project |
| `wakem warm` | Execute full warmup sequence |
| `wakem daemon` | Start background warmup service |
| `wakem runtime` | Check and config AI engine (Ollama) |
| `wakem config` | Edit global configuration |

### Subcommand Detail: `wakem project`
- `create <name> [sourcePath]`
- `list`
- `use <name>` (Sets active project)
- `delete <name>`
- `config-runtime <model1> [model2]...` (Sets manual target models)
- `config-prediction <true\|false>` (Toggles prediction engine)
- `context` (Dumps aggregated project context as JSON)

---

## 4. Implementation Details

### Persistence Layer (`wakem-storage`)
- Use `tokio::fs` for async file operations.
- **Prompts**: Implement a `JsonlWriter` that appends to `prompts.jsonl`.
- **Config**: Use `serde_json::to_string_pretty` for `config.json` and `project.json`.

### TUI Layer (`wakem-terminal`)
- **Dashboard**: Use `ratatui`'s `Block`, `Paragraph`, and `List` widgets.
- **Event Loop**:
  ```rust
  loop {
      terminal.draw(|f| ui::draw_dashboard(f, &app_state))?;
      if let Event::Key(key) = event::read()? {
          match key.code {
              KeyCode::Char('q') => break,
              // handle navigation...
          }
      }
  }
  ```

### Runtime Layer (`wakem-runtime`)
- **Ollama Client**: Wrap `reqwest::Client`.
- **Fallback**: Use `std::process::Command` to execute `ollama` CLI if the HTTP endpoint is unreachable.

---

## 5. Module Structure (Cargo Workspace)
```text
/wakem-rs
  ├── Cargo.toml (Workspace)
  ├── crates/
  │   ├── wakem-core/       # Models, Traits
  │   ├── wakem-project/    # ProjectManagerImpl
  │   ├── wakem-runtime/    # OllamaClient
  │   ├── wakem-skills/     # Skill discovery
  │   ├── wakem-prompts/    # Prompt management
  │   ├── wakem-prediction/ # PredictionEngine
  │   ├── wakem-warmup/     # WarmupOrchestrator
  │   ├── wakem-storage/    # File I/O, JSONL
  │   ├── wakem-terminal/   # Ratatui UI
  │   ├── wakem-config/     # Global config management
  │   └── wakem-cli/        # Main binary (clap)
```
