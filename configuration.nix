{
  config,
  lib,
  pkgs,
  username,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda/";
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
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

  networking.firewall.allowedTCPPorts = [ 22 ];

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
