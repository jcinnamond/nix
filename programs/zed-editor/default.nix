{ config, pkgs, ... }:
let
  fonts = config.style.fonts;
in
{
  home.packages = with pkgs; [
    package-version-server
  ];

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "haskell"
    ];
    mutableUserSettings = true; # for now -- I'll want to make this false later
    userSettings = with fonts; {
      base_keymap = "VSCode";
      helix_mode = true;
      vim_mode = true;

      buffer_font_family = "${nerdfont}";
      buffer_font_size = 14;

      soft_wrap = "editor_width";
      wrap_guides = [
        80
        120
      ];

      scrollbar = {
        selected_text = false;
        git_diff = false;
      };

      terminal = {
        dock = "right";
        button = false;
        font_size = 14;
      };

      languages = {
        "Nix" = {
          language_servers = [
            "nil"
            "!nixd"
          ];
        };
      };
      lsp = {
        hls = {
          initialization_options = {
            formattingProvider = "fourmolu";
          };
        };
        nil = {
          settings = {
            autoArchive = true;
          };
        };
      };

      active_pane_modifiers.inactive_opacity = 0.7;
      collaboration_panel.button = false;
      debugger.button = false;
      diagnostics.button = true;
      git.inline_blame.enabled = false;
      git_panel.button = false;
      gutter.breakpoints = false;
      outline_panel.button = false;
      project_panel = {
        button = false;
        dock = "right";
      };
      search.button = false;
      title_bar = {
        show_onboarding_banner = true; # for now -- we'll see how this goes
        show_sign_in = false;
        show_user_picture = false;
        show_project_items = true;
        show_branch_icon = false;
      };
      toolbar = {
        breadcrumbs = true;
        code_actions = false;
        quick_actions = false;
        selections_menu = true;
      };
      tab_bar = {
        show = false;
      };
      diagnostics = {
        inline = {
          enabled = true;
          max_severity = "warning";
        };
      };

      auto_update = false;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      agent = {
        enabled = true;
        button = true;
      };

      agent_servers = {
        gemini = {
          ignore_system_version = false;
        };
      };

      theme = {
        mode = "system";
        light = "One Light";
        dark = "jc dark";
      };
    };
    mutableUserKeymaps = false;
    userKeymaps = [
      {
        bindings = {
          ctrl-' = "editor::SelectLargerSyntaxNode";
          ctrl-alt-super-' = "editor::SelectSmallerSyntaxNode";
          ctrl-d = "editor::SelectNext";
          alt-b = "workspace::ToggleLeftDock";
        };
      }
      {
        context = "((vim_mode == helix_normal || vim_mode == helix_select) && !menu)";
        bindings = {
          "space w m" = "pane::JoinAll";
          "space w w" = "workspace::ActivateNextPane";
          "space w a" = "editor::ToggleFocus";
        };
      }
    ];
  };

  imports = [ ./theme.nix ];
}
