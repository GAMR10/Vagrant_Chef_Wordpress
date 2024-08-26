#!/bin/bash

# RUBY_CMD="C:/Ruby33-x64/bin/ruby.exe"
# Buscar el ejecutable de Ruby
if [[ "$OSTYPE" == "msys" ]]; then
    # Para Git Bash en Windows
    RUBY_CMD=$(where ruby | head -n 1)
elif [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
    # Para sistemas Unix-like
    RUBY_CMD=$(which ruby)
else
    echo "Sistema no soportado para la detección de Ruby"
    exit 1
fi

if [[ -z "$RUBY_CMD" ]]; then
    echo "Ruby no encontrado en el sistema"
    exit 1
fi

function run_specific_unit_tests() {
    echo -e "\n\033[1;32m########## Ejecutando pruebas unitarias ##########\033[0m"

    local PRUEBA="$(pwd)/cookbooks/wordpress/spec/"
    cd "$(dirname "$PRUEBA")"
    "$RUBY_CMD" -S bundle exec rspec spec/unit/recipes/simple_spec.rb
    read -p "Presiona cualquier tecla para continuar..."
}

function run_specific_integration_tests() {
  echo -e "\n\033[1;32m########## Ejecutando pruebas de integración ##########\033[0m"

    local PRUEBA2="$(pwd)/cookbooks/wordpress/kitchen.yml"
    cd "$(dirname "$PRUEBA2")"
    kitchen test suite-prueba-ubuntu-2004
    read -p "Presiona cualquier tecla para continuar..."
}

function show_menu() {
    while true; do
        clear  # Limpia la pantalla en sistemas Unix-like
        echo -e "\033[1;32m1. Ejecutar pruebas unitarias específicas\033[0m"
        echo -e "\033[1;32m2. Ejecutar pruebas de integración específicas\033[0m"
        echo -e "\033[1;32m3. Exit\033[0m"
        read -p "Opción: " OPTION

        case $OPTION in
            1) run_specific_unit_tests ;;
            2) run_specific_integration_tests ;;
            3) echo -e "\033[1;31mBye bye... \n\033[0m" && exit 0 ;;
            *) echo -e "\033[1;31mLa opción es inválida. Saliendo... \n\033[0m" ;;
        esac
    done
}

if [[ "$1" == "" ]]; then
    show_menu
elif [[ "$1" == "unit" ]]; then
    run_specific_unit_tests
elif [[ "$1" == "integration" ]]; then
    run_specific_integration_tests
else
    echo "Opción inválida"
    exit 1
fi
