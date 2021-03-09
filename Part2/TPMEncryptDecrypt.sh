
tpm2_flushcontext -t
tpm2_createprimary -c rsaprimary.ctx -P password
tpm2_flushcontext -t
tpm2_create -G rsa2048 -u rsa.pub -r rsa.priv -C rsaprimary.ctx 
tpm2_flushcontext -t
tpm2_load -C rsaprimary.ctx -u rsa.pub -r rsa.priv -c key.ctx
tpm2_flushcontext -t
tpm2_rsaencrypt -c key.ctx -o mess.enc dummy2.txt 
tpm2_flushcontext -t
tpm2_rsadecrypt -c key.ctx -o mess.txt mess.enc 
cat mess.txt

