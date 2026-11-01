{
  config,
  pkgs,
  ...
}: let
  inherit (config.home) homeDirectory;
  inherit (pkgs) runCommandLocal;

  nativePodmanBin = builtins.path {
    path = /usr/bin/podman;
    name = "native-podman-bin";
  };

  nativePodmanQuadletBin = builtins.path {
    path = /usr/libexec/podman/quadlet;
    name = "native-podman-quadlet-bin";
  };

  customPodman = runCommandLocal "native-podman-bin" {} ''
    set -x
    # Copy podman
    mkdir -p "$out/bin"
    cp -a '${nativePodmanBin}' "$out/bin/podman"
    chmod 0755 "$out/bin/podman"

    # Copy podman-quadlet
    mkdir -p "$out/libexec/podman" "$out/lib/systemd/user-generators"
    cp -a '${nativePodmanQuadletBin}' "$out/libexec/podman/quadlet"
    chmod 0755 "$out/libexec/podman/quadlet"
    ln -s "$out/libexec/podman/quadlet" "$out/lib/systemd/user-generators/podman-user-generator"
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
    package = customPodman;
    containers.jellyfin = {
      autoStart = false;
      autoUpdate = "registry";
      image = "ghcr.io/jellyfin/jellyfin:latest";
      description = "Podman jellyfin container service";
      extraPodmanArgs = [
        "--gpus=all"
      ];
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
