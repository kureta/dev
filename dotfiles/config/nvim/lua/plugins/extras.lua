return {
  -- Languages
  { import = "lazyvim.plugins.extras.lang.docker" },
  { import = "lazyvim.plugins.extras.lang.git" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.python" },
  -- { import = "lazyvim.plugins.extras.lang.toml" },
  -- { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.yaml" },

  -- LSP
  { import = "lazyvim.plugins.extras.lsp.none-ls" },

  -- Coding
  -- { import = "lazyvim.plugins.extras.coding.copilot" },
  -- { import = "lazyvim.plugins.extras.coding.copilot-chat" },
  { import = "lazyvim.plugins.extras.coding.mini-comment" },
  { import = "lazyvim.plugins.extras.coding.mini-surround" },

  -- Debugging
  -- { import = "lazyvim.plugins.extras.dap.nlua" },
  -- { import = "lazyvim.plugins.extras.dap.core" },

  -- Formatting
  { import = "lazyvim.plugins.extras.formatting.prettier" },

  -- UI
  { import = "lazyvim.plugins.extras.ui.treesitter-context" },
}
