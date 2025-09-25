# SVN to Git - Migration Tool

This project contains a bash script to migrate Subversion (SVN) repositories to Git, preserving complete commit history, branches, and tags.

## Overview

The `run-import.sh` script automates the SVN to Git conversion process, including:
- SVN repository cloning
- SVN authors mapping to Git format
- Branches and tags conversion
- Push to remote Git repository

## Prerequisites

- Git installed on the system
- `git-svn` (Git extension for working with SVN repositories)
- Subversion (SVN) client installed
- Read access to the source SVN repository
- Write access to the destination Git repository

## Usage

```bash
./run-import.sh <SVN_URL> <GIT_URL>
```

### Parameters

- `SVN_URL`: Complete Subversion repository URL (must start with `http://svn/` or `https://svn/`)
- `GIT_URL`: SSH URL of the destination Git repository (must start with `git@git`)

### Example

```bash
./run-import.sh https://svn.example.com/project git@git.example.com:user/project.git
```

## Detailed Operation

### 1. Parameter Validation
The script verifies that:
- Both parameters have been provided
- SVN URL is in the correct format (`http(s)://svn/*`)
- Git URL is in the correct SSH format (`git@git*`)

### 2. Directory Creation
Creates temporary directory structure:
- `~/repo-[PROJECT]`: Working directory for SVN cloning
- `~/[PROJECT].git`: Temporary bare Git repository

Removes existing directories if already present.

### 3. SVN Repository Cloning
- Extracts authors list from SVN repository
- Creates `authors-transform.txt` file with author mapping
- Executes `git svn clone` with standard layout (trunk/branches/tags)
- Preserves metadata and complete history

### 4. Git Configuration
- Initializes bare Git repository
- Configures main branch as `trunk`
- Adds remote for local bare repository
- Converts SVN branches to Git branches
- Converts SVN tags to Git tags

### 5. Push to Remote Repository
- Adds remote of destination Git repository
- Pushes all branches
- Pushes all tags

## Temporary File Structure

During execution, the script creates:

```
~/
├── repo-[PROJECT]/           # Working directory
│   ├── [PROJECT]/           # Converted SVN clone
│   └── authors-transform.txt # Author mapping
└── [PROJECT].git/           # Temporary bare Git repository
```

## Error Handling

The script includes checks for:
- Required parameters
- Correct URL formats
- Successful SVN cloning
- Successful directory creation

In case of error, the script displays informative message and exits with appropriate error code.

## Important Notes

- Script uses `--non-interactive --trust-server-cert` for automated SVN operations
- Removes SVN metadata from final Git repository (`--no-metadata`)
- Preserves standard SVN structure (trunk/branches/tags)
- Converts `origin/trunk` branch to `master` in Git
- Automatically removes temporary directories from previous executions

## Limitations

- Requires SVN repository to follow standard structure (trunk/branches/tags)
- URLs must follow specific formats for validation
- Process can be time-consuming for large repositories
- Requires sufficient disk space for two copies of the repository during conversion

---

# SVN para Git - Ferramenta de Migração

Este projeto contém um script bash para migrar repositórios Subversion (SVN) para Git, preservando o histórico completo de commits, branches e tags.

## Visão Geral

O script `run-import.sh` automatiza o processo de conversão de repositórios SVN para Git, incluindo:
- Clonagem do repositório SVN
- Mapeamento de autores SVN para formato Git
- Conversão de branches e tags
- Push para repositório Git remoto

## Pré-requisitos

- Git instalado no sistema
- `git-svn` (extensão do Git para trabalhar com repositórios SVN)
- Subversion (SVN) client instalado
- Acesso de leitura ao repositório SVN de origem
- Acesso de escrita ao repositório Git de destino

## Uso

```bash
./run-import.sh <URL_SVN> <URL_GIT>
```

### Parâmetros

- `URL_SVN`: URL completa do repositório Subversion (deve começar com `http://svn/` ou `https://svn/`)
- `URL_GIT`: URL SSH do repositório Git de destino (deve começar com `git@git`)

### Exemplo

```bash
./run-import.sh https://svn.exemplo.com/projeto git@git.exemplo.com:usuario/projeto.git
```

## Funcionamento Detalhado

### 1. Validação de Parâmetros
O script verifica se:
- Ambos os parâmetros foram fornecidos
- A URL SVN está no formato correto (`http(s)://svn/*`)
- A URL Git está no formato SSH correto (`git@git*`)

### 2. Criação de Diretórios
Cria estrutura temporária de diretórios:
- `~/repo-[PROJETO]`: Diretório de trabalho para clonagem SVN
- `~/[PROJETO].git`: Repositório Git bare temporário

Remove diretórios existentes se já estiverem presentes.

### 3. Clonagem do Repositório SVN
- Extrai lista de autores do repositório SVN
- Cria arquivo `authors-transform.txt` com mapeamento de autores
- Executa `git svn clone` com layout padrão (trunk/branches/tags)
- Preserva metadados e histórico completo

### 4. Configuração Git
- Inicializa repositório Git bare
- Configura branch principal como `trunk`
- Adiciona remote para repositório bare local
- Converte branches SVN para branches Git
- Converte tags SVN para tags Git

### 5. Push para Repositório Remoto
- Adiciona remote do repositório Git de destino
- Faz push de todos os branches
- Faz push de todas as tags

## Estrutura de Arquivos Temporários

Durante a execução, o script cria:

```
~/
├── repo-[PROJETO]/           # Diretório de trabalho
│   ├── [PROJETO]/           # Clone SVN convertido
│   └── authors-transform.txt # Mapeamento de autores
└── [PROJETO].git/           # Repositório Git bare temporário
```

## Tratamento de Erros

O script inclui verificações para:
- Parâmetros obrigatórios
- Formato correto das URLs
- Sucesso na clonagem SVN
- Criação bem-sucedida de diretórios

Em caso de erro, o script exibe mensagem informativa e sai com código de erro apropriado.

## Observações Importantes

- O script usa `--non-interactive --trust-server-cert` para operações SVN automatizadas
- Remove metadados SVN do repositório Git final (`--no-metadata`)
- Preserva estrutura padrão SVN (trunk/branches/tags)
- Converte branch `origin/trunk` para `master` no Git
- Remove diretórios temporários de execuções anteriores automaticamente

## Limitações

- Requer que o repositório SVN siga a estrutura padrão (trunk/branches/tags)
- URLs devem seguir formatos específicos para validação
- Processo pode ser demorado para repositórios grandes
- Requer espaço em disco suficiente para duas cópias do repositório durante a conversão