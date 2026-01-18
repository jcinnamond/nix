{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "John Cinnamond";
        email = "john@cinnamond.me.uk";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      help.autocorrect = "prompt";
      commit.verbose = true;
      alias = {
        c = "commit --patch";
        fixup = "commit --amend --no-edit";
      };
    };
    ignores = [
      "dist-newstyle"
    ];
  };
}
