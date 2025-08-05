{ pkgs, config, ... }:
let
  colors = config.style.colors.scheme;
in
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting ;
      enableTheme ;
    '';
    plugins = with pkgs.fishPlugins; [
      {
        name = "fzf";
        src = fzf.src;
      }
      {
        name = "z";
        src = z.src;
      }
    ];
    shellAbbrs = {
      dev = "nix develop";
      flake = "nix flake";
      ns = "nix search nixpkgs";
      nsh = {
        setCursor = true;
        expansion = "nix shell nixpkgs#%";
      };
      nixup = "sudo nixos-rebuild --flake ~/nixos switch";
    };
    functions = {
      "_prompt_powerline" = {
        argumentNames = [
          "s"
          "bg"
          "fg"
          "nextBg"
        ];
        body = ''
          string join "" -- \
            (set_color -b $bg $fg) $s ' ' \
            (set_color $nextBg) '' \
            (set_color -b $nextBg)
        '';
      };
      fish_prompt = with colors; ''
        set -l promptbg (
          if test $status -eq 0
            printf $fish_color_prompt_bg
          else
            printf ${alert}
          end
        )

        set -l nix_shell_info (
          if test -n "$IN_NIX_SHELL" 
            _prompt_powerline "nix shell " $fish_color_prompt2_bg $fish_color_prompt2_fg $promptbg
          end
        )

        set -l pwd (_prompt_powerline (prompt_pwd) $promptbg $fish_color_prompt_fg ${bg}) \

        set -l jobs_info (
          set -l jobcount (jobs | wc -l)
          if test $jobcount -gt 0
            string join "" -- (set_color ${fg1}) "[" $jobcount "] " (set_color normal)
          end
        )

        string join "" -- \
          $jobs_info \
          $nix_shell_info \
          $pwd \
          (set_color normal) ' '
      '';
      fish_right_prompt = with colors; ''
        set -g __fish_git_prompt_showdirtystate true
        set -g __fish_git_prompt_showuntrackedfiles true
        string join "" -- (set_color ${fg1}) (fish_git_prompt)
      '';

      enableTheme = with colors; ''
        set --universal fish_color_autosuggestion ${fg2} 
        set --universal fish_color_command        ${cyan-light} 
        set --universal fish_color_comment        ${fg1} 
        set --universal fish_color_cwd            ${yellow} 
        set --universal fish_color_end            ${yellow} 
        set --universal fish_color_error          ${red-light} 
        set --universal fish_color_escape         ${fg} 
        set --universal fish_color_match          ${blue-dark} 
        set --universal fish_color_normal         ${fg} 
        set --universal fish_color_operator       ${fg}
        set --universal fish_color_param          ${fg}
        set --universal fish_color_quote          ${fg0}
        set --universal fish_color_redirection    ${fg}
        set --universal fish_color_search_match   --background ${selection}
        set --universal fish_color_selection      ${fg}

        set --universal fish_color_cancel         ${fg}
        set --universal fish_color_host           ${fg1}
        set --universal fish_color_host_remote    ${fg1}
        set --universal fish_color_user           ${fg1}

        set --universal fish_color_prompt_fg ${fg}
        set --universal fish_color_prompt_bg ${bg2}
        set --universal fish_color_prompt2_fg ${fg0}
        set --universal fish_color_prompt2_bg ${bg0}
      '';
    };
  };
}
