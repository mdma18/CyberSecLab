#!/bin/bash
tpm2_pcrextend 23:sha1=f1d2d2f924e986ac86fdf7b36c94bcdf32beec15
tpm2_startauthsession -S session.ctx
tpm2_policypcr -S session.ctx -l sha1:23 -L set2.pcr0.policy
tpm2_flushcontext session.ctx
rm session.ctx