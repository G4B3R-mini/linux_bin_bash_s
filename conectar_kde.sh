#!/bin/bash

echo "=== KDE Connect ==="
echo

echo "Dispositivos disponíveis:"
kdeconnect-cli -a

kdeconnect-cli --list-available
echo
read -p "Digite o ID do dispositivo: " ID

echo
echo "Enviando pedido de pareamento..."
kdeconnect-cli -d "$ID" --pair

echo
echo "Se aparecer uma notificação no celular, aceite o pareamento."
