{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting ;
    '';
    shellAbbrs = {
      dev = "nix develop";
      ns = "nix search nixpkgs";
      nsh = {
        setCursor = true;
        expansion = "nix shell nixpkgs#%";
      };
      nixup = "sudo nixos-rebuild --flake ~/nixos switch";
    };
    functions = {
      fish_prompt = ''
        set -l nix_shell_info (
          if test -n "$IN_NIX_SHELL" || test $SHLVL -gt 2 # for some reason SHLVL seems to be 2 for a normal shell
             printf "%snix-shell >> %s " (set_color $fish_color_comment) (set_color normal)
          end
        )
        set -l jobs (jobs | wc -l)
        set -l jobs_info (
          if test $jobs -ne 0
            printf "[%s] " $jobs
          end
        )
        string join "" -- $jobs_info $nix_shell_info (prompt_pwd) ' > '
      '';
      fish_right_prompt = ''
        set -g __fish_git_prompt_showdirtystate true
        set -g __fish_git_prompt_showuntrackedfiles true
        string join "" -- (set_color $fish_color_cwd) (fish_git_prompt)
      '';
    };
  };
}
