{ config, ... }:
let
  colors = config.style.colors.withHash;
in

{
  programs.zsh = with colors; {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    defaultKeymap = "viins";
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
    initExtraFirst = ''
      color_bg=${bg}
      color_fg=${bg}
      color_success=${green}
      color_error=${red}
      color_prompt_previous=${fg1}
      color_cwd_bg=${blue-dark}
      color_cwd_fg=${fg}
      color_git_clean_bg=${bg2}
      color_git_clean_fg=${fg}
      color_git_dirty_bg=${red-dark}
      color_git_dirty_fg=${fg}
      color_nix_shell_bg=${bg1}
      color_nix_shell_fg=${fg1}
    '';
    initExtra = builtins.readFile ./zshrc;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
