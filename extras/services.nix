{config, ...}: let
  inherit (config.home) homeDirectory;
in {
  systemd.user.services = {
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
}
