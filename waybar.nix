{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      ${builtins.readFile "${pkgs.waybar}/etc/xdg/waybar/style.css"}

      window#waybar {
        background: transparent;
        border-bottom: none;
      }

      * {
        ${if config.hostId == "yoga" then ''
        font-size: 18px;
      '' else ''

        ''}
