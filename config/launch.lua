local platform = require('utils.platform')
local wezterm = require('wezterm')

---@type Config
local options = {
   default_prog = {},
   launch_menu = {},
}

if platform.is_win then
   local home = wezterm.home_dir
   local git_bash = home .. '\\scoop\\apps\\git\\current\\bin\\bash.exe'

   options.default_prog = { 'pwsh', '-NoLogo' }
   options.launch_menu = {
      { label = 'PowerShell Core', args = { 'pwsh', '-NoLogo' } },
      { label = 'PowerShell Desktop', args = { 'powershell' } },
      { label = 'Command Prompt', args = { 'cmd' } },
      { label = 'Nushell', args = { 'nu' } },
      { label = 'Msys2', args = { 'ucrt64.cmd' } },
      {
         label = 'Git Bash',
         args = { git_bash },
      },
   }
elseif platform.is_mac then
   options.default_prog = { 'zsh', '-l' }
   options.launch_menu = {
      { label = 'Zsh', args = { 'zsh', '-l' } },
      { label = 'Bash', args = { 'bash', '-l' } },
   }
elseif platform.is_linux then
   options.default_prog = { 'zsh', '-l' }
   options.launch_menu = {
      { label = 'Zsh', args = { 'zsh', '-l' } },
      { label = 'Bash', args = { 'bash', '-l' } },
   }
end

return options
