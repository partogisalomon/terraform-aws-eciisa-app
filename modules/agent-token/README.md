# terraform-aws-eciisa-app/modules/agent-token

This module allows you to create a parameter store to contain the Informatica Secure Agent token, which required for installation


# Usage

1. Get the agent token from Informatica dashboard https://dm-us.informaticacloud.com/identity-service/home
2. Store the new token to the parameter store
3. Run CD for the eciisa-app
