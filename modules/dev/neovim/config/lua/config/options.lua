-- LazyVim only disables system clipboard sync when `SSH_TTY` is set
-- (`vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"`), but many
-- remote setups (tmux/screen re-attach, mosh, VS Code Remote, etc.) don't
-- set `SSH_TTY` even though there's no usable clipboard binary on the box.
-- In that case every yank/delete/paste calls out to a clipboard provider
-- (xclip/xsel/pbcopy/wl-copy) which can hang for a long time if it can't
-- reach a display/server, freezing the whole terminal.
--
-- Use the built-in OSC 52 provider instead whenever we detect a remote
-- session: it never spawns an external process (it just writes an escape
-- sequence for the terminal to interpret), so it can't hang waiting on a
-- clipboard tool or X/Wayland display.
local is_remote = vim.env.SSH_TTY or vim.env.SSH_CONNECTION or vim.env.SSH_CLIENT

if is_remote then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
  vim.opt.clipboard = "unnamedplus"
end
