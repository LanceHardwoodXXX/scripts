#!/usr/bin/env bash

# Verzeichnis, in dem nach Filmen gesucht werden soll.
SEARCH_DIR="$HOME/mnt/Media/Movies/HD/"

echo "Starte Suche: Es werden nur Filme ohne deutsche Tonspur aufgelistet."
echo "------------------------------------------------------------------"

# Finde alle .mkv Dateien im angegebenen Verzeichnis und seinen Unterverzeichnissen
find "$SEARCH_DIR" -type f -name "*.mkv" | while read -r file; do
  # Lese die Track-Informationen der Datei einmalig aus
  json_info=$(mkvmerge -J "$file")

  # Prüfe, ob eine deutsche ('ger') Tonspur vorhanden ist.
  has_german_track=$(echo "$json_info" | jq 'any(.tracks[]; .type == "audio" and .properties.language == "ger")')

  # Nur wenn KEINE deutsche Tonspur vorhanden ist, fahre fort.
  if [ "$has_german_track" = "false" ]; then
    # Prüfe jetzt, ob eine "unbekannte" (undefined) Tonspur vorhanden ist.
    has_undefined_track=$(echo "$json_info" | jq 'any(.tracks[]; .type == "audio" and .properties.language == "und")')

    if [ "$has_undefined_track" = "true" ]; then
      # Fall 1: Keine deutsche Spur, aber eine unbekannte.
      echo "Unbekannt (mögl. DE): $file"
    else
      # Fall 2: Weder eine deutsche noch eine unbekannte Spur gefunden.
      echo "Keine deutsche Spur:    $file"
    fi
  fi
  # Wenn 'has_german_track' "true" ist, wird dieser ganze Block übersprungen und nichts ausgegeben.
done

echo "------------------------------------------------------------------"
echo "Skript beendet."
