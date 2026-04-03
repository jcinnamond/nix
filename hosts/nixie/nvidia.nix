{ config, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = true; # change this if it breaks sleep/suspend
      # kernelSuspendNotifier = true; # only enable for 595 or later (currently only available as the beta driver)
    };
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
