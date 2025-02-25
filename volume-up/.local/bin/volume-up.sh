#!/bin/bash
# Získá aktuální hlasitost prvního výchozího sinku
current_vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1)
# Pokud je hlasitost menší než 100, zvýší ji o 10%
if [ "$current_vol" -lt 100 ]; then
    pactl set-sink-volume @DEFAULT_SINK@ +10%
else
    # Pokud už je 100 nebo více, nastaví ji pevně na 100%
    pactl set-sink-volume @DEFAULT_SINK@ 100%
fi
