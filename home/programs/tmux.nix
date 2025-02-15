{ ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    extraConfig = ''
      unbind-key C-o
      bind-key C-o select-pane -t :.+
    '';
  };
}
