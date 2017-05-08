# Encrypt/decrypt text files (AES 256 CBC)
function encrypt {
    # No args -- use stdin
    if [ -z $1 ]; then
        openssl enc -aes-256-cbc -a
    else
        openssl enc -aes-256-cbc -a -in $1
    fi
}
function decrypt {
    # No args -- use stdin
    if [ -z $1 ]; then
        openssl enc -aes-256-cbc -a -d
    else
        openssl enc -aes-256-cbc -a -d -in $1
    fi
}

# Create a new journal entry
function jnew {
    local entryName=$(date | sed s/\ /_/g)
    vim $entryName
    cat $entryName | openssl enc -aes-256-cbc -a -out $entryName
}

# Edit a journal entry
function jedit {
    cat $1 | decrypt | vipe | tee $1
    cat $1 | openssl enc -aes-256-cbc -a -out $1
}

