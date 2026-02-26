# 🛠️ archdots-installer

`archdots-installer` is a streamlined automation script designed to bootstrap a complete Arch Linux workstation from a bare-metal state. 

It handles the initial system update, deploys the high-performance [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) framework, and automatically injects regional hardware configurations (UK Layout) to ensure the system is production-ready in a single execution.

---

## 🚀 Key Features

- **Automated Dependency Management:** Detects and installs essential system tooling (Git, Curl) before executing the main payload.
- **Ecosystem Integration:** Seamlessly fetches and executes the official `dots-hyprland` installer, leveraging community-vetted "usability-first" dotfiles.
- **Hardware-Specific Tweaking:** Automates post-installation configuration of the `hyprland.conf` to set the `gb` keyboard layout, eliminating manual intervention.
- **Zero-Config Workflow:** Reduces a multi-step "rice" setup into a idempotent, one-command process.

---

## 💻 Usage

> **Note:** Designed for fresh Arch Linux installations.

```bash
curl -L https://raw.githubusercontent.com/Kalmai221/ArchDots-Installer/refs/heads/main/run.sh | bash

```

---

## 📈 Technical Impact (CV Context)

This project demonstrates core competencies in:

* **Shell Scripting:** Writing clean Bash scripts that handle remote resource fetching and file manipulation (Heredocs).
* **System Administration:** Automating OS-level configurations and package management via `pacman`.
* **DevOps Logic:** Implementing automated setup scripts to achieve a reproducible development environment.

---

## 📫 Reach Me

* **Portfolio:** [klhportfolio.vercel.app](https://www.google.com/search?q=https://klhportfolio.vercel.app)
* **LinkedIn:** [In/kurtishopewell](https://www.google.com/search?q=https://www.linkedin.com/in/kurtishopewell/)
