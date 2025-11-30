
# KiTTY

> KiTTY is a Console Toolkit

## Intro

**KiTTY** 🐱 is more than just a set of command-line tools; it is a philosophy—a terminal approach built on extreme minimalism, efficiency, and complete freedom of customization. Tired of bloated, over-prescriptive integrated terminals? **KiTTY** is your streamlined, integrated console **toolkit**, built just for you.

## Core Philosophy and Features

**KiTTY** is designed to provide a **Skeleton**, not a full-fledged **Terminal**. You retain **maximum control** over your environment.

  * **🦴 Minimalist Core:** **KiTTY** prioritizes simplicity and purity. We **do not pre-package any terminal emulator** (like ConEmu, Windows Terminal, etc.). Your terminal is defined by you\!
  * **🛠️ Highly Customizable:** All enhancements and components are designed to be plug-and-play and extensible. Enable only what you need, with zero redundancy.
  * **🔌 Seamless Integration:** Based on the **Cmd/PowerShell** environment, a clean initialization script (`init.bat`) is all it takes to inject **KiTTY**'s core functionality into any terminal environment you choose.

## Quick Start: Activating Your KiTTY

### 1\. Choose Your Terminal (Your Terminal, Your Choice)

First, select a terminal emulator you prefer (e.g., Windows Terminal, Fluent Terminal, Tabby, etc.).

### 2\. Initialize KiTTY

In your chosen terminal, simply run the initialization script located in the **KiTTY** root directory:

```bash
/path/to/kitty/init.bat
```

This will load **KiTTY**'s core environment and tools (like Clink autocompletion, essential aliases, etc.) into your current Shell session.

> **💡 Pro Tip:** You should integrate `init.bat` into your terminal's startup profile for automatic loading.

## \#\# Extension and Customization

The true power of **KiTTY** lies in its extensibility. All customization is centralized within the `config` and `opt` directories.

### 1\. **Enhancing Your PATH (Adding Tools to Path)**

Use `user_profile.cmd` or create custom `.cmd` files in the `profile.d\` directory to manage your environment variables.

  * **Basic Usage:** Leverage the utilities provided under `%lib_path%` for convenient path manipulation.

      * **Example:** Adding your custom tool directory `my_tool/bin`

    <!-- end list -->

    ```bash
    @REM Add the my_tool/bin directory to the PATH variable
    call "%lib_path%\enhance_path" "%kitty_root%\my_tool\bin"
    ```

### 2\. **Custom Scripts and Configurations (User Configuration)**

  * **`config/user_profile.cmd`:** Used for setting your environment variables, aliases, and personalized startup commands.
  * **`config/profile.d/`:** Place all your modular configuration scripts here. For instance, create separate configuration files for tools like Git or NodeJS for easy management and toggling.

### 3\. **Adding Optional Components (`opt` Directory)**

Place any third-party or self-made components you wish to integrate into the `opt/` directory.

  * **Workflow:**
    1.  Put your component (e.g., `fzf`, `neovim`, etc.) inside the `opt/` directory.
    2.  Create a configuration file in `config/profile.d/` (e.g., `opt_fzf.cmd`).
    3.  Use `enhance_path` to add the component's executable directory to your `PATH`.

## \#\# Directory Structure Overview

This is a clean yet powerful skeleton. **Always consult** the `README.md` within each directory for detailed information if you are unsure.

| Directory | Description |
| :--- | :--- |
| `bin/` | Houses the core binary dependencies for **KiTTY**. |
| `config/` | The core area for all configuration files, including `user_profile.cmd` and `profile.d/`. |
| `etc/` | Stores essential configuration files, such as default settings for **Clink**. |
| `lib/` | **KiTTY**'s core function library, containing utility scripts like `enhance_path`. |
| `opt/` | The **Optional Components** area. Used for storing external tools the user chooses to load. |

## Acknowledges

This project is inspired and derived from `cmder`.

There's some reason why KiTTY:

- Since `ConEmu` is out of dates and its fallback font rendering of Unicode doesn't works good.
- `cmder` is too heavily to customize with a bunch of utilities not needed.
- Give the rights back to the users choosing their components.
