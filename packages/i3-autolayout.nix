{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "i3-autolayout";

  src = fetchFromGitHub {
    owner = "BiagioFesta";
    repo = pname;
    rev = "e6bde95eb81f5335a5557c7618fda7bf2730f70a";
    sha256 = "";
  };

  cargoSha256 = "";

  meta = with lib; {
    description = "Service to automatically managing i3 window manager layout";
    homepage = "https://github.com/BiagioFesta/i3-autolayout";
    license = with licenses; [ gpl3 ];
    mainProgram = "i3-autolayout";
  };
}
