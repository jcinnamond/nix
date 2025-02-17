{ config, ... }:
let
  colors = config.style.colors.scheme;
in

{
  programs.zsh = with colors; {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    defaultKeymap = "vicmd";
    sessionVariables = {
      ABBR_SET_EXPANSION_CURSOR = 1;
    };
    syntaxHighlighting.enable = true;
    zsh-abbr = {
      enable = true;
      abbreviations = {
        dev = "nix develop";
        flake = "nix flake";
        ns = "nix search nixpkgs";
        nsh = "nix shell nixpkgs#%";
        switch = "sudo nixos-rebuild --flake ~/nixos switch";
      };
    };
    initExtra = ''
      autoload -Uz vcs_info
      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:*' check-for-changes true
      zstyle ':vcs_info:*' unstagedstr '+'
      zstyle ':vcs_info:*' stagedstr '*'
      zstyle ':vcs_info:*' formats "%b %u%c"

      function _prompt_powerline {
        local s=$1
        local bg=$2
        local fg=$3
        local nextBg=$3
        echo "%K{$bg}%F{$fg}$s%f %F{$nextBg}%f%k"
      }

      function nix_shell() {
        if test -n "$IN_NIX_SHELL";
        then echo "%K{#${bg2}}nix shell %k" 
        fi
      }

      precmd() { vcs_info nix_shell }
      setopt PROMPT_SUBST
      NEWLINE=$'\n'
      PROMPT=' ''${NEWLINE}%(1j.%F{#${fg1}}[%j] %f.)%F{#${cyan}}%~%f''${NEWLINE}$(nix_shell)%(?.%K{#${bg2}}.%K{#${alert}})%F{#${bg}}%f%k '
      RPROMPT='%F{#${fg1}}(''${vcs_info_msg_0_})%f'
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
