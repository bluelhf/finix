{ lib, pkgs, ... }:

let
  ideaConfig = "JetBrains/IntelliJIdea${lib.versions.majorMinor pkgs.intellij-idea.version}";
in
{
  # unfree so these have to be explicitly allowed in flake.nix
  home.packages = with pkgs; [
    intellij-idea
    webstorm
    rust-rover
  ];

  xdg.configFile."${ideaConfig}/options/editor.xml".text = ''
    <application>
      <component name="EditorSettings">
        <!-- change font size with ctrl + mouse wheel -->
        <option name="IS_WHEEL_FONT_CHANGE_ENABLED" value="true" />
      </component>
    </application>
  '';
}
