{ pkgs, ... }:
let
  haskellPackages = pkgs.haskell.packages.ghc912;
in
{
  home.username = "jc";
  home.homeDirectory = "/home/jc";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  # Common packages that I want on any host
  home.packages = with pkgs; [
    any-nix-shell
    bat
    bc
    btop
    dysk
    feh
    ffmpeg
    file
    fzf
    jq
    kitty
    marksman
    ripgrep
    pastel
    xsel

    go

    haskellPackages.ghc
    haskellPackages.haskell-language-server
    haskellPackages.cabal-install
    haskellPackages.cabal-gild
    haskellPackages.fourmolu

    nixfmt-rfc-style
    nil

    _1password-gui
    libreoffice
    mpv
    pavucontrol
    pdftk
    playerctl
    signal-desktop
    simple-scan
    spotify
    zathura
    zoom-us
    zotero

    gucharmap

    inter-nerdfont
    monolisa-jc
  ];

  imports = [
    ../programs/firefox
    ../programs/git
    ../programs/helix
    ../programs/kitty
    ../programs/vscode
    ../programs/zsh

    ../modules/style
  ];

  style.colors.schemeName = "jc";
  home.file."wallpaper.png".source = ../modules/style/wallpapers/milky-way.png;

  systemd.user.startServices = true;
  home.keyboard.layout = "gb";

  services.udiskie.enable = true;

  home.sessionVariables = {
    EDITOR = "hx";
    LESSUTFCHARDEF = "E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p"; # fixes bat/less showing unicode characters
  };
}
