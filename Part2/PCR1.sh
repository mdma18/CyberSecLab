#!/bin/bash
tpm2_startauthsession -S session.ctx
tpm2_policypcr -S session.ctx -l sha1:23 -L set1.pcr0.policy
tpm2_flushcontext session.ctx
rm session.ctx
