{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./waybar.nix	
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "tr_TR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  #Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;
};
hardware.pulseaudio.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "tr";
    variant = "";
  };

  # GDM
  services.xserver = {
   enable = true;
   displayManager.gdm.enable = true;
   desktopManager.gnome.enable = true;
  };

environment.gnome.excludePackages = (with pkgs; [
  gnome-photos
  gnome-tour
]) ++ (with pkgs.gnome; [
  gnome-music
  gnome-terminal
  geary # email reader
  evince # document viewer
  gnome-characters
  totem # video player
 ]);

  # Hyprland ve Wayland
  programs.hyprland = {
     enable = true;
     xwayland.enable = true;
};

  # Configure console keymap
  console.keyMap = "trq";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yekta = {
    isNormalUser = true;
    description = "yekta";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [

	discord
	firefox
	spotify
	bitwarden
	spotify
	webcord-vencord
];
  };


  # Enable automatic login for the user.
  services.getty.autologinUser = "yekta";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #Experimental Features Falan
  nix.settings.experimental-features = [ "nix-command" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    wofi	
    neofetch
    kitty
    pavucontrol
    hyprpaper
    hyprshot
    xdg-desktop-portal-hyprland
    libsForQt5.polkit-kde-agent
    libsForQt5.qt5.qtwayland
    waybar
    protonup-qt
        
];


 
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };



  system.stateVersion = "23.11";


}
