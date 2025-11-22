#!/usr/bin/env bash

# Dieses Skript konvertiert Videodateien im selben Verzeichnis, in dem es liegt.
# '.' steht für das aktuelle Verzeichnis.
VIDEO_DIR="."

echo "Starte Videokonvertierung im Verzeichnis: $(pwd)"
echo "-------------------------------------"

# Schleife durch alle MP4-Dateien im aktuellen Verzeichnis
for file in "$VIDEO_DIR"/*.MP4; do
    # Überprüfen, ob die gefundene Entität tatsächlich eine reguläre Datei ist
    if [ -f "$file" ]; then
        # Dateiname ohne Pfad und Erweiterung extrahieren
        filename=$(basename -- "$file")
        filename_no_ext="${filename%.*}"

        # Ausgabedateiname im gleichen Verzeichnis erstellen
        output_file="$VIDEO_DIR/${filename_no_ext}.mov"

        echo "Konvertiere '$file' zu '$output_file'..."

        # FFmpeg-Befehl ausführen: Video kopieren, Audio zu ALAC konvertieren
        # NEU: -map_metadata 0 kopiert alle Metadaten (z.B. Erstellungsdatum)
        ffmpeg -i "$file" -c:v copy -c:a alac -map_metadata 0 "$output_file"

        if [ $? -eq 0 ]; then
            echo "Konvertierung von '$file' erfolgreich."
            # NEU: Setzt das Dateisystem-Datum der neuen .mov-Datei
            # auf das Datum der originalen .MP4-Datei
            touch -r "$file" "$output_file"
            echo "Metadaten und Datum von '$file' wurden übernommen."
        else
            echo "Fehler bei der Konvertierung von '$file'."
        fi
        echo "-------------------------------------"
    fi
done

echo "Alle Konvertierungen abgeschlossen."
echo "Bitte überprüfen Sie das Verzeichnis auf die neuen .mov-Dateien."
