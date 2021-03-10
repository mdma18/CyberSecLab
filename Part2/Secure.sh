#!/bin/bash

#----------------------------------------------------------------------#

# Call script to encrypt data
./Encrypt.sh

# Call script to create policy
./Policy.sh

tpm2_flushcontext -t
# Create policy on object
tpm2_startauthsession -S session.ctx --policy-session
tpm2_policypcr -S session.ctx -l sha256:3 -L pcr.policy
tpm2_load -C policy.ctx -u sealpub.pub -r sealpriv.pub -c sealkey.ctx
# rm session.ctx sealpriv.pub sealpub.pub
tpm2_unseal -p"session:session.ctx" -c sealkey.ctx
