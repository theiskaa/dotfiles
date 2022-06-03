local M = {}

function M.config()
  local g = vim.g
  local fn = vim.fn

  local plugins_count = fn.len(vim.fn.globpath(fn.stdpath "data" .. "/site/pack/packer/start", "*", 0, 1))

  g.dashboard_disable_statusline = 1
  g.dashboard_default_executive = "telescope"
  g.dashboard_custom_header = {
    "        _                  ",
    "       (_)   _____   _____ ",
    "      / /   / ___/  / ___/ ",
    "     / /   (__  )  (__  )  ",
    "    /_/   /____/  /____/   ",
    " ",
  }

  g.dashboard_custom_section = {
    a = { description = { "   Find File                 , ff" }, command = "Telescope find_files" },
    b = { description = { "   Recents                   , fo" }, command = "Telescope oldfiles" },
    c = { description = { "   Find Word                 , fw" }, command = "Telescope live_grep" },
    d = { description = { "   New File                  , fn" }, command = "DashboardNewFile" },
    e = { description = { "   Bookmarks                 , bm" }, command = "Telescope marks" },
    f = { description = { "   Last Session              , sl" }, command = "SessionLoad" },
  }

  g.dashboard_custom_footer = {
    "      Loaded " .. plugins_count .. " plugins ",
    "      Source > github.com/theiskaa/dotfiles",
  }
end

return M
