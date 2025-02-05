# Virtual environment for HighestBidder Elixir/Phoenix development
#
#

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "hookRelay-env";
  buildInputs = with pkgs; [ 
    docker 
    elixir_1_17 
    inotify-tools 
    pgmodeler
    git
    wget
    htop
    sysstat
    direnv 
    nixpkgs-fmt 
    gcc 
    zip 
    bat 
    gh
  ];

  shellHook = ''
    #
    # Source ENVVARs
    source .env
    #
    # Move to code src
    cd ./src
    # Ensure DB needed by ecto is created
    mix Deps.get
    iex -S mix phx.server
    #
    echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
    echo -e "\033[0;34mWelcome to Nix-shell development environment for HookRelay!\e[0m"
    echo "Run 'iex -S mix phx.server' to start the Phoenix server."
    echo "Then run ':observer.start()', if you want to start observer."
    #
  '';
}