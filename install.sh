#!/bin/sh
# Instalador do xhttplatency-manager.
# Baixa o binario do manager para /usr/local/bin e abre o menu para
# prosseguir com a instalacao do server.
#
# Uso:
#   sh install.sh
#   curl -fsSL https://github.com/kiritosshxd/latency-server/raw/main/install.sh | sh
set -e

MANAGER_URL="https://github.com/kiritosshxd/latency-server/raw/main/xhttplatency-manager"
BIN="/usr/local/bin/xhttplatency-manager"

# ---- privilegio (root direto ou via sudo) ----
if [ "$(id -u)" -eq 0 ]; then
	SUDO=""
elif command -v sudo >/dev/null 2>&1; then
	SUDO="sudo"
else
	echo "Erro: rode como root (ou instale o sudo)." >&2
	exit 1
fi

# ---- download (curl ou wget) ----
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

echo "Baixando o manager..."
if command -v curl >/dev/null 2>&1; then
	curl -fSL "$MANAGER_URL" -o "$TMP"
elif command -v wget >/dev/null 2>&1; then
	wget -qO "$TMP" "$MANAGER_URL"
else
	echo "Erro: precisa de curl ou wget instalado." >&2
	exit 1
fi

# ---- valida que veio um binario ELF (nao HTML de erro / ponteiro LFS) ----
if [ ! -s "$TMP" ] || [ "$(head -c 4 "$TMP" | od -An -tx1 | tr -d ' \n')" != "7f454c46" ]; then
	echo "Erro: o download nao e um binario valido. Confira a URL do manager." >&2
	exit 1
fi

# ---- instala em /usr/local/bin ----
$SUDO install -m 0755 "$TMP" "$BIN"

# ---- mensagem ----
cat <<EOF

============================================================
  Manager instalado em: $BIN

  Para abrir o menu do manager a qualquer momento, digite
  no terminal:

      xhttplatency-manager

  Aperte ENTER para abrir o manager agora e seguir com a
  instalacao do server (opcao 1) Instalar).
============================================================
EOF

# ---- abre o manager (le do terminal mesmo se veio via "curl | sh") ----
if [ -r /dev/tty ]; then
	printf "Pressione ENTER para continuar..."
	read _ </dev/tty
	exec $SUDO "$BIN" </dev/tty
else
	echo "Abra o manager com:  $SUDO xhttplatency-manager"
fi
