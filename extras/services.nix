{
  config,
  pkgs,
  ...
}: let
  inherit (config.home) homeDirectory;
  inherit (pkgs) runCommandLocal;

  userConfigDir = "${homeDirectory}/.config";
  userCacheDir = "${homeDirectory}/.cache";

  coprPodman = builtins.path {
    path = /usr/bin/podman;
    name = "podman-copr";
  };

  nativePodman = runCommandLocal "podman-copr" {} ''
    mkdir -p "$out/bin"
    cp -a "${coprPodman}" "$out/bin/podman"
    chmod 0755 "$out/bin/podman"
  '';
in {
  systemd.user = {
    # Prevents services from being auto-started
    startServices = false;
    services = {
      llama-swap = {
        Unit = {
          Description = "llama-swap service";
          Wants = "network-online.target";
          After = "network-online.target";
        };
        Service = {
          Type = "simple";
          Restart = "always";
          ExecStart = ''
            /home/linuxbrew/.linuxbrew/bin/llama-swap \
              -config '${homeDirectory}/llama-swap/config.yaml' \
              -watch-config --listen 0.0.0.0:1234
          '';
        };
        Install = {
          WantedBy = ["default.target"];
        };
      };
    };
  };
  services.podman = {
    enable = true;
    package = nativePodman;
    containers.jellyfin = {
      autoStart = false;
      autoUpdate = "registry";
      image = "ghcr.io/jellyfin/jellyfin:latest";
      description = "Podman jellyfin container service";
      extraPodmanArgs = "--gpus=all";
      environment = {
        PODMAN_SYSTEMD_UNIT = "%n";
      };
      labels = {
        "io.containers.autoupdate" = "registry";
        PODMAN_SYSTEMD_UNIT = "%n";
      };
      network = "host";
      user = 1000;
      volumes = [
        "${homeDirectory}/.config/jellyfin:/config"
        "${homeDirectory}/.cache:/cache"
        "${homeDirectory}/Videos:/media/Videos"
      ];
    };
  };
}
