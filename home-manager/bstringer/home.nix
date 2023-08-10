{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "bstringer";
  home.homeDirectory = "/home/bstringer";

  #  sops = {
  #    #    age.keyFile = "/home/gifflen/.config/sops/age/keys.txt";
  #    #    defaultSopsFile = "/home/gifflen/cfg/secrets/example.yaml";
  #    #    secrets.example_key = {};
  #  };
  programs.bash = {
    enable = true;
    enableCompletion = true;
    sessionVariables = {
      EDITOR = "vim";
    };
    bashrcExtra = ''
      . /home/bstringer/.nix-profile/etc/profile.d/nix.sh
      eval "$(ssh-agent -s)"
    '';
    shellAliases = {
      hms = "home-manager switch --flake .#bstringer";

    };
  };



  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.htop
    pkgs.btop
    pkgs.iotop
    pkgs.age
    pkgs.age-plugin-yubikey
    pkgs.nerdfonts
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };


  home.sessionPath = [ "$HOME/.local/bin" ];
  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/gifflen/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  #  programs.vscode = {
  #    enable = true;
  #    extensions = with pkgs.vscode-extensions; [
  #      arrterian.nix-env-selector
  #      dracula-theme.theme-dracula
  #      vscodevim.vim
  #      yzhang.markdown-all-in-one
  #    ];
  #  };

  programs.btop.enable = true;
  programs.direnv.enable = true;
  programs.gh.enable = true;
  programs.git = {
    enable = true;
    userName = "Bruce Stringer";
    userEmail = "bstringer@gmail.com";
  };
  programs.go.enable = true;
  programs.gpg.enable = true;
  programs.jq.enable = true;
  #  programs.k9s.enable = true;
  programs.nix-index.enable = true;
  programs.pls.enable = true;
  # programs.pyenv.enable = true;
  programs.pylint.enable = true;

  programs.ssh = {
    enable = true;
  };


  programs.starship.enable = true;
  programs.tmux.enable = true;
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  nixpkgs.config.allowUnfreePredicate = (_: true);

  manual.html.enable = true;
  manual.json.enable = true;
  manual.manpages.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
  #  services.keybase.enable = true;

  xdg.enable = true;

  #  imports = [
  #    "${fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master"}/modules/vscode-server/home.nix"
  #  ];

  # services.vscode-server.enable = true;
}
