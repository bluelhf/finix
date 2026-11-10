{
  bash,
  coreutils,
  fetchzip,
  nix,
  runCommand,
}:

let
  version = "15.0.0-beta.3";

  pack = fetchzip {
    name = "Fabulously-Optimized-${version}";
    url = "https://github.com/Fabulously-Optimized/fabulously-optimized/releases/download/v${version}/Fabulously.Optimized-v${version}.mrpack";
    extension = "zip";
    stripRoot = false;
    hash = "sha256-kVYLl/Qv4/xibronz5ltJzyoZ5r3wlDSGAmBp5RTU+E=";
  };

  instanceDrv =
    runCommand "fabulously-optimized-${version}.drv"
      {
        __contentAddressed = true;
        outputHashMode = "text";
        outputHashAlgo = "sha256";
        requiredSystemFeatures = [ "recursive-nix" ];
        nativeBuildInputs = [ nix ];
      }
      ''
        export HOME=$TMPDIR
        drv=$(nix-instantiate ${./instance.nix} \
          --argstr name fabulously-optimized-${version} \
          --argstr pack ${pack} \
          --argstr bash ${bash} \
          --argstr coreutils ${coreutils})
        cp "$drv" $out
      '';
in
builtins.outputOf instanceDrv.outPath "out"
