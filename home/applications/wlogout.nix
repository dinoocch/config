{pkgs, ...}: {
  home.packages = with pkgs; [
    wlogout
  ];

  xdg.configFile = {
    "wlogout/layout".text = ''
      {
          "label" : "lock",
          "action" : "${pkgs.waylock}/bin/waylock",
          "text" : "Lock",
          "keybind" : "l"
      }
      {
          "label" : "logout",
          "action" : "loginctl terminate-user $USER",
          "text" : "Logout",
          "keybind" : "e"
      }
      {
          "label" : "shutdown",
          "action" : "systemctl poweroff",
          "text" : "Shutdown",
          "keybind" : "s"
      }
      {
          "label" : "suspend",
          "action" : "systemctl suspend",
          "text" : "Suspend",
          "keybind" : "u"
      }
      {
          "label" : "reboot",
          "action" : "systemctl reboot",
          "text" : "Reboot",
          "keybind" : "r"
      }
    '';

    "wlogout/style.css".text = ''
      * {
        background-image: none;
      }

      window {
        background-color: rgba(30, 30, 46, 0.9);
      }

      button {
        color: rgb(203, 166, 247);
        background-color: rgb(17, 17, 27);
        border-style: solid;
        border-width: 2px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
      }

      button:focus, button:active, button:hover {
        background-color: rgb(88, 91, 112);
        color: rgb(243, 139, 168);
        outline-style: none;
      }

      #lock {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"))
      }

      #logout {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"))
      }

      #suspend {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"))
      }

      #shutdown {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"))
      }

      #reboot {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"))
      }
    '';
  };
}
