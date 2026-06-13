# latency-server

Servidor de latência (xhttp) em Go com autenticação por **path + token** e **TLS opcional**, acompanhado de um **gerenciador interativo** (`xhttplatency-manager`) que instala, configura e controla o servidor como serviço **systemd** — tudo por um menu no terminal.

Os binários são **estáticos** (`CGO_ENABLED=0`), então rodam em qualquer Linux x86-64 sem depender da versão da glibc.

---

## Instalação

Em um servidor Linux com **systemd**, rode (como root, ou o script usa `sudo` sozinho):

```sh
curl -fsSL https://raw.githubusercontent.com/kiritosshxd/latency-server/main/install.sh | sh
```

O instalador baixa o `xhttplatency-manager` para `/usr/local/bin`, mostra as instruções e abre o menu.

> Para reabrir o menu a qualquer momento, digite no terminal:
> ```sh
> xhttplatency-manager
> ```

---

## Usando o manager

### Primeira vez (servidor não instalado)

O menu mostra apenas a opção de instalar:

```
1) Instalar
0) Sair
```

**Instalar** baixa o binário do servidor e pergunta a configuração (ENTER usa o valor padrão):

```
Inserir porta (default: 8080):
Inserir path (default: /):
Inserir usuário (default: admin):
Inserir senha (default: admin):
Ativar TLS? [s/N]:
```

- A **porta é validada**: se já estiver em uso, o manager pede outra.
- Com **TLS** ativado, você pode **gerar um certificado autoassinado** na hora (informando domínio/IP) ou **apontar para um cert/key existente**.

Ao final, o servidor é registrado no systemd (sobe no boot), iniciado, e o manager exibe a **URL e o token** de acesso.

### Já instalado (painel completo)

```
  Serviço : active
  Listen  : http://0.0.0.0:8080/
  Usuário : admin
  Senha   : admin
  TLS     : desativado
--------------------------------------------------
  1) Iniciar
  2) Parar
  3) Reiniciar
  4) Status
  5) Logs
  6) Gerenciar configuração
  7) Atualizar (server + manager)
  8) Desinstalar
  0) Sair
```

- **Gerenciar configuração** — altera porta, path, usuário, senha e TLS. Cada mudança é salva na hora; use *Aplicar* para reiniciar o serviço e valer.
- **Atualizar** — baixa as versões novas do **servidor** e do **próprio manager** e fecha (reabra com `xhttplatency-manager`).
- **Desinstalar** — remove o serviço, o servidor **e o próprio manager**.
- **Logs** — últimas 100 linhas ou acompanhamento ao vivo (`journalctl`).

---

## Configuração (config.json)

Fica em `/opt/xhttplatency/config.json`:

```json
{
  "address": "0.0.0.0",
  "port": 8080,
  "path": "/",
  "user": "admin",
  "password": "admin",
  "tls": {
    "enabled": false,
    "cert_file": "",
    "key_file": ""
  }
}
```

O `address` fica fixo em `0.0.0.0` (escuta em todas as interfaces). Prefira editar pelo menu **Gerenciar configuração**; se editar na mão, reinicie com `systemctl restart xhttplatency`.

---

## Acesso (URL e token)

O servidor responde em:

```
http(s)://SEU_IP:PORTA/<path>/<token>
```

O `<token>` são os 16 primeiros caracteres do **HMAC-SHA256** de `usuario:senha` (chave `xhttp-auth-v1`). Com os padrões (path `/`), a URL fica `http://SEU_IP:8080/<token>`.

Você **não precisa calcular** nada: o manager mostra a URL pronta logo após a instalação e na opção **Ver token / URL de acesso**.

> **TLS autoassinado:** o certificado gerado não é confiável por padrão — o cliente precisa aceitá-lo (ignorar verificação) ou usar um certificado de uma CA válida.

---

## Comandos úteis (systemd)

```sh
systemctl status xhttplatency      # estado
systemctl restart xhttplatency     # reiniciar
journalctl -u xhttplatency -f      # logs ao vivo
```

---

## Onde fica cada coisa

| Item | Caminho |
|------|---------|
| Binário do servidor | `/opt/xhttplatency/xhttplatency` |
| Configuração | `/opt/xhttplatency/config.json` |
| Certificados TLS | `/opt/xhttplatency/certs/` |
| Serviço systemd | `/etc/systemd/system/xhttplatency.service` |
| Manager | `/usr/local/bin/xhttplatency-manager` |

---

## Compilar do código-fonte

Precisa de **Go 1.21+**. Na pasta do projeto:

```sh
bash build.sh
```

Gera dois binários estáticos para `linux/amd64`:

- `xhttplatency` — o servidor
- `xhttplatency-manager` — o gerenciador

Publique os dois (junto do `install.sh`) na branch `main` deste repositório: o instalador baixa o **manager** daqui, e o manager baixa o **servidor** daqui.

---

## Requisitos

- Linux x86-64 com **systemd**
- **root/sudo** (para instalar o serviço e escrever em `/opt` e `/usr/local/bin`)
