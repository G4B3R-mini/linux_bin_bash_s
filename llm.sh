#!/usr/bin/env bash

set -e

# Pasta ONDE O SCRIPT ESTÁ
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONFIG="$SCRIPT_DIR/config.conf"

# ============================================
# CONFIG
# ============================================

if [[ ! -f "$CONFIG" ]]; then
    echo "ERRO: configuração não encontrada:"
    echo "$CONFIG"
    exit 1
fi

source "$CONFIG"


erro() {
    echo "ERRO: $1" >&2
    exit 1
}


# ============================================
# OBTÉM MODELO DA FUNÇÃO
# ============================================

obter_modelo() {

    local func="$1"

    # Exemplo:
    # func=codigo
    # procura variável $codigo

    local modelo="${!func}"

    if [[ -z "$modelo" ]]; then
        erro "Função '$func' não configurada."
    fi

    local caminho="$MODELS_DIR/$modelo"

    if [[ ! -f "$caminho" ]]; then
        erro "Modelo não encontrado: $caminho"
    fi

    echo "$caminho"
}


obter_ctx_size() {

    local func="$1"
    local variavel_ctx="${func}_CTX_SIZE"
    local ctx_size="${!variavel_ctx:-$CTX_SIZE}"

    if [[ -z "$ctx_size" ]]; then
        erro "CTX_SIZE não configurado para '$func' nem como valor padrão."
    fi

    echo "$ctx_size"
}


# ============================================
# CLI
# ============================================

executar_cli() {

    local func="$1"
    shift

    local prompt="$*"

    [[ -x "$LLAMA_CLI" ]] || \
        erro "llama-cli não encontrado: $LLAMA_CLI"

    local modelo
    modelo="$(obter_modelo "$func")"
    local ctx_size
    ctx_size="$(obter_ctx_size "$func")"

    echo "----------------------------------------"
    echo "Função : $func"
    echo "Modelo : $modelo"
    echo "Contexto: $ctx_size"
    echo "----------------------------------------"

    "$LLAMA_CLI" \
        -m "$modelo" \
        -c "$ctx_size" \
        -t "$THREADS" \
        -ngl "$GPU_LAYERS" \
        --temp "$TEMPERATURE" \
        -p "$prompt"
}


# ============================================
# SERVER
# ============================================

iniciar_server() {

    local func="$1"

    [[ -x "$LLAMA_SERVER" ]] || \
        erro "llama-server não encontrado: $LLAMA_SERVER"

    local modelo
    modelo="$(obter_modelo "$func")"
    local ctx_size
    ctx_size="$(obter_ctx_size "$func")"

    echo "----------------------------------------"
    echo "Servidor llama.cpp"
    echo "Função : $func"
    echo "Modelo : $modelo"
    echo "Contexto: $ctx_size"
    echo "----------------------------------------"

    "$LLAMA_SERVER" \
        -m "$modelo" \
        -c "$ctx_size" \
        -t "$THREADS" \
        -ngl "$GPU_LAYERS" \
        --temp "$TEMPERATURE"
}


# ============================================
# LISTAR FUNÇÕES
# ============================================

listar_funcoes() {

    echo "Funções disponíveis:"
    echo

    grep -E '^[a-zA-Z_][a-zA-Z0-9_]*=.*\.gguf' "$CONFIG"
}


# ============================================
# LISTAR MODELOS
# ============================================

listar_modelos() {

    echo "Modelos encontrados em:"
    echo "$MODELS_DIR"
    echo

    find "$MODELS_DIR" \
        -maxdepth 1 \
        -type f \
        -name "*.gguf" \
        -printf "%f\n"
}


# ============================================
# COMANDOS
# ============================================

case "$1" in

    cli)

        [[ -z "$2" ]] && \
            erro "Informe a função."

        func="$2"

        shift 2

        [[ $# -eq 0 ]] && \
            erro "Informe o prompt."

        executar_cli "$func" "$@"
        ;;


    server)

        [[ -z "$2" ]] && \
            erro "Informe a função."

        iniciar_server "$2"
        ;;


    modelos)

        listar_modelos
        ;;


    funcoes)

        listar_funcoes
        ;;


    *)

        echo
        echo "Uso:"
        echo
        echo "  $0 cli <funcao> <prompt>"
        echo "  $0 server <funcao>"
        echo "  $0 modelos"
        echo "  $0 funcoes"
        echo
        echo "Exemplo:"
        echo
        echo \
        "$0 cli codigo \"Crie uma função Python\""
        echo
        ;;

esac