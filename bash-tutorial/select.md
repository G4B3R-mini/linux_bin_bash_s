Sim. Para criar **caixinhas de seleção** (checkboxes) em um script Bash, o mais comum é usar **`whiptail`** ou **`dialog`**.

### Exemplo com `whiptail`

```bash
#!/bin/bash

ESCOLHAS=$(whiptail \
    --title "Selecione as opções" \
    --checklist "Escolha uma ou mais opções:" \
    20 60 10 \
    "python" "Instalar Python" OFF \
    "node"   "Instalar Node.js" OFF \
    "git"    "Instalar Git" ON \
    "docker" "Instalar Docker" OFF \
    3>&1 1>&2 2>&3)

if [ $? -ne 0 ]; then
    echo "Cancelado."
    exit
fi

echo "Selecionado:"
echo "$ESCOLHAS"
```

Resultado:

```text
┌──────────────────────────────────────────────┐
│ Selecione as opções                          │
│                                              │
│ [ ] Instalar Python                          │
│ [ ] Instalar Node.js                         │
│ [✓] Instalar Git                             │
│ [ ] Instalar Docker                          │
│                                              │
│        <Ok>           <Cancelar>             │
└──────────────────────────────────────────────┘
```

* **↑ ↓** → mover
* **Espaço** → marcar/desmarcar
* **Tab** → alternar entre botões
* **Enter** → confirmar

---

## Processando as opções

```bash
#!/bin/bash

ESCOLHAS=$(whiptail \
    --checklist "Escolha:" \
    20 60 10 \
    "python" "Python" OFF \
    "node" "Node.js" OFF \
    "git" "Git" ON \
    3>&1 1>&2 2>&3)

for item in $ESCOLHAS
do
    case ${item//\"/} in
        python)
            echo "Instalando Python..."
            ;;
        node)
            echo "Instalando Node..."
            ;;
        git)
            echo "Instalando Git..."
            ;;
    esac
done
```

---

## Também existe `dialog`

Possui praticamente os mesmos recursos:

```bash
dialog --checklist \
"Escolha os componentes" \
20 60 10 \
python "Python" off \
node "Node.js" on \
git "Git" off \
2>resultado.txt
```

---

## Instalação

Ubuntu/Debian/Linux Mint:

```bash
sudo apt install whiptail
```

ou

```bash
sudo apt install dialog
```

---

### Avaliação SOLID

* **S (Single Responsibility):** ✔️ Coloque cada instalação em uma função (`instalar_python()`, `instalar_git()`, etc.). O menu apenas coleta a seleção.
* **O (Open/Closed):** ✔️ Para adicionar uma nova opção, basta incluir um novo item na checklist e uma nova função, sem alterar a estrutura principal.

Documentação:

* [Whiptail Manual](https://man7.org/linux/man-pages/man1/whiptail.1.html?utm_source=chatgpt.com)
* [Dialog Manual](https://invisible-island.net/dialog/dialog.html?utm_source=chatgpt.com)
