{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-defer";

  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "zsh-defer";
    rev = "b381bafbeeeadf69018d89f05b4e318a5299c9e9";
    sha256 = "Aud9Vha3wov8zvPUHf2UJA8raJz/iTuUJ+1BqMbSl2Y=";
  };

  dontBuild = true;

  installPhase = ''
    install -D zsh-defer.plugin.zsh $out/share/zsh/plugins/zsh-defer/zsh-defer.plugin.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/romkatv/zsh-defer";
    license = licenses.gpl3;
    description = "Deferred execution of Zsh commands";
    maintainers = with maintainers; [ dinoocch ];
  };
}

