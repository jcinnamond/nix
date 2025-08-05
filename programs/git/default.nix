{ ... }:
{
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
    aliases = {
      c = "commit --patch";
      fixup = "commit --amend --no-edit";
    };
  };
}
