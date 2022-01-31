#!/bin/bash
set -e

api_version=""

if [ ! -f "config/settings.txt" ]; then
    echo "Error: "
    echo "First copy the file 'config/settings.example.txt' to 'config/settings.txt'."
    echo "Next, fill in your API credentials, Signer name and email to continue."
    echo ""
    exit 1
fi

if [ -f "config/settings.txt" ]; then
    . config/settings.txt
fi

function resetToken() {
    rm -f config/ds_access_token* || true
}

function choose_language(){
    echo ""
    api_version=$1
    PS3='Choose an OAuth Strategy: '
    select LANGUAGE in \
        "PHP" \
        "Python"; do
        case "$LANGUAGE" in

        \
        PHP)
            php ./OAuth/code_grant.php "$api_version"
            continu $api_version
            ;;

        Python) 
        # Check stderr and stdout for either a python3 version number or "not found"
        if [[ $(python3 --version 2>&1) == *"not found"* ]]; then  
            # If no python3, check stderr and stdout for a python version number or "not found"
            if [[ $(python --version 2>&1) != *"not found"* ]]; then
                # Didn't get a "not found" error so run python
                python ./OAuth/jwt_auth.py "$api_version"
            else
                echo "Either python or python3 must be installed to use this option." 
                exit 1
            fi
        else 
            # Didn't get a "not found" error so run python3
            python3 ./OAuth/jwt_auth.py "$api_version"
        fi
            continu $api_version
        esac
    done
}

# Choose an OAuth Strategy
function login() {
    echo ""
    api_version=$1
    PS3='Choose an OAuth Strategy: '
    select METHOD in \
        "Use_Authorization_Code_Grant" \
        "Use_JSON_Web_Token" \
        "Skip_To_Example" \
        "Exit"; do
        case "$METHOD" in

        \
            Use_Authorization_Code_Grant)
            php ./OAuth/code_grant.php "$api_version"
            continu $api_version
            ;;

        Use_JSON_Web_Token)
            choose_language "$api_version"
            ;;

        Skip_To_Examples)
            continu $api_version
            ;;

        Exit)
            exit 0
            ;;
        esac
    done

    mv ds_access_token.txt $token_file_name

    account_id=$(cat config/API_ACCOUNT_ID)
    ACCESS_TOKEN=$(cat $token_file_name)

    export ACCOUNT_ID
    export ACCESS_TOKEN
}

# Choose an authentication method
function choices() {
    echo ""
    PS3='Authenticate: '
    select METHOD in \
        "Authenticate" \
        "Exit"; do
        case "$METHOD" in

        Authenticate)
            api_version="eSignature"
            login $api_version
            startSignature
            ;;

        Exit)
            exit 0
            ;;
        esac
    done
}

# Select the action
function startSignature() {
    echo ""
    PS3='Select the action : '
    select CHOICE in \
        "Per_Envelope_Connect" \
        "Authenticate"; do
        case "$CHOICE" in
        Authenticate)
            choices
            ;;
        Per_Envelope_Connect)
            bash eg001EmbeddedSigning.sh
            startSignature
            ;;
        *)
            echo "Default action..."
            startSignature
            ;;
        esac
    done
}

function continu() {
    echo "press the 'any' key to continue"
    read nothin
    api_version=$1
    if [[ $api_version == "eSignature" ]]
    then
      startSignature
    fi
}

echo ""
echo "Send an embedded signing request with Connect"
echo "using Authorization Code grant or JWT grant authentication."

choices
