#!/bin/bash

# Taking Ownership
tpm2_clear
tpm2_startup -c
tpm2_changeauth -c owner password
tpm2_changeauth -c endorsement password

# Creating PCR1 policy
tpm2_startauthsession -S session.ctx
tpm2_policypcr -S session.ctx -l sha1:23 -L set1.pcr0.policy
tpm2_flushcontext session.ctx
rm session.ctx

# Creating PCR2 policy
tpm2_pcrextend 23:sha1=f1d2d2f924e986ac86fdf7b36c94bcdf32beec15
tpm2_startauthsession -S session.ctx
tpm2_policypcr -S session.ctx -l sha1:23 -L set2.pcr0.policy
tpm2_flushcontext session.ctx
rm session.ctx

#Create policyOR from compounding the 2 unique policies in OR style
tpm2_startauthsession -S session.ctx
tpm2_policyor -S session.ctx -L policyOR -l sha256:set1.pcr0.policy,set2.pcr0.policy
tpm2_flushcontext session.ctx
rm session.ctx

# Create a sealing object with auth policyOR created above
tpm2_createprimary -C o -P password -c prim.ctx
tpm2_create -g sha256 -u sealkey.pub -r sealkey.priv -L policyOR -C prim.ctx -i- <<< "secretpass"
tpm2_flushcontext -t
tpm2_load -C prim.ctx -c sealkey.ctx -u sealkey.pub -r sealkey.priv


# Attempt unsealing by satisfying the policyOR by satisfying SECOND of the two policies
tpm2_startauthsession -S session.ctx --policy-session
tpm2_policypcr -S session.ctx -l sha1:23
tpm2_policyor -S session.ctx -L policyOR -l sha256:set1.pcr0.policy,set2.pcr0.policy
tpm2_unseal -p session:session.ctx -c sealkey.ctx
# echo $unsealed
tpm2_flushcontext session.ctx
rm session.ctx

# Extend the pcr to emulate tampering of the system software and hence the pcr value.
tpm2_pcrextend 23:sha1=f1d2d2f924e986ac86fdf7b36c94bcdf32beec15

# Attempt unsealing by trying to satisfy the policOR by attempting to satisfy one of the two policies.
tpm2_startauthsession -S session.ctx --policy-session
tpm2_policypcr -S session.ctx -l sha1:23

# This should fail:
tpm2_policyor -S session.ctx -L policyOR -l sha256:set1.pcr0.policy,set2.pcr0.policy
tpm2_flushcontext session.ctx
rm session.ctx

# Reset pcr to get back to the first set of pcr value
tpm2_pcrreset 23

tpm2_flushcontext -t

# Attempt unsealing by satisfying the policyOR by satisfying FIRST of the two poli- cies.
tpm2_startauthsession -S session.ctx --policy-session
tpm2_policypcr -S session.ctx -l sha1:23
tpm2_policyor -S session.ctx -L policyOR -l sha256:set1.pcr0.policy,set2.pcr0.policy
tpm2_unseal -p session:session.ctx -c sealkey.ctx
# unsealed='tpm2_unseal -p session:session.ctx -c sealkey.ctx'
# echo $unsealed
tpm2_flushcontext session.ctx
rm session.ctx
