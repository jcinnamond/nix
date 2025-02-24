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
      bind-key \{ copy-mode
      bind-key \} paste-buffer -p
      bind-key [ swap-pane -U
      bind-key ] swap-pane -D

      set -g bell-action none

      set-option -g status-position top

      set -g status-style bg="#${bg}",fg="#${fg}"
      set -g status-left " "
      set -g status-right "#[fg=#${bg1},bg=#${bg}]#[fg=#${fg1},bg=#${bg1}]#{session_name} "
      set -g window-status-current-format "#[fg=#${selection},bg=#${bg}]#[fg=#${fg},bg=#${selection}]#{window_index}:#{window_name}#[bg=#${bg},fg=#${selection}]"
      set -g window-status-format "#[fg=#${fg1},bg=#${bg}] #{window_index}:#{window_name} "
      set -g window-status-separator " "

      set -g pane-active-border-style fg=#${selection}

      setw -g mode-style fg=#${bg},bg=#${yellow}
    '';
  };
}
