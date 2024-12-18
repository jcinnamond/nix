{ ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        geometry = "600x50-50+65";
        shrink = "yes";
        transparency = 5;
        padding = 8;
        horizontal_padding = 16;
        # font = "MonoLisaJc Nerd Font 10";
        line_height = 4;
        frame_width = 1;
        corner_radius = 15;
        separator_height = 2;
      };
    };
  };
}
