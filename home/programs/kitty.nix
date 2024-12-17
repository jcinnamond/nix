{ ... }:
{
  programs.kitty = {
    enable = true;
    font.name = "MonoLisa jc";
    font.size = 12;
    shellIntegration.enableFishIntegration = true;
    keybindings = {
      "ctrl+tab" = "next_window";
    };
    settings = {
      enabled_layouts = "tall,stack";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };
  };
}
