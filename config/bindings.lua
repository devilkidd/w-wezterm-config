local wezterm = require('wezterm')
local platform = require('utils.platform')
local backdrops = require('utils.backdrops')
local act = wezterm.action

local mod = {}

if platform.is_mac then
   mod.SUPER = 'SUPER'
   mod.SUPER_REV = 'SUPER|CTRL'
elseif platform.is_win or platform.is_linux then
   mod.SUPER = 'ALT' -- to not conflict with Windows key shortcuts
   mod.SUPER_REV = 'ALT|CTRL'
end

local copy_mod = platform.is_mac and 'SUPER' or 'CTRL'

local function hide_window(window, pane)
   if platform.is_mac then
      window:perform_action(act.HideApplication, pane)
   else
      window:perform_action(act.Hide, pane)
   end
end

local function smart_copy_action()
   return wezterm.action_callback(function(window, pane)
      local selected = window:get_selection_text_for_pane(pane)
      if selected and selected ~= '' then
         window:perform_action(act.CopyTo('Clipboard'), pane)
         return
      end
      window:perform_action(act.SendKey({ key = 'c', mods = 'CTRL' }), pane)
   end)
end

local function smart_close_action()
   return wezterm.action_callback(function(window, pane)
      local mux_window = window:mux_window()
      local mux_tabs = mux_window:tabs()

      if #mux_tabs <= 1 then
         hide_window(window, pane)
      else
         window:perform_action(act.CloseCurrentPane({ confirm = false }), pane)
      end
   end)
end

local function open_selected_url_action()
   return wezterm.action_callback(function(window, pane)
      local url = window:get_selection_text_for_pane(pane)
      if not url or url == '' then
         window:toast_notification('WezTerm', 'No URL selected', nil, 1200)
         return
      end
      wezterm.log_info('opening: ' .. url)
      wezterm.open_with(url)
   end)
end

-- stylua: ignore
---@type Key[]
local keys = {
   -- misc/useful --
   { key = 'F1', mods = 'NONE', action = act.ActivateCopyMode },
   { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
   { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
   { key = 'F4', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },
   {
      key = 'F5',
      mods = 'NONE',
      action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
   },
   { key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },
   { key = 'F12', mods = 'NONE',    action = act.ShowDebugOverlay },
   { key = 'f',   mods = mod.SUPER, action = act.Search({ CaseInSensitiveString = '' }) },
   {
      key = 'u',
      mods = mod.SUPER_REV,
      action = wezterm.action.QuickSelectArgs({
         label = 'open url',
         patterns = {
            '\\((https?://\\S+)\\)',
            '\\[(https?://\\S+)\\]',
            '\\{(https?://\\S+)\\}',
            '<(https?://\\S+)>',
            '\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
         },
         action = open_selected_url_action(),
      }),
   },

   -- cursor movement --
   { key = 'LeftArrow',  mods = mod.SUPER,     action = act.SendString('\u{1b}OH') },
   { key = 'RightArrow', mods = mod.SUPER,     action = act.SendString('\u{1b}OF') },
   { key = 'Backspace',  mods = mod.SUPER,     action = act.SendString('\u{15}') },

   -- copy/paste --
   { key = 'c',          mods = copy_mod,      action = smart_copy_action() },
   { key = 'v',          mods = copy_mod,      action = act.PasteFrom('Clipboard') },
   { key = 'c',          mods = 'CTRL|SHIFT',  action = act.CopyTo('Clipboard') },
   { key = 'v',          mods = 'CTRL|SHIFT',  action = act.PasteFrom('Clipboard') },

   { key = 'n',          mods = 'CTRL|SHIFT',  action = act.SendString('\u{2660}') },
   { key = 's',          mods = 'CTRL|SHIFT',  action = act.SendString('\u{203D}') },

   -- tabs --
   -- tabs: spawn+close
   { key = 't',          mods = mod.SUPER,     action = act.SpawnTab('DefaultDomain') },
   { key = 'w',          mods = mod.SUPER_REV, action = act.CloseCurrentPane({ confirm = false }) },

   -- tabs: navigation
   { key = '[',          mods = mod.SUPER,     action = act.ActivateTabRelative(-1) },
   { key = ']',          mods = mod.SUPER,     action = act.ActivateTabRelative(1) },
   { key = '[',          mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
   { key = ']',          mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },

   -- tab: title
   { key = '0',          mods = mod.SUPER,     action = act.EmitEvent('tabs.manual-update-tab-title') },
   { key = '0',          mods = mod.SUPER_REV, action = act.EmitEvent('tabs.reset-tab-title') },

   -- tab: hide tab-bar
   { key = '9',          mods = mod.SUPER,     action = act.EmitEvent('tabs.toggle-tab-bar'), },

   -- window --
   -- window: hide window (Cmd+H on macOS, Alt+H elsewhere)
   {
      key = 'h',
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, pane)
         hide_window(window, pane)
      end),
   },
   -- window: close window (Cmd+Q on macOS)
   { key = 'q',          mods = mod.SUPER,     action = act.QuitApplication },
   -- window: spawn windows
   { key = 'n',          mods = mod.SUPER,     action = act.SpawnWindow },

   {
      key = 'Enter',
      mods = mod.SUPER_REV,
      action = wezterm.action_callback(function(window, _pane)
         window:maximize()
      end)
   },


   -- panes --
   -- panes: split panes
   {
      key = [[\]],
      mods = mod.SUPER,
      action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
   },
   {
      key = [[\]],
      mods = mod.SUPER_REV,
      action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
   },

   -- panes: zoom+close pane
   { key = 'Enter', mods = mod.SUPER,     action = act.TogglePaneZoomState },
   { key = 'w',     mods = mod.SUPER,     action = smart_close_action() },

   -- panes: navigation
   { key = 'k',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Up') },
   { key = 'j',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Down') },
   { key = 'h',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Left') },
   { key = 'l',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Right') },
   {
      key = 'p',
      mods = mod.SUPER_REV,
      action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }),
   },

   -- panes: scroll pane
   { key = 'u',        mods = mod.SUPER, action = act.ScrollByLine(-5) },
   { key = 'd',        mods = mod.SUPER, action = act.ScrollByLine(5) },
   { key = 'PageUp',   mods = 'NONE',    action = act.ScrollByPage(-0.75) },
   { key = 'PageDown', mods = 'NONE',    action = act.ScrollByPage(0.75) },

   -- key-tables --
   -- resizes fonts
   {
      key = 'f',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_font',
         one_shot = false,
         timeout_milliseconds = 3000,
      }),
   },
   -- resize panes
   {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_pane',
         one_shot = false,
         timeout_milliseconds = 3000,
      }),
   },
   -- key help panel
   {
      key = 'F1',
      mods = 'LEADER',
      action = act.ShowLauncherArgs({ flags = 'FUZZY|KEY_ASSIGNMENTS' }),
   },
   -- window size
   {
      key = 'w',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_window',
         one_shot = false,
         timeout_milliseconds = 3000,
      }),
   },
   -- background controls
   {
      key = 'b',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'background',
         one_shot = false,
         timeout_milliseconds = 3000,
      }),
   },
}

