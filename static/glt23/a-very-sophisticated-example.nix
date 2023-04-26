{ lib
, stdenv
, zsh
, hello
}:

stdenv.mkDerivation {
  pname = "example";
  version = "1.0";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/linuxtage << EOF
    #!${zsh}/bin/zsh
    echo "$(${hello}/bin/hello) Welcome to Grazer Linuxtage $(date +'%Y')!"
    EOF
    chmod +x $out/bin/linuxtage
  '';

  meta = with lib; {
    description = "An example package";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.totoroot ];
  };
}
