return {
  "mrcjkb/rustaceanvim",
  opts = {
    server = {
      default_settings = {
        ["rust-analyzer"] = {
          -- Add clippy lints for Rust.
          checkOnSave = {
            allFeatures = true,
            command = "clippy",
            extraArgs = {
              "--",
              "--no-deps",
              "-Dclippy::correctness",
              "-Dclippy::complexity",
              "-Wclippy::perf",
              "-Wclippy::pedantic",
            },
          },
        },
      },
    },
  },
}
