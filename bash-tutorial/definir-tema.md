No `whiptail`, as cores **não são definidas diretamente no script**. Elas vêm do **tema do terminal** (xterm, GNOME Terminal, Konsole, etc.) e da biblioteca **newt**, que desenha a interface.

No seu script:

```bash
whiptail \
    --checklist "Escolha:" \
    20 50 10 \
    ...
```

não existe uma opção como `--background-color` ou `--foreground-color`.

### Como alterar as cores

#### 1. Variável `NEWT_COLORS` (recomendado)

Você pode definir a variável de ambiente `NEWT_COLORS` antes de chamar o `whiptail`.

Exemplo:

```bash
export NEWT_COLORS='
root=white,black
window=white,blue
border=yellow,blue
title=yellow,blue
textbox=white,blue
button=black,cyan
actbutton=white,red
checkbox=white,blue
actcheckbox=yellow,red
entry=white,blue
'
```

Depois:

```bash
whiptail --checklist ...
```

---

#### 2. Exemplo com fundo preto

```bash
#!/bin/bash

export NEWT_COLORS='
root=white,black
window=white,black
border=green,black
title=green,black
button=black,green
actbutton=white,red
checkbox=white,black
actcheckbox=yellow,red
'

whiptail --checklist \
"Escolha:" \
20 50 10 \
"python" "Python" OFF \
"node" "Node.js" OFF \
"git" "Git" ON \
3>&1 1>&2 2>&3
```

---

### Principais elementos

| Elemento        | Descrição                  |
| --------------- | -------------------------- |
| `root`          | Fundo do terminal          |
| `window`        | Janela principal           |
| `border`        | Borda                      |
| `title`         | Título                     |
| `textbox`       | Texto                      |
| `button`        | Botão normal               |
| `actbutton`     | Botão selecionado          |
| `checkbox`      | Checkbox normal            |
| `actcheckbox`   | Checkbox selecionado       |
| `entry`         | Campos de texto            |
| `compactbutton` | Botões compactos           |
| `actsel`        | Item selecionado em listas |

Cada valor é:

```text
elemento=cor_texto,cor_fundo
```

Por exemplo:

```text
title=yellow,blue
```

significa:

* Texto: amarelo
* Fundo: azul

---

### Cores disponíveis

* `black`
* `red`
* `green`
* `yellow`
* `blue`
* `magenta`
* `cyan`
* `white`

Em alguns terminais também funcionam:

* `gray`
* `brightred`
* `brightgreen`
* `brightyellow`
* `brightblue`
* `brightmagenta`
* `brightcyan`
* `brightwhite`

---

Se a sua interface aparece **rosa e branca**, normalmente isso ocorre porque:

* o tema do terminal define **magenta** como uma tonalidade de rosa;
* ou a distribuição já define uma configuração padrão de `NEWT_COLORS`.

Documentação:

* [newt / whiptail (NEWT_COLORS)](https://pagure.io/newt?utm_source=chatgpt.com)
* [Whiptail Manual](https://man7.org/linux/man-pages/man1/whiptail.1.html?utm_source=chatgpt.com)
