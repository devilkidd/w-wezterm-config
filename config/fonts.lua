local wezterm = require('wezterm')
local platform = require('utils.platform')

local primary_font = 'JetBrainsMono Nerd Font'
if platform.is_mac then
   primary_font = 'JetBrainsMono Nerd Font'
elseif platform.is_linux then
   primary_font = 'JetBrainsMono Nerd Font'
elseif platform.is_win then
   primary_font = 'JetBrainsMono Nerd Font'
end

local fallback_fonts = {
   primary_font,
   'Maple Mono NF',
   'Sarasa Mono SC',
   'Noto Sans Mono CJK SC',
   'Symbols Nerd Font Mono',
}

local font_size = platform.is_mac and 12 or 9.75

---@type Config
return {
   font = wezterm.font_with_fallback(fallback_fonts),
   font_size = font_size,
   font_rules = {
      {
         intensity = 'Bold',
         font = wezterm.font_with_fallback(fallback_fonts),
      },
   },

   --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
   freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
