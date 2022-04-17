{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.dunst;
in
{
  options.modules.desktop.apps.dunst.enable = mkEnableOption "dunst";

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          follow = "mouse";
          geometry = "300x5-5+30";
          indicate_hidden = "yes";
          shrink = "no";
          transparency = 0;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          frame_width = 1;
          frame_color = "#458588";
          separator_color = "frame";
          sort = "yes";
          idle_threshold = 120;
          font = "JetBrains Mono 8";
          line_height = 0;
          markup = "full";
          format = "<b>%s</b>\n%b";
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 60;
          world_wrap = "yes";
          ellipsize = "middle";
          ignore_newline = "no";
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = "yes";
          icon_position = "left";
          min_icon_size = 0;
          max_icon_size = 32;
          sticky_history = "yes";
          history_length = 20;
          dmenu = "${pkgs.rofi}/bin/rofi -show run";
          browser = "${pkgs.firefox}/usr/bin/firefox -new-tab";
          always_run_script = true;
          title = "Dunst";
          class = "Dunst";
          startup_notification = false;
          verbosity = "mesg";
          corner_radius = 0;
          ignore_dbusclose = false;
          mouse_left_click = "close_current";
          mouse_middle_click = "do_action, close_current";
          mouse_right_click = "close_all";
        };

        urgency_low = {
          background = "#282828";
          foreground = "#d79921";
          timeout = 5;
        };

        urgency_normal = {
          background = "#282828";
          foreground = "#cc241d";
          timeout = 5;
        };
      };
    };
  };
}
