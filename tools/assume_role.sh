#!/bin/bash

ACCOUNT="${1:-$AWS_ACCOUNT}"
AWS_USER="${2:-$AWS_USER}"
MFA_TOKEN="${3:-$MFA_TOKEN}"
ROLE="${4:-terragrunt}"
NAME="${5:-$LOGNAME@`hostname -s`}"
REGION="${6:-eu-west-1}"

source ~/.aws_creds.sh

KST=$(aws sts assume-role --role-arn arn:aws:iam::$ACCOUNT\:role/$ROLE --role-session-name $NAME --serial-number arn:aws:iam::$ACCOUNT:mfa/$AWS_USER --token-code $MFA_TOKEN  --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]' --output text 2>/dev/null)

unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION AWS_ACCOUNT AWS_DELEGATION_TOKEN AWS_SECURITY_TOKEN AWS_SESSION_TOKEN

if [ $? -ne 0 ]; then
	echo "fail assume-role on account: $ACCOUNT"
	return 1
else
	export AWS_ACCESS_KEY=$(echo "$KST" | awk '{print$1}')
	export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY

	export AWS_SECRET_KEY=$(echo "$KST" | awk '{print$2}')
	export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_KEY"

	export AWS_SESSION_TOKEN=$(echo "$KST" | awk '{print$3}')
	export AWS_SECURITY_TOKEN="$AWS_SESSION_TOKEN"
	export AWS_DELEGATION_TOKEN="$AWS_SESSION_TOKEN"

	export AWS_ACCOUNT=$ACCOUNT
    export AWS_DEFAULT_REGION=$REGION
fi
