{ config, ... }:
let
  colors = config.style.colors.scheme;
in
{
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    extraConfig = with colors; ''
      unbind-key C-o
      bind-key C-o select-pane -t :.+
      bind-key r source-file ~/.config/tmux/tmux.conf
      set -g bell-action none

      set -g status-style bg="#${bg0}",fg="#${fg}"
      set -g status-left " "
      set -g status-right "#[fg=#${bg0},bg=#${bg1}] #[fg=#${fg1}]#{session_name} "
      set -g window-status-current-format "#[fg=#${bg0},bg=#${selection}]#[fg=#${fg},bg=#${selection}] #{window_index}:#{window_name} #[bg=#${selection},fg=#${bg0}]"
      set -g window-status-format "#[fg=#${fg1},bg=#${bg0}] #{window_index}:#{window_name} "
      set -g window-status-separator ""

      set -g pane-active-border-style fg=#${selection}

      setw -g mode-style fg=#${bg},bg=#${yellow}
    '';
  };
}
