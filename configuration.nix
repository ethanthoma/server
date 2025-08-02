{ pkgs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda/";
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  users.users = {
    root.hashedPassword = "!";

    ${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHiAN7eu9G4A1OerVYGf+ixTU/gQJPtyRIBq5z/CRLex ethanthoma@gmail.com"
      ];
    };

    deploy = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEigi9se71TOa5xHYUAPGEIFp3Bgus267A18VoztreF0 github-actions-deploy"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "ethanthoma@gmail.com";
    certs."aiso-research.com" = {
      dnsProvider = "cloudflare";
      credentialsFile = "/var/lib/secrets/cloudflare-credentials";
    };
  };

  services.nginx = {
    enable = true;
    group = "acme";
    virtualHosts."aiso-research.com" = {
      useACMEHost = "aiso-research.com";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
      };
    };
  };

  systemd.services.personal-website = {
    description = "Personal Website Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = "deploy";
      Group = "users";
      WorkingDirectory = "/home/deploy/personal-website";
      ExecStart = "/home/deploy/personal-website/result/bin/webserver";
      Restart = "always";
      RestartSec = "10s";

      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ReadWritePaths = [ "/home/deploy/personal-website" ];
    };

    environment = {
      WEBSERVER_PORT = "8080";
      BLOG_SOURCE = "github:ethanthoma/blogs";
    };
  };

  networking.firewall.allowedTCPPorts = [
    22
    443
  ];

  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  environment.systemPackages = [
    pkgs.git
    pkgs.neovim
    pkgs.tmux
    pkgs.fzf
  ];

  system.stateVersion = "25.05";
}
