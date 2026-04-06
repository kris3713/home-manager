# AGENTS.md

This repository contains a Home Manager configuration managed via Nix flakes. 
Agents working in this repository should follow the guidelines below to ensure consistency and correctness in the Nix expressions.

## 🛠 Development Workflow

### Commands

Since this is a Nix flake-based configuration, most operations involve `nix` commands.

- **Evaluate configuration**: `nix flake check`
- **Apply configuration**: `home-manager switch --flake .#kris` (or use your preferred method to activate the flake)
- **Update dependencies**: `nix flake update`
- **Dry run**: `home-manager build --flake .#kris`

*Note: There are no traditional "build/test/lint" commands like `npm test` or `pytest` here, as the "tests" are the Nix evaluation and build process itself.*

## 📜 Code Style & Guidelines

### Nix Expression Patterns

- **Module Structure**: Follow the standard Home Manager module pattern:
  ```nix
  { config, lib, pkgs, ... }:
  let
    inherit (lib) mkIf;
  in {
    programs.someProgram.enable = true;
  }
  ```
- **Imports & Modules**: 
  - Use the `modules` list in `home.nix` or `flake.nix` to include new files.
  - Prefer relative paths for local modules (e.g., `./extras/fish.nix`).
- **Variable Naming**: Use `camelCase` for local `let` bindings and `snake_case` for Nix option names where appropriate (though Nix options are usually `lowerCamelCase` or `dot.notation`).
- **Inheritance**: Use `inherit` to bring multiple attributes from `lib`, `config`, or `inputs` into the local scope to keep the code clean.
- **DRY (Don't Repeat Yourself)**: 
  - Use `let...in` blocks to define reusable paths (e.g., `userConfigDir`, `userBinDir`).
  - Leverage `with inputs;` or `with pkgs;` carefully to avoid excessive prefixing, but ensure it doesn't cause namespace collisions.

### Configuration Standards

- **XDG Base Directory Specification**: Always prefer using XDG standard paths (e.g., `${config.home.XDG.configHome}`) instead of hardcoding absolute paths like `/home/user/.config`.
- **Package Management**:
  - When adding new packages, add them to the `home.packages` list in `extras/pkgs.nix`.
  - Use `with pkgs;` or `with <input-name>;` to group related packages.
- **Error Handling & Safety**:
  - Use `lib.mkIf` to conditionally enable features or packages.
  - Use `lib.mkForce` sparingly, only when overriding a default value that cannot be changed otherwise.
- **Comments**:
  - Use `##` for section headers within Nix files to maintain visual hierarchy.
  - Use `#` for single-line explanations.
  - Do not add excessive comments that explain obvious Nix syntax.

### Formatting

- **Indentation**: Use 2 spaces.
- **Braces**: Use the K&R style (opening brace on the same line).
- **Trailing Commas**: Use trailing commas in lists and attribute sets to make diffs cleaner when adding new items.

## 🔍 Troubleshooting

- If a flake evaluation fails, check `flake.lock` for dependency mismtrashes and ensure all `inputs` are correctly defined in `flake.nix`.
- If a package is not found, verify if it requires an additional input or if it's available in the current `nixpkgs` version.