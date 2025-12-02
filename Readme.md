
# KiTTY

> KiTTY is a handy Console Toolkit

<img width="634" height="373" alt="cmd_show" src="https://github.com/user-attachments/assets/7e3d0165-5850-4846-a9c6-3e29eeb061b5" />

## Intro

**KiTTY** 🐱 is more than just a set of command-line tools.

It is design to be a concept of minimal tty env.

You can customize it your self. Using your favorite console Apps. And also adding additional libraries into.

## Features

Since **KiTTY** is designed to provide a **rack**, instead of a full or real **terminal**. You should fulfill your environment by your hand.

* **🦴 Minimalist Core:** The original **KiTTY** provides a tiny rack.
* **🛠️ Highly Customizable:** All enhancements and components are designed to be plug-and-play and extensible. Enable only what you need, with zero redundancy.
* **💻 Enhencement:** `Clink` boost up an env like `bash-it` to give you enhencement experience in terminal.
* **🔌 Seamless Integration:** Just adding something into `opt/` and export them by editing the profile in `etc/`.

## Quick Start: Activating Your KiTTY

### Start Directly

Just double click `kitty.bat` and it will automatically start.

### On Your Terminal

First, choose the terminal emulator you prefer (Maybe Windows Terminal, and etc.).

Then setting the initialization config in your terminal:

```cmd
cmd /k C:\kitty\lib\kitty\init.bat
```

> 💡 This will load **KiTTY**'s environment and tools.

## Extension and Customization

The best way to use **KiTTY** is customization it your self.

### 1. **Enhancing Your PATH (Adding Tools to Path)**

Edit `profile.cmd` and other `.cmd` files in the `etc\` directory to manage your environment variables.

### 2. **Custom Themes**

Edit `kitty_prompt_config.lua` to customize the terminal interface the you want.

### 3. **Adding Optional Components**

Place any third-party or self-made components you wish to integrate into the `opt/` and `bin/` directory.

* **For example:**
  1.  Put your component (e.g., `fzf`, `neovim`, etc.) inside the `opt/` directory.
  2.  Create a configuration file in `etc/profile.d/` (e.g., `opt_neovim.cmd`).
  3.  Edit the `opt_neovim.cmd` and `set "PATH=%KITTY_ROOT%\opt\opt_neovim\bin;%PATH%"` to add the component's executable directory into your `PATH`.

## Directory Structure

This is a simple description of the structure below:

| Directory | Description |
| :--- | :--- |
| `bin/` | binary executable or scripts put here. |
| `etc/` | configuration files goes here. |
| `etc/defaults/` | some essential configuration files, such as default settings for **Clink**. |
| `lib/` | libraries goes here. |
| `opt/` | The external components for the goes here. |

## Acknowledges

This project is inspired and derived from `cmder`.

There's some reason why KiTTY:

- Since `ConEmu` is out of dates and its fallback font rendering of Unicode doesn't works good.
- `cmder` is too heavily to customize with a bunch of utilities not needed.
- Give the rights back to the users choosing their components.
