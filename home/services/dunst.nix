{ ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        geometry = "600x50-50+65";
        shrink = "yes";
        padding = 8;
        horizontal_padding = 16;
        line_height = 4;
        frame_width = 0;
        corner_radius = 15;
        separator_height = 2;
      };
    };
  };
}
