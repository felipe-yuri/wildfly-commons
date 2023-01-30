#!/bin/bash

#Para rodar execute o comando passando a versão desejada e o nome do repositório
# bash run.sh Sua_Versao RepositoryName
# Exemplo: bash run.sh develop maven-snapshots
VERSION=$1
MAVEN_REPOSITORY=$2

cleanCache() {
    echo -e "\n[CACHE] Limpando caches!"
    # rm -rf .gradle ~/.gradle
    gradle clean
}

test() {
    echo -e "\n[TEST] Executando testes!"
    gradle --build-cache test
}

build() {
    echo -e "\n[BUILD] Buildando projeto package-delivery!"
    # gradle build --no-build-cache -Pversion=$VERSION
    gradle --build-cache build -Pversion=$VERSION
}

publish() {
    echo -e "\n[PUBLISH] Publicando projeto package-delivery!"
    gradle --build-cache zipArtifacts publish -Pversion=$VERSION -Prepository=$MAVEN_REPOSITORY
}

checkReturn() {
    if [ $? -eq 0 ]; then
        echo -e "\nProcesso executado com sucesso!\n"
    else
        echo -e "\nProcesso falhou!\n"
        exit 1;
    fi
}

cleanCache
checkReturn
test
checkReturn
build
checkReturn
publish


