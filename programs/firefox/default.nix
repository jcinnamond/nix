{ pkgs, ... }:
{
  config.programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      SearchBar = "unified";
    };
    profiles."john" = {
      isDefault = true;
      bookmarks = {
        force = true;
        settings = [
          {
            name = "hoogle";
            url = "hoogle.haskell.org";
          }
        ];
      };
      search = {
        force = true;
        default = "ddg";

        engines = {
          nix-packages = {
            name = "Nix Packages";
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          hoogle = {
            name = "Hoogle";
            urls = [
              {
                template = "https://hoogle.haskell.org/";
                params = [
                  {
                    name = "hoogle";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "@hoo" ];
          };
          hackage = {
            name = "Hackage";
            urls = [
              {
                template = "https://hackage.haskell.org/packages/search";
                params = [
                  {
                    name = "terms";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "@h" ];
          };
        };
      };
      extensions = {
        force = true;
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          consent-o-matic
          darkreader
          onepassword-password-manager
          ublock-origin
        ];
      };
      settings = {
        # restore pages on restart
        "browser.startup.page" = 3;
        "browser.warnOnQuit" = false;
        "browser.warnOnQuitShortcut" = false;

        # shamelessly stolen from https://github.com/yozhgoor/nixos/blob/main/modules/firefox/default.nix

        # Disable first-launch phase
        "browser.disableResetPrompt" = true;
        "browser.download.panel.shown" = true;
        "browser.feeds.showFirstRunUI" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.rights.3.shown" = true;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.uitour.enabled" = false;
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "browser.bookmarks.addedImportButton" = true;
        "app.normandy.first_run" = false;

        # Clean new tab page
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

        # Disable telemetry
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.search.serpEventTelemetryCategorization.regionEnabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.usage.uploadEnabled" = false;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.prompted" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;

        # Enforce privacy
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.pbmode.enabled" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "dom.security.https_only_mode" = true;
        "network.http.sendRefererHeader" = 0;
        "network.cookie.cookieBehavior" = 1;

        # History
        "places.history.enabled" = true;

        # Disable "save password" prompt
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "signon.firefoxRelay.feature" = "disabled";
        "signon.generation.enabled" = false;

        # Set dark theme
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "layout.css.prefers-color-scheme.content-override" = 0;

        # Remove unwanted suggestions and shortcuts from URL bar
        "browser.urlbar.suggest.recentsearches" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.autoFill.adaptiveHistory.enabled" = true;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.urlbar.autoFill" = false;

        # Disable auto-fill on forms
        "dom.forms.autocomplete.formautofill" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "browser.formfill.enable" = false;

        # Disable pocket
        "extensions.pocket.enabled" = false;
      };
    };
  };
}
