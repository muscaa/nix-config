{ inputs, ... }:
{
  imports = [
    inputs.mt7927.nixosModules.default
  ];

  # fix boot hang due to partially supported bluetooth driver
  hardware.bluetooth.enable = false;
  hardware.mediatek-mt7927 = {
    enable = true;
    enableWifi = true;
    enableBluetooth = false;
    disableAspm = true;
  };

  # fix mouse scroll not working in games?
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Logitech G502 Wireless]
    MatchName=*G502*
    MatchUdevType=mouse
    AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
  '';
}
