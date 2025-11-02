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
