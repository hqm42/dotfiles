# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  mypkgs = import ./my-packages.nix;
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
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

  boot.kernelPackages = pkgs.linuxPackages_4_4;
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
  networking.firewall = {
    allowedTCPPorts = [ 3000 ];
  };


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

  fonts = {
    fonts = [ pkgs.noto-fonts pkgs.noto-fonts-emoji ];
    enableFontDir = true;
  };

  environment.sessionVariables = {
    XCURSOR_PATH = [
      "${config.system.path}/share/icons"
      "$HOME/.icons"
      "$HOME/.nix-profile/share/icons"
    ];
    GTK_DATA_PREFIX = [
      "${config.system.path}"
    ];
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs // mypkgs; [
    acpi
    albert
    androidsdk
    ansible2
    atom
    bc
    nodePackages.castnow
    chromium
    conky
    copyq
    cowsay
    ctags
    gitAndTools.diff-so-fancy
    dmidecode
    dunst
    dzen2
    encfs
    file
    filezilla
    firefox
    gcc
    ghc
    gimp
    git
    gitAndTools.gitAnnex
    gitkraken
    gnome3.dconf
    gnome3.gnome_terminal
    gnome3.nautilus
    gnome3.vte
    gnumake
    go
    unstable.pkgs.google-chrome
    gparted
    graphviz
    hicolor_icon_theme
    htop
    imagemagick
    ipmitool
    keychain
    ledger
    libreoffice
    lsof
    mariadb
    mplayer
    multitail
    nixops
    nmap
    nodejs
    nodePackages.elasticdump
    openjdk
    openscad
    openssl
    pgadmin
    phantomjs2
    php
    pngcrush
    protobuf3_0
    pv
    python
    rbenv
    readline
    rrdtool
    ruby
    rubybuild
    samsungUnifiedLinuxDriver
    skype
    slack
    sqitchPg
    stack
    stow
    # teamviewer
    tig
    tldr
    transmission
    trayer
    tree
    unzip
    urweb
    vagrant
    vim_configurable
    vivaldi
    wget
    which
    xmlstarlet
    yarn
    zeal
    zlib
    nix-zsh-completions
    zstd
    # icon theme stuff
    adapta-gtk-theme
    gnome3.adwaita-icon-theme
    xorg.xcursorthemes
    lxappearance
  ];
  environment.shells = [ pkgs.zsh ];

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
  security.wrappers = {
    slock = {
      source = "${pkgs.slock.out}/bin/slock";
     };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.sshd.enable = true;
  services.mysql = {
    enable = false;
    package = pkgs.mariadb;
  };
  services.postgresql = {
    enable = true;
    authentication = "host all all localhost trust";
  };
  services.elasticsearch = {
    enable = false;
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
      minSpeed = "0.0";
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
    shell = pkgs.zsh;
  };

  # other options
  programs.bash.enableCompletion = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  # virtualbox
  virtualisation.virtualbox.host.enable = true;

  # docker
  virtualisation.docker.enable = true;


  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
