{ config, ... }:
let
  colors = config.style.colors.withHash;
  zshConfigDir = config.xdg.configHome + "/zsh";
in
{
  home.file."${zshConfigDir}/conf.d".source = ./conf.d;
  xdg.configFile."zsh/colors.zsh".text = with colors; ''
    color_bg=${bg}
    color_fg=${bg}
    color_success=${green}
    color_error=${red}
    color_prompt_previous=${fg1}
    color_cwd_bg=${bg}
    color_cwd_fg=${blue}
    color_git_clean_bg=${bg}
    color_git_clean_fg=${fg1}
    color_git_dirty_bg=${bg}
    color_git_dirty_fg=${red}
    color_nix_shell_bg=${bg}
    color_nix_shell_fg=${fg1}
  '';

  programs.zsh = {
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
    initContent = ''
      source ${zshConfigDir}/colors.zsh
      if test -d ${zshConfigDir}/conf.d; then
        for file in ${zshConfigDir}/conf.d/*.zsh; do
          source $file
        done
      fi
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
