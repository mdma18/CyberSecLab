#!/bin/bash

tpm2_flushcontext -t
# Create a Policy like a PCR policy
tpm2_startauthsession -S session.ctx
# Use 3rd PCR reg and create a sealing object
tpm2_policypcr -S session.ctx -l sha256:3 -L pcr.policy
tpm2_flushcontext session.ctx
# Create sealing object
tpm2_createprimary -C o -g sha256 -G rsa -c policy.ctx -P mdma
tpm2_create -g sha256 -u sealpub.pub -r sealpriv.pub -C policy.ctx -L pcr.policy -i encrptmsg.txt
rm session.ctx
