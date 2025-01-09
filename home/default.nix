{ pkgs, ... }:

let
  haskellPackages = pkgs.haskell.packages.ghc982;
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jc";
  home.homeDirectory = "/home/jc";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    any-nix-shell
    bat
    bc
    feh
    jq
    kitty
    marksman
    ripgrep
    xsel

    haskellPackages.ghc
    haskellPackages.haskell-language-server
    haskellPackages.cabal-install
    haskellPackages.cabal-fmt
    haskellPackages.fourmolu

    nixfmt-rfc-style
    nil

    _1password-gui
    kuro
    libreoffice
    mpv
    pavucontrol
    pdftk
    playerctl
    signal-desktop
    simple-scan
    skypeforlinux
    spotify
    streamcontroller
    zathura

    font-awesome
    nerd-font-patcher
    gucharmap
  ];

  imports = [
    ./services/polybar/polybar.nix
    ./services/wired
    ./programs/fish.nix
    ./programs/gitu.nix
    ./programs/helix.nix
    ./programs/kitty.nix
    ./programs/rofi.nix
    ./programs/xmonad/xmonad.nix
    ./style/default.nix
  ];

  style.colors.schemeName = "jc";

  systemd.user.startServices = true;
  home.keyboard.layout = "gb";

  services.udiskie.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jc/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "hx";
    LESSUTFCHARDEF = "E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p"; # fixes bat/less showing unicode characters
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = [
      pkgs.obs-studio-plugins.obs-pipewire-audio-capture
    ];
  };

  programs.git = {
    enable = true;
    userName = "John Cinnamond";
    userEmail = "john@cinnamond.me.uk";
    extraConfig = {
      init.defaultBranch = "main";
    };
    ignores = [
      "dist-newstyle"
    ];
  };
}
