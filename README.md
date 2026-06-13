# latency-server

Servidor de latência (xhttp) com um **gerenciador no terminal** que instala, configura e controla tudo por um menu — com usuário/senha e TLS opcional.

---

## Instalação

Em um servidor Linux, rode como root:

```sh
curl -fsSL https://raw.githubusercontent.com/kiritosshxd/latency-server/main/install.sh | sh
```

Isso baixa o gerenciador e abre o menu. Para reabrir depois, digite no terminal:

```sh
xhttplatency-manager
```

---

## Usando o manager

### Primeira vez

O menu mostra só a opção **Instalar**. Ela pergunta a configuração (é só apertar ENTER pra usar o padrão):

```
Inserir porta (default: 8080):
Inserir path (default: /):
Inserir usuário (default: admin):
Inserir senha (default: admin):
Ativar TLS? [s/N]:
```

- Se a porta já estiver em uso, ele pede outra.
- Se ativar o **TLS**, dá pra gerar um certificado na hora ou informar um que você já tem.

No fim, o servidor sobe sozinho (e volta sozinho se o servidor reiniciar) e o manager mostra a **URL de acesso**.

### Depois de instalado

O menu já abre no painel completo:

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

- **Gerenciar configuração** — muda porta, path, usuário, senha e TLS.
- **Atualizar** — baixa a versão nova do servidor e do manager (fecha o menu; reabra com `xhttplatency-manager`).
- **Desinstalar** — remove tudo.

---

## Acesso

Depois de instalar, o manager mostra a **URL pronta** (com o token) — é só copiar pro seu cliente. Dá pra ver de novo na opção **Ver token / URL de acesso**.

---

## Requisitos

- Um servidor **Linux** com acesso **root**.
