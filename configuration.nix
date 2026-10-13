# HRL Hyper OS — Immutable Linux + macOS UX + HRL Agent Daemon
# Build ISO/VM: nixos-generate -f iso -c configuration.nix
{ config, pkgs, ... }: {
  system.stateVersion = "24.11";
  networking.hostName = "hrl-hyper-os";

  # Immutable-style root + macOS-like directory symlinks
  systemd.tmpfiles.rules = [
    "L+ /Applications - - - - /run/current-system/sw/share/applications"
    "d  /System 0755 root root -"
  ];

  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    waybar wofi kitty nautilus wl-clipboard python3
  ];

  # HRL Autonomous Daemon (Feudal Manager -> Worker OS service)
  systemd.services.hrld = {
    description = "HRL Hyper OS Hierarchical Agent Daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.python3}/bin/python3 /etc/hrl/hrld.py";
      Restart = "always";
    };
  };

  environment.etc."hrl/hrld.py".source = ./hrld.py;
  environment.etc."xdg/waybar/style.css".source = ./shell.css;

  # Top macOS Menu Bar + Bottom Dock via Waybar
  environment.etc."xdg/waybar/config".text = builtins.toJSON [
    {
      name = "menubar"; layer = "top"; position = "top"; height = 28;
      modules-left = [ "custom/apple" "hyprland/window" ];
      modules-right = [ "network" "battery" "clock" "custom/spotlight" ];
      "custom/apple" = { format = " HRL"; on-click = "wofi --show drun"; };
      "custom/spotlight" = { format = "⌘ Space"; on-click = "wofi --show drun"; };
    }
    {
      name = "dock"; layer = "top"; position = "bottom"; height = 54;
      margin-bottom = 8;
      modules-center = [ "wlr/taskbar" ];
      "wlr/taskbar" = { format = "{icon}"; icon-size = 36; on-click = "activate"; };
    }
  ];

  # macOS Global Shortcuts + Window Management (Hyprland)
  environment.etc."xdg/hypr/hyprland.conf".text = ''
    exec-once = waybar
    decoration { rounding = 12; blur { enabled = true; size = 8; passes = 2; } }
    bind = SUPER, Space, exec, wofi --show drun --prompt "Spotlight / HRL Goal..."
    bind = SUPER, Return, exec, kitty
    bind = SUPER, Q, killactive
    bind = SUPER, M, fullscreen, 1
    bind = SUPER, F, togglefloating
    bind = SUPER, Tab, cyclenext
  '';
}
