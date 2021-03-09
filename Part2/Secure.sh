#!/bin/bash 

# Run Ownership script with desired password to set TPM env pass

# Flush TPM memory 
tpm2_flushcontext -t

# Create an encryption key
tpm2_createprimary -c encrypt.ctx -P mdma
tpm2_create -G rsa2048 -u rsa.pub -r rsa.priv -C ecrypt.ctx 
tpm2_load -C encrypt.ctx -u rsa.pub -r rsa.priv -c encryptedkey.ctx
tpm2_rsaencrypt -c key.ctx -o encryptedmsg.enc MySecureFile.txt 
