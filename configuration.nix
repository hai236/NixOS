  # ----------------------- #
  # MY NIX-OS CONFIGURATION #
  # ----------------------- #

  # Configurations,library and packages #
  { config, lib, pkgs, ... }:

  {
  imports =
  [ # Hardware #
      ./hardware-configuration.nix
  ];

  # Latest Kernel #
  boot.kernelPackages = pkgs.linuxPackages_latest;
 
  # Bootloader #
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # Btrfs filesystem #
  fileSystems = {
  "/".options = [ "compress=zstd" ];
  "/home".options = [ "compress=zstd" ];
  "/nix".options = [ "compress=zstd" "noatime" ];
  };

  # Scrubbing for btrfs #
  services.btrfs.autoScrub = {
  enable = true;
  interval = "weekly";
  fileSystems = [ "/" ];
  };

  # Nerwork configurations #
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Timezone #
  time.timeZone = "Europe/Istanbul";

  # Proxy configrations #
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # internationalisation properties #
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
  LC_ADDRESS = "tr_TR.UTF-8";
  LC_IDENTIFICATION = "tr_TR.UTF-8";
  LC_MEASUREMENT = "tr_TR.UTF-8";
  LC_MONETARY = "tr_TR.UTF-8";
  LC_NAME = "tr_TR.UTF-8";
  LC_NUMERIC = "tr_TR.UTF-8";
  LC_PAPER = "tr_TR.UTF-8";
  LC_TELEPHONE = "tr_TR.UTF-8";
  LC_TIME = "en_US.UTF-8";
  };

  # X11 #
  services.xserver.enable = true;

  # Desktop environments #
  services.displayManager.ly.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Keymap in X11 configurations #
  services.xserver.xkb = {
  layout = "tr";
  variant = "";
  };
  
  # Keymap in console #
  console.keyMap = "trq";

  # Printing #
  services.printing.enable = true;
  
  # Our packages management #
  services.flatpak.enable = true;
  
  # Bluetooth #
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Sound #
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  jack.enable = true;
  # media-session.enable = true;
  };

  # Touchpad #
  # services.libinput.enable = true;
  
  # Cachix #
  nix = {
  settings = {
  auto-optimise-store = true;
  experimental-features = [
  "nix-command"
  "flakes"
  ];
  };
  gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
  };
  };

  # OpenGL configurations #
  hardware.graphics = {
  enable = true;
  };
  
  # Wayland electron apps #
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # Shell #
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh bash ];
  environment.shellAliases = {
  nixrb = "sudo nixos-rebuild switch";
  nixconf = "sudo vim /etc/nixos/configuration.nix";
  nixup = "sudo nixos-rebuild switch --upgrade";
  nixclean = "sudo nix-collect-garbage -d";
  };

  # User account #
  users.users.hasan = {
  isNormalUser = true;
  description = "Hasan";
  extraGroups = [ "networkmanager" "wheel" "audio" "video" "flatpak" ];
  packages = with pkgs; [
  ];
  shell = pkgs.zsh;
  };
  
  # Unfree packages #
  nixpkgs.config.allowUnfree = true;
  
  # Browser #
  programs.firefox.enable = true;
  
  # Text editor #
  programs.vim.enable = true;

  # Vim configurations #
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };
 
  # All packages #
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # TUI #
  vim
  git
  curl
  wget
  eza
  zsh
  zsh-z
  oh-my-zsh
  nix-zsh-completions
  zsh-syntax-highlighting
  zsh-autosuggestions
  blueman
  zoxide
  nitch
  fastfetch
  nix-search-cli
  fzf
  libgcc
  btop
  gcc_multi
  starship
  jq
  wl-clipboard
  python314
  alsa-utils
  mpvScripts.modernx
  emacsPackages.mpv
  mpvScripts.memo
  mpvScripts.autosubsync-mpv
  mpv-subs-popout
  mpvScripts.quack
  mpvScripts.mpris
  mpvScripts.mpv-discord
  mpvScripts.reload
  mpvScripts.mpv-webm
  kdePackages.discover
  
  # APPS #
  libreoffice-qt6-fresh
  gnome-disk-utility
  librecad
  discord
  gimp
  mpv
  bottles
  lutris
  steam
  
  # FONTS #
  nerd-fonts.caskaydia-cove
  nerd-fonts.caskaydia-mono
  nerd-fonts.jetbrains-mono
  nerd-fonts.fira-mono
  nerd-fonts.fira-code
  ];

  # SUID #
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # OpenSSH #
  # services.openssh.enable = true;

  # Firewall #
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # System version #
  system.stateVersion = "25.05";
  }
