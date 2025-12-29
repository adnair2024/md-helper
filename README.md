# md-helper.nvim

![Neovim](https://img.shields.io/badge/Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white) 


An ultra-lightweight Lua module for power-users who live in Markdown. Streamline your writing workflow in Neovim with intelligent helpers for tables, content structure, and assets.

## Features

- **📖 Smart Table of Contents**: Automatically scans your buffer and generates a nested, clickable Table of Contents based on your markdown headers (`#`).
- **📊 Dynamic Tables**: Create markdown tables instantly. No more manual pipe alignment—just specify rows and columns, and start typing.
- **🔗 Easy Assets**: Fast-path prompts for inserting hyperlinks and images with proper markdown syntax.
- **⚡ Lightweight**: Minimal code, maximum efficiency. Uses native `vim.ui` interfaces.

## Dependencies

This plugin is designed to work alongside **[render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)**.
While not strictly required for logic, without it, your markdown tables and UI elements won't look as pretty in the buffer.

## Installation

### [Lazy.nvim](https://github.com/folke/lazy.nvim)

Add the following block to your Neovim configuration (e.g., `lua/plugins/md-helper.lua` or inside your `init.lua`):

```lua
{
    "adnair2024/md-helper.nvim",
    dependencies = { 
        "MeanderingProgrammer/render-markdown.nvim",
    },
    ft = { "markdown" }, -- Load only on markdown files
    config = function()
        local md_helper = require("md-helper")
        
        -- Recommended Keybindings
        -- You can customize these keys to whatever fits your workflow
        
        -- Generate Table of Contents
        vim.keymap.set("n", "<leader>mc", md_helper.generate_toc, { desc = "Markdown: Create TOC" })
        
        -- Create Table (Prompts for Rows x Cols)
        vim.keymap.set("n", "<leader>mt", md_helper.create_table, { desc = "Markdown: Table" })
        
        -- Insert Link (Prompts for Text & URL)
        vim.keymap.set("n", "<leader>ml", md_helper.create_link, { desc = "Markdown: Link" })
        
        -- Insert Image (Prompts for Alt Text & Path)
        vim.keymap.set("n", "<leader>mi", md_helper.create_image, { desc = "Markdown: Image" })
    end
}
```

### [Which-Key.nvim](https://github.com/folke/which-key.nvim) Integration

If you prefer to define your mappings directly within `which-key`, you can use the following configuration to group and label everything neatly:

```lua
local wk = require("which-key")
local md = require("md-helper")

wk.add({
  { "<leader>m", group = "Markdown" },
  { "<leader>mc", md.generate_toc, desc = "Create TOC" },
  { "<leader>mi", md.create_image, desc = "Insert Image" },
  { "<leader>ml", md.create_link, desc = "Insert Link" },
  { "<leader>mt", md.create_table, desc = "Insert Table" },
})
```

## Usage Guide

### Table of Contents (`<leader>mc`)
Place your cursor where you want the TOC to appear (usually the top of the file).
1. Press `<leader>mc`.
2. The plugin scans headers (`#` to `######`).
3. It inserts a bulleted list with links to each section.

### Creating Tables (`<leader>mt`)
1. Press `<leader>mt`.
2. Enter the number of **Rows** (e.g., `4`).
3. Enter the number of **Columns** (e.g., `3`).
4. A pre-formatted markdown table grid is inserted at your cursor.

### Inserting Links (`<leader>ml`)
1. Press `<leader>ml`.
2. Enter the **Display Text** (what you see).
3. Enter the **URL**.
4. Result: `[Display Text](URL)`

### Inserting Images (`<leader>mi`)
1. Press `<leader>mi`.
2. Enter the **Alt Description**.
3. Enter the **Image URL** or **Local Path**.
4. Result: `![Alt Description](path/to/image.png)`

## Contributing

Pull requests are welcome! If you have ideas for new markdown helpers, feel free to open an issue or submit a PR.
