# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in {
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/dell/xps/15-9500/nvidia>
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
      root = {
          device = "/dev/disk/by-uuid/0d47684e-2393-4171-918d-67c2937beb42";
          preLVM = true;
      };
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  networking.hostName = "alt";
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s20f0u4u2.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.wireless = {
      enable = true;
      interfaces = [ "wlp0s20f3" ];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  services.xserver = {
      enable = true;
      layout = "gb";

      desktopManager = {
          plasma5.enable = true;
      };

      windowManager.i3 = {
          package = pkgs.i3-gaps;
          enable = true;
          extraPackages = with pkgs; [
              rofi
              i3status-rust
          ];
      };

      displayManager = {
          sddm = {
              enable = true;
              enableHidpi = true;
          };
          defaultSession = "plasma5+i3";
      };
  };

  # Add Yubikey udev rules
  services.udev.packages = with pkgs; [
      yubikey-personalization
  ];

  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
  };

  services.picom.enable = true;

  services.openvpn.servers.vpn = {
      autoStart = false;
      config = "config /etc/nixos/config.ovpn";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      # Core
      unstable.nushell
      bash
      starship
      git
      git-crypt
      fzf
      ripgrep
      ripgrep-all
      fd
      kakoune
      kak-lsp
      yubikey-manager
      yubikey-personalization
      opensc
      xsel
      xdotool
      xclip
      clipmenu
      (pass.withExtensions (exts: [ exts.pass-otp ]))
      rofi-pass
      libnotify
      dunst
      konsole
      usbutils
      pulseaudio
      direnv
      
      # Apps
      firefox-devedition-bin
      vivaldi
      vivaldi-ffmpeg-codecs
      vivaldi-widevine
      barrier
      flameshot
      pavucontrol
      paprefs
      slack
      lastpass-cli
      taskwarrior

      # Dev
      jetbrains.webstorm
      awscli2

      # Other
      feh
      lazygit
      noisetorch
      v4l-utils
      zbar
  ];

  fonts.fonts = with pkgs; [
      font-awesome_4
  ];

  users.users.louix = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.nushell;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
  system.autoUpgrade.enable = true;

}

