## Exemplo 1 - Menu simples
```BASH

#!/bin/bash

echo "Escolha uma opção:"

select opcao in "Instalar" "Atualizar" "Remover" "Sair"
do
    case $REPLY in
        1)
            echo "Instalando..."
            ;;
        2)
            echo "Atualizando..."
            ;;
        3)
            echo "Removendo..."
            ;;
        4)
            echo "Saindo..."
            exit 0
            ;;
        *)
            echo "Opção inválida."
            ;;
    esac
done
```

- saida:
```
Escolha uma opção:

1) Instalar
2) Atualizar
3) Remover
4) Sair
#?
```


## Exemplo 2 - Menu chamando funções
```bash
#!/bin/bash

instalar() {
    echo "Instalando..."
}

atualizar() {
    echo "Atualizando..."
}

remover() {
    echo "Removendo..."
}

while true
do
    clear
    echo "===== MENU ====="

    select opcao in \
        "Instalar" \
        "Atualizar" \
        "Remover" \
        "Sair"
    do
        case $REPLY in
            1)
                instalar
                break
                ;;
            2)
                atualizar
                break
                ;;
            3)
                remover
                break
                ;;
            4)
                exit 0
                ;;
            *)
                echo "Opção inválida"
                ;;
        esac
    done

    read -p "Pressione ENTER para continuar..."
done
```
## Exemplo 3 - Menu mais bonito
```bash

#!/bin/bash

while true; do
    clear

    echo "============================"
    echo "      SISTEMA"
    echo "============================"
    echo
    echo "1 - Instalar Dependências"
    echo "2 - Executar Projeto"
    echo "3 - Atualizar"
    echo "4 - Limpar Cache"
    echo "0 - Sair"
    echo

    read -p "Escolha: " op

    case "$op" in
        1)
            echo "Instalando..."
            ;;
        2)
            echo "Executando..."
            ;;
        3)
            echo "Atualizando..."
            ;;
        4)
            echo "Limpando cache..."
            ;;
        0)
            exit
            ;;
        *)
            echo "Opção inválida!"
            ;;
    esac

    read -p "Pressione ENTER..."
done

```


## Exemplo 4 - Interface estilo instalador (recomendado)

```bash

#!/bin/bash

opcao=$(whiptail \
    --title "Meu Sistema" \
    --menu "Escolha uma opção" 20 60 10 \
    1 "Instalar" \
    2 "Atualizar" \
    3 "Executar" \
    4 "Sair" \
    3>&1 1>&2 2>&3)

case "$opcao" in
    1)
        echo "Instalando..."
        ;;
    2)
        echo "Atualizando..."
        ;;
    3)
        echo "Executando..."
        ;;
    4)
        exit
        ;;
esac

```