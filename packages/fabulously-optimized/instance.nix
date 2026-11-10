{
  name,
  pack,
  bash,
  coreutils,
}:

let
  src = builtins.storePath pack;
  index = builtins.fromJSON (builtins.readFile "${src}/modrinth.index.json");

  sanitize =
    s:
    builtins.concatStringsSep "" (
      map (x: if builtins.isList x then "-" else x) (builtins.split "[^[:alnum:]+._?=-]" s)
    );

  files = map (f: {
    inherit (f) path;
    src = derivation {
      name = sanitize (baseNameOf f.path);
      system = "builtin";
      builder = "builtin:fetchurl";
      url = builtins.head f.downloads;
      outputHashMode = "flat";
      outputHashAlgo = "sha512";
      outputHash = f.hashes.sha512;
    };
  }) (builtins.filter (f: (f.env.client or "required") != "unsupported") index.files);

  immutable = f: builtins.match "(mods|resourcepacks|shaderpacks)/.*" f.path != null;
  lines = fs: builtins.concatStringsSep "\n" (map (f: "${f.src} ${f.path}") fs);
in
derivation {
  inherit name;
  system = builtins.currentSystem;
  builder = "${builtins.storePath bash}/bin/bash";
  PATH = "${builtins.storePath coreutils}/bin";
  pack = src;

  mmcPack = builtins.toJSON {
    formatVersion = 1;
    components = [
      {
        uid = "net.minecraft";
        version = index.dependencies.minecraft;
        important = true;
      }
      {
        uid = "net.fabricmc.fabric-loader";
        version = index.dependencies."fabric-loader";
      }
    ];
  };

  links = lines (builtins.filter immutable files);
  copies = lines (builtins.filter (f: !immutable f) files);

  args = [
    "-euc"
    ''
      mkdir -p $out/links $out/overrides
      printf '%s' "$mmcPack" > $out/mmc-pack.json

      for dir in overrides client-overrides; do
        if [ -d "$pack/$dir" ]; then
          cp -r --no-preserve=mode "$pack/$dir/." $out/overrides/
        fi
      done

      while read -r file path; do
        [ -n "$file" ] || continue
        mkdir -p "$(dirname "$out/links/$path")"
        ln -s "$file" "$out/links/$path"
      done <<< "$links"

      while read -r file path; do
        [ -n "$file" ] || continue
        install -Dm644 "$file" "$out/overrides/$path"
      done <<< "$copies"
    ''
  ];
}
