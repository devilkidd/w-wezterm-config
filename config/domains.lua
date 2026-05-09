local platform = require('utils.platform')

---@type Config
local options = {
   -- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
   ssh_domains = {},

   -- ref: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
   unix_domains = {},

   -- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
   wsl_domains = {},
}

if platform.is_win then
   local wsl_user = os.getenv('WEZTERM_WSL_USER') or 'kevin'
   local wsl_distro = os.getenv('WEZTERM_WSL_DISTRO') or 'Ubuntu'
   local wsl_home = '/home/' .. wsl_user

   options.ssh_domains = {
      {
         name = 'ssh:wsl',
         username = wsl_user,
         remote_address = 'localhost',
         multiplexing = 'None',
         default_prog = { 'fish', '-l' },
         assume_shell = 'Posix',
      },
   }

   options.wsl_domains = {
      {
         name = 'wsl:ubuntu-fish',
         distribution = wsl_distro,
         username = wsl_user,
         default_cwd = wsl_home,
         default_prog = { 'fish', '-l' },
      },
      {
         name = 'wsl:ubuntu-bash',
         distribution = wsl_distro,
         username = wsl_user,
         default_cwd = wsl_home,
         default_prog = { 'bash', '-l' },
      },
   }
end

return options
