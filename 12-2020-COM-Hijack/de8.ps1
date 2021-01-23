# INPUT PARAMS: $fs7, any string
# OUTPUT: $fs7 base64 encoded

[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($fs7))