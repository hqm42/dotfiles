# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  mypkgs = import ./my-packages.nix;
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  boot.kernelPackages = pkgs.linuxPackages_4_8;
  boot.kernelModules = [ "ecryptfs" ];
  boot.blacklistedKernelModules = [ "snd_pcsp" ];

  # for alsamixer
  boot.extraModprobeConfig = ''
    options snd_hda_intel enable=0,1
    options snd slots=snd-hda-intel
  '';

  networking.hostName = "robert-t550"; # Define your hostname.
  networking.networkmanager = { 
    enable = true;
    # unmanaged = [ "wlp3s0" ];
  };
  networking.extraHosts = ''
    # 138.201.194.133 www.avocadostore.de
  '';
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";
    defaultLocale = "de_DE.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # unfree packages are ok I guess
  nixpkgs.config.allowUnfree = true;

  fonts.fonts = [ pkgs.noto-fonts pkgs.noto-fonts-emoji ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs // mypkgs; [
    acpi
    ansible2
    atom
    bc
    nodePackages.castnow
    chromium
    conky
    cowsay
    dmidecode
    dunst
    dzen2
    encfs
    file
    filezilla
    firefox
    gcc
    gimp
    git
    gnome3.dconf
    gnome3.gnome_terminal
    gnome3.nautilus
    gnome3.vte
    gnumake
    go
    google-chrome
    graphviz
    htop
    imagemagick
    ipmitool
    keychain
    libreoffice
    lsof
    mplayer
    multitail
    nixops
    nmap
    nodejs
    openjdk
    openscad
    openssl
    pgadmin
    phantomjs2
    php
    protobuf3_0
    pv
    python
    rbenv
    readline
    ruby
    rubybuild
    samsungUnifiedLinuxDriver
    skype
    slack
    slock
    sqitchPg
    stow
    # teamviewer
    tig
    trayer
    tree
    unzip
    urweb
    vagrant
    vim_configurable
    wget
    which
    yi
    zeal
    zlib
    zstd
  ];

  # Security
  security.pam = {
    enableEcryptfs = true;
    # loginLimits =
    #   [ {
    #       domain = "redis";
    #       type = "-";
    #       item = "nofile";
    #       value = "10032";
    #     }
    #   ];
  };
  security.setuidPrograms = [ "slock" ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
  services.postgresql = {
    enable = true;
    authentication = "local all all ident";
  };
  services.elasticsearch = {
    enable = true;
    plugins = [ mypkgs.elasticsearchPlugins.elasticsearch_kopf ];
  };
  services.redis =  {
    enable = true;
  };
  services.dnsmasq.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "de";
    xkbOptions = "eurosign:e,caps:escape";
    xkbVariant = "nodeadkeys";
    synaptics = {
      enable = true;
      accelFactor = "0.01";
      minSpeed = "0.8";
      maxSpeed = "2.0";
      twoFingerScroll = true;
      horizTwoFingerScroll = false;
    };
  };

  # Enable the Desktop Environment.
  # services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.displayManager = {
    lightdm = {
      enable = true;
      background = "${mypkgs.mybackground}/share/background/background.jpg";
    };
    sessionCommands = "${pkgs.networkmanagerapplet}/bin/nm-applet &";
  };
  services.xserver.windowManager.xmonad = { 
    enable = true;
    enableContribAndExtras = true;
  };

  # sound
  # sound.enableMediaKeys = true;
  services.actkbd = with pkgs; {
    enable = true;
    bindings = [
      # "Mute" media key
      { keys = [ 113 143 ]; events = [ "key" ];       command = "${alsaUtils}/bin/amixer -q set Master toggle"; }

      # "Lower Volume" media key
      { keys = [ 114 143 ]; events = [ "key" "rep" ]; command = "${alsaUtils}/bin/amixer -q set Master 1- unmute"; }

      # "Raise Volume" media key
      { keys = [ 115 143 ]; events = [ "key" "rep" ]; command = "${alsaUtils}/bin/amixer -q set Master 1+ unmute"; }

      # "Mic Mute" media key
      { keys = [ 190 143 ]; events = [ "key" ];       command = "${alsaUtils}/bin/amixer -q set Capture toggle"; }
    ];
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.robert = {
    home = "/home/robert";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  # other options
  programs.bash.enableCompletion = true;

  # virtualbox
  virtualisation.virtualbox.host.enable = true;

  # docker
  virtualisation.docker.enable = true;


  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";
}
