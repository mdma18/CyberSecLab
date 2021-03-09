#!/bin/bash

# Taking Ownership
tpm2_clear
tpm2_startup -c
tpm2_changeauth -c owner mdma
tpm2_changeauth -c endorsement mdma
