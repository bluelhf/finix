{ pkgs, ... }:

{
  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };

  home.packages = [
    (pkgs.maven.override { jdk_headless = pkgs.jdk25_headless; })
  ];

  home.file.".jdks/jdk-25".source = "${pkgs.jdk25}/lib/openjdk";
}
