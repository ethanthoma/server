{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda/";
  };

  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  users.users = {
    root.hashedPassword = "!";
    username = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3Ttw1Ug8D3Ee0ZJa5y4nZTOnsZKFsTyVOY70lo+Djk2blPREyVlfPVcgGB4f/jRYP7KbSypiRMlg8mikDlu4Y0uk1HfBWAj6pH6LY5q3A1DzieiHUpplx/+qNiVMdBmXFczdgx4P7ro0avDX8HpSR74i9kkdWRQHapGcs+r2Dd3zAWBWZzDagVpyKEEyHFQJvKGqiV2IhSMKg2UW6xI5HDMXBxQW/jcNU+M64iWZopGP4njXWAl68xl4lkRuhIJPHr4G1iXunqJ5Bik49tjn87qHaBzpYVzQU8rUPknfLgUQu5Poo0CH5AgoidyLRSJ0N3EKJ+zEv6SSJXFqYXoHyvCNTzqImwBAa87lrcX6D7afnpXkwZEnEZT9526qDZKgJHAmK5QkUDCzlXlxe5EP4kbsjxku8feShVolBuygIaHiQFPy9RTyF2gmwTIdxUDwDHe29OSUYhrnW2c+QJ1qwCyvAfRfc9rQ4++G+CpHtLu2ZLp/pW6Wr76vaOiDWbU5nxxA029XV37b0IMA8RLTnHzR1GdcbqplRMkeaVs8XSMKtyZ7LzP646U5dqkgWY5U4FQt8NTuoGJkHveiGhu930mmOUO97lqNGxsuGIFBuWXnZ8k+f4EfHvRVf1r0VxlGj7G0j6CzmEAKcibQfCdQ1jlPJZPtPURrlsWBRmTK8CQ== ethanthoma@gmail.com"
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

  system.stateVersion = "25.05";
}
