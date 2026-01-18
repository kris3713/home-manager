{
  ## defaults
  config,
  ## extras
  inputs,
  ## user-defined variables
  pkgs,
  ...
}: let
  configHome = config.home;
  inherit (configHome) homeDirectory;

  userConfigDir = "${homeDirectory}/.config";
  inherit (pkgs) fishPlugins;
  fishDir = "${userConfigDir}/fish";
in {
  # Manage the fish shell using Nix and Home Manager.
  programs.fish = {
    enable = true;
    shellInit = ''
      # source other fish config
      source '${fishDir}/config.backup.fish'

      ## Shell completions creation
      # gut
      gut completion fish | source
      ## end of Shell completions creation
    '';

    plugins =
      ## fish plugins packaged in nixpkgs
      (with fishPlugins; [
        {
          # autopair.fish
          name = "autopair";
          src = autopair.src;
        }
        {
          # bass
          name = "bass";
          src = bass.src;
        }
        {
          # sdkman-for-fish
          name = "sdkman";
          src = sdkman-for-fish.src;
        }
        {
          # fzf.fish
          name = "fzf";
          src = fzf-fish.src;
        }
        # { # fifc
        #   name = "fifc";
        #   src = fifc.src;
        # }
      ])
      ++
      ## fish plugins not packaged in nixpkgs
      (with inputs; [
        {
          # completions.fish
          name = "completions";
          src = completions_fish;
        }
        {
          # fisher
          name = "fisher";
          src = fisher;
        }
        {
          # replay.fish
          name = "replay";
          src = replay_fish;
        }
        {
          # nix-completions.fish
          name = "nix_completions";
          src = nix-completions_fish;
        }
        {
          # nix.fish
          name = "nix";
          src = nix_fish;
        }
      ]);
  };
}
