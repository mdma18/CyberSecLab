#!/bin/bash

# Run Ownership script with desired password to set TPM env pass

# Flush TPM memory
tpm2_flushcontext -t

# Create an encryption key
tpm2_createprimary -c encrypt.ctx -P mdma
tpm2_create -G rsa2048 -u rsa.pub -r rsa.priv -C encrypt.ctx
tpm2_flushcontext -t
tpm2_load -C encrypt.ctx -u rsa.pub -r rsa.priv -c key.ctx
tpm2_rsaencrypt -c key.ctx -o encrptmsg.txt MySecureFile.txt
tpm2_flushcontext -t
# Remove context files and RSA keys
rm encrypt.ctx rsa.pub rsa.priv

# To decrypt:
# tpm2_rsadecrypt -c key.ctx -o mess.txt encrptmsg.enc
