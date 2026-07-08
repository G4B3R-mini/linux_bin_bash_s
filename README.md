# Bin

Esta pasta contém meus comandos personalizados, scripts e utilitários usados no dia a dia.

## Objetivo

Centralizar comandos reutilizáveis para facilitar a automação de tarefas, evitando duplicação de código e simplificando o uso no terminal e em outros projetos.

## Organização

```text
bin/
├── comando1
├── comando2
├── utilitario
└── ...
```

Cada arquivo deve possuir uma única responsabilidade e, sempre que possível, aceitar parâmetros pela linha de comando.

## Requisitos

* Linux
* Permissão de execução (`chmod +x`)
* Diretório adicionado ao `PATH`

Exemplo:

```bash
export PATH="$HOME/bin:$PATH"
```

Ou, caso a pasta esteja em outro local:

```bash
export PATH="/caminho/para/bin:$PATH"
```

Adicione a linha ao `~/.bashrc`, `~/.zshrc` ou outro arquivo de inicialização do seu shell.

## Convenções

* Utilizar nomes curtos e descritivos.
* Preferir letras minúsculas e hífens (`meu-comando`).
* Evitar dependências desnecessárias.
* Sempre tratar erros e validar argumentos.
* Incluir `--help` quando fizer sentido.

## Uso

Após adicionar a pasta ao `PATH`, qualquer comando pode ser executado diretamente:

```bash
comando1
comando2 argumento
utilitario --help
```

## Manutenção

Ao adicionar um novo comando:

1. Torná-lo executável.
2. Documentar seu funcionamento, quando necessário.
3. Manter compatibilidade com os demais scripts da pasta.
