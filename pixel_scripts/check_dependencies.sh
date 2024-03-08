#!/bin/bash

# Uso: wait_until_condition <condición> [número de intentos]

function is_docker_running() {
    echo "Docker daemon?"

    if ! docker info &> /dev/null; then
        echo -e "Docker daemon no parece estar funcionando, ¿deseas intentar activarlo? \033[1;31ms/n\033[0m"
        # echo "Docker daemon no parece estar funcionando, deseas que intente activarlo? \e[1;31ms/n\e[0m "
    fi

    sleep 10 &

    read -t 10 response

    if [[ "$response" == "s" ||  "$response" == "y" ]]; then
        echo "Iniciando..."

        run_docker_daemon
    else
        echo "Operación cancelada."
    fi
}

function run_docker_daemon() {
    local max_attempts=50 
    local attempts=0

    open -a Docker &> /dev/null

    while ! docker info &> /dev/null; do
        attempts=$((attempts + 1))
            
        if [ "$attempts" -ge "$max_attempts" ]; then
            echo "Se alcanzó el número máximo de intentos. Saliendo..."
            return 1
        fi

        echo "Esperando... Intento $attempts/$max_attempts"

        sleep 1
    done

    echo "Docker daemon iniciado. Continuando..."
}


function wait_until_condition() {
    local condition="$1"
    local max_attempts="${2:-20}" 
    local attempts=0

    while ! eval "$condition"; do
        attempts=$((attempts + 1))

        if [ "$attempts" -ge "$max_attempts" ]; then
            echo "Se alcanzó el número máximo de intentos. Saliendo..."
            return 1
        fi

        echo "Esperando... Intento $attempts/$max_attempts"
        sleep 1
    done

    echo "La condición se ha cumplido. Continuando..."
}

function mongoTol() {
echo "mongo?"
    status_code=$(curl --write-out %{http_code} --silent --output /dev/null http://localhost:27017)
    if [ "$status_code" -ne 200 ]; then
      echo "The Mongodb is not running"
      return 1
    fi

    return 0
}

function apitol() {
    echo "apitol?"
    status_code=$(curl --write-out %{http_code} --silent --output /dev/null http://localhost:3002)
    if [ "$status_code" -ne 200 ]; then
        echo "WARNING: You need APITOL to run the application"
        return 1
    fi

    return 0
}

function toluserapi() {
    echo "toluserapi?"
    status_code=$(curl --write-out %{http_code} --silent --output /dev/null http://localhost:3001)
    if [ "$status_code" -ne 200 ]; then
        echo "WARNING: You need TOLUSERAPI to run the application."
        return 1
    fi

    return 0
}



