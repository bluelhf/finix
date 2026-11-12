{
  lib,
  rustPlatform,
  fetchCrate,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "runzip";
  version = "0.1.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ti0pyDyhkO2qP4t1E1Ncd/UM29qKv9vm9uSbacZCE78=";
  };

  cargoHash = "sha256-UUpA3tL/EiUC5riJxYth21zNyfKgbniIhtZx5q/7maE=";

  nativeBuildInputs = [ cmake ];

  cargoTestFlags = [
    "--lib"
    "--bins"
  ];

  meta = {
    description = "A Rust unzip utility with HTTP URL support using Range requests";
    homepage = "https://github.com/Ylarod/runzip";
    license = lib.licenses.mit;
    mainProgram = "runzip";
  };
}
