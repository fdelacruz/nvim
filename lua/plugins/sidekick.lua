return {
  "folke/sidekick.nvim",
  event = "VeryLazy",
  opts = {
    nes = { enabled = false },
    cli = {
      mux = {
        enabled = true,
        backend = "tmux",
      },
    },
  },
}