-- Windows: WSL tab spawn
if platform.is_win then
   table.insert(keys, { key = 't', mods = mod.SUPER_REV, action = act.SpawnTab({ DomainName = 'wsl:ubuntu-fish' }) })
end

-- stylua: ignore
---@type table<string, Key[]>
local key_tables = {
   resize_font = {
      { key = 'k',      action = act.IncreaseFontSize },
      { key = 'j',      action = act.DecreaseFontSize },
      { key = 'r',      action = act.ResetFontSize },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
   resize_pane = {
      { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
   resize_window = {
      {
         key = '-',
         action = wezterm.action_callback(function(window, _pane)
            local dimensions = window:get_dimensions()
            if platform.is_win or dimensions.is_full_screen then
               return
            end
            local new_width = dimensions.pixel_width - 50
            local new_height = dimensions.pixel_height - 50
            window:set_inner_size(new_width, new_height)
         end),
      },
      {
         key = '=',
         action = wezterm.action_callback(function(window, _pane)
            local dimensions = window:get_dimensions()
            if platform.is_win or dimensions.is_full_screen then
               return
            end
            local new_width = dimensions.pixel_width + 50
            local new_height = dimensions.pixel_height + 50
            window:set_inner_size(new_width, new_height)
         end),
      },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
   background = {
      {
         key = '/',
         action = wezterm.action_callback(function(window, _pane)
            backdrops:random(window)
         end),
      },
      {
         key = ',',
         action = wezterm.action_callback(function(window, _pane)
            backdrops:cycle_back(window)
         end),
      },
      {
         key = '.',
         action = wezterm.action_callback(function(window, _pane)
            backdrops:cycle_forward(window)
         end),
      },
      {
         key = 's',
         action = act.InputSelector({
            title = 'InputSelector: Select Background',
            choices = backdrops:choices(),
            fuzzy = true,
            fuzzy_description = 'Select Background: ',
            action = wezterm.action_callback(function(window, _pane, idx)
               if not idx then
                  return
               end
               ---@diagnostic disable-next-line: param-type-mismatch
               backdrops:set_img(window, tonumber(idx))
            end),
         }),
      },
      {
         key = 'b',
         action = wezterm.action_callback(function(window, _pane)
            backdrops:toggle_focus(window)
         end),
      },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
}

---@type MouseBinding[]
local mouse_bindings = {
   -- Ctrl-click will open the link under the mouse cursor
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
   },
}

---@type Config
return {
   disable_default_key_bindings = true,
   -- disable_default_mouse_bindings = true,
   leader = { key = 'Space', mods = mod.SUPER_REV, timeout_milliseconds = 3000 },
   keys = keys,
   key_tables = key_tables,
   mouse_bindings = mouse_bindings,
}
