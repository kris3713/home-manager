{
  ## defaults
  config,
  ## extras
  inputs,
  ## user-defined variables
  pkgs,
  ...
}: let
  inherit (config.home) homeDirectory;

  userBinDir = "${homeDirectory}/.local/bin";
  userDataDir = "${homeDirectory}/.local/share";
  userConfigDir = "${homeDirectory}/.config";
in {
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = with inputs; {
    ## Scripts
    # restart-plasmashell
    "${userBinDir}/restart-plasmashell" = {
      text =
        # sh
        ''
          #!/usr/bin/env sh

          systemctl --user restart plasma-plasmashell.service
        '';
      executable = true;
    };

    # create-distrobox
    "${userBinDir}/create-distrobox" = {
      text =
        # sh
        ''
          #!/usr/bin/env sh
          # shellcheck disable=1009,1073,1003

          distrobox-create -Y -i ghcr.io/ultramarine-linux/ultramarine:44 -n fedora_distrobox \
            -ap 'rpmdevtools @development-tools xclip wl-clipboard dnf-plugins-core' \
            --init-hooks "$(cat << 'SH'

          if [ ! -f /bin/cls ]; then
            sudo ln -sf "$(command -v clear)" /bin/cls;
          fi;

          if ! cat /etc/dnf/dnf.conf | grep -qF 'install_weak_deps=False'; then
            echo -e "install_weak_deps=False\nbest=True" | sudo tee -a /etc/dnf/dnf.conf &> /dev/null;
          fi;

          SH
          )"
        '';
      executable = true;
    };

    ## Aliases
    # lazygit alias
    "${userBinDir}/lg".source = "${pkgs.lazygit}/bin/lazygit";

    # doge alias
    "${userBinDir}/dog".source = "${pkgs.dogedns}/bin/doge";

    ## Others
    "${userConfigDir}/yt-dlp/config".text = ''
      # vim:ft=conf
      --verbose
      --no-warnings
      --progress
      --windows-filenames

      -f bestaudio
      --audio-quality 0
      --extract-audio
      --format-sort '+acodec:mp4a,quality'

      --progress-delta .75
      -t sleep
      --no-mtime
      --no-embed-info-json

      --ffmpeg-location /usr/bin/ffmpeg
      --js-runtimes deno:~/.local/share/deno

      --paths ~/Downloads/yt-dlp
      --paths temp:~/Downloads/yt-dlp
      -o "%(album,playlist_title)s/%(track_number,playlist_index)02d - %(artists) - %(title)s.%(ext)s"

      --write-thumbnail
      --convert-thumbnails jpg
      --ppa "ThumbnailsConvertor+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\""
      --embed-thumbnail

      --embed-metadata

      --force-overwrites
    '';

    "${userConfigDir}/beets/config.yaml".source = ./.config/beets/config.yaml;

    "${userConfigDir}/btop/themes" = {
      recursive = true;
      source = "${catppuccin-btop-theme}/themes";
    };

    "${userConfigDir}/bat/themes" = {
      recursive = true;
      source = "${catppuccin-bat-theme}/themes";
    };

    "${userConfigDir}/bat/config".text = ''
      --plain
      "--theme=Catppuccin Macchiato"
      "--style=numbers"
    '';

    "${userConfigDir}/ghostty/themes" = {
      recursive = true;
      source = "${catppuccin-ghostty-theme}/themes";
    };

    "${userConfigDir}/ghostty/config".source = ./.config/ghostty/config;

    "${userConfigDir}/lsd/config.yml".text =
      # yaml
      ''
        color:
          theme: custom
      '';
    "${userConfigDir}/lsd/colors.yaml".source = "${catppuccin-lsd-theme}/themes/catppuccin-macchiato/colors.yaml";

    "${userConfigDir}/micro/colorschemes" = {
      recursive = true;
      source = "${catppuccin-micro-theme}/themes";
    };

    "${userConfigDir}/opencode/opencode.jsonc".source = ./.config/opencode/opencode.jsonc;

    "${userConfigDir}/ov/config.yaml".source = ./.config/ov/config.yaml;

    "${userConfigDir}/topgrade.toml".source = ./.config/topgrade.toml;

    "${homeDirectory}/catppuccin-delta-theme.gitconfig".source = "${catppuccin-delta-theme}/catppuccin.gitconfig";

    "${homeDirectory}/.icons/capitaine-cursors".source = "${pkgs.capitaine-cursors}/share/icons/capitaine-cursors";

    "${userDataDir}/applications" = {
      recursive = true;
      source = ./.local/share/applications;
    };

    "${userDataDir}/kio/servicemenus" = {
      recursive = true;
      source = ./.local/share/kio/servicemenus;
    };

    "${userDataDir}/color-schemes" = {
      recursive = true;
      source = "${willow-theme}/color-schemes";
    };

    "${userDataDir}/aurorae/themes" = {
      recursive = true;
      source = "${chromeos-kde}/aurorae";
    };
  };
}
