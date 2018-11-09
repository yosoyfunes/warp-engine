#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/php_help.sh"

function php_info()
{

    PHP_VERSION=$(warp_env_read_var PHP_VERSION)

    if [ ! -z "$PHP_VERSION" ]
    then
        warp_message ""
        warp_message_info "* PHP"
        warp_message "Version:                    $(warp_message_info $PHP_VERSION)"
        warp_message "Logs:                       $(warp_message_info $PROJECTPATH/.warp/docker/volumes/php-fpm/logs)"
        warp_message "Xdebug file:                $(warp_message_info $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini)"
        warp_message ""
        warp_message_warn " - In order to configure Xdebug, please check FAQs here: $(warp_message_bold 'http://ct.summasolutions.net/warp-engine/')"
        
        warp_message ""
    fi
}

function php_connect_ssh() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        php_ssh_help 
        exit 1
    fi;

    if [ $(warp_check_is_running) = false ]; then
        warp_message_error "Los contenedores no estan corriendo"
        warp_message_error "este comando necesita previamente que ejecutes warp start"

        exit 1;
    fi

    if [ "$1" = "--root" ]
    then
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash
    else
        docker-compose -f $DOCKERCOMPOSEFILE exec php bash
    fi;    
}

function php_main()
{
    case "$1" in
        ssh)
            shift 1
            php_connect_ssh $*
        ;;

        info)
            php_info
        ;;

        -h | --help)
            php_help_usage
        ;;

        *)            
            php_help_usage
        ;;
    esac
}