{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "i3-autolayout";
  version = "master";

  src = fetchFromGitHub {
    owner = "BiagioFesta";
    repo = pname;
    rev = "e6bde95eb81f5335a5557c7618fda7bf2730f70a";
    sha256 = "sha256-8IZmNJvGHaI2HPfPTU+7QOe/bzNlPFqJpaetRL6kakU=";
  };

  cargoSha256 = "sha256-DqDJT3VGVGrW2eoQ5E8x+5sTQKVZl8PBYTha0/3rDvw=";

  meta = with lib; {
    description = "Service to automatically managing i3 window manager layout";
    homepage = "https://github.com/BiagioFesta/i3-autolayout";
    license = with licenses; [ gpl3 ];
    mainProgram = "i3-autolayout";
  };
}
