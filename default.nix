# default.nix
{ pkgs ? import <nixpkgs> {} }: # Importiere nixpkgs, falls nicht explizit übergeben

pkgs.stdenv.mkDerivation {
  pname = "verschiebe-nzb-script"; # Paketname
  version = "0.1.0"; # Versionsnummer deines Skripts (kann z.B. vom Git-Tag kommen)

  # Hier referenzieren wir das Verzeichnis, in dem sich diese default.nix befindet.
  # Dies ist der Quellcode, der in den Build-Container kopiert wird.
  src = ./.; 

  # Liste der Pakete, die für den Bau und die Ausführung des Skripts benötigt werden.
  # Diese werden dem PATH während des Build-Schritts hinzugefügt.
  buildInputs = with pkgs; [
    bash      # Für die Ausführung des Skripts
    coreutils # Für mv, mkdir, ls, etc.
    findutils # Für find
  ];

  # Der eigentliche "Installations"-Schritt
  installPhase = ''
    mkdir -p $out/bin # Erstelle das bin-Verzeichnis im Ausgabeordner

    # Kopiere das Skript und stelle sicher, dass der Shebang korrekt ist
    # substituteAll ersetzt im Skript Vorkommen von @package@ durch den Pfad zum Paket
    # In diesem Fall nicht direkt für Shebang nötig, wenn er schon /usr/bin/env bash ist,
    # aber gut für andere Pfad-Ersetzungen. Hier kopieren wir es einfach.
    cp $src/verschiebe_nzb.sh $out/bin/verschiebe_nzb
    
    # Mache das Skript ausführbar
    chmod +x $out/bin/verschiebe_nzb
  '';

  # Optional: Ein Check-Phase zum Testen des Skripts nach dem Bau
  # checkPhase = ''
  #   # Hier könntest du Tests für dein Skript schreiben
  #   # z.B. prüfen, ob es die richtigen Ausgaben erzeugt oder Dateien verschiebt
  #   echo "Running dummy check for verschiebe-nzb-script"
  # '';

  # Metadaten für das Paket
  meta = with pkgs.lib; {
    description = "Ein Bash-Skript zum Verschieben von NZB-Dateien";
    homepage = "https://github.com/LanceHardwoodXXX/scripts"; # Deine Repository-URL
    license = licenses.gpl3Only; # Wähle eine passende Lizenz
    platforms = platforms.linux;
  };
}
