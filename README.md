# Datadog logs aws-lambda

## OverView
aws integrationの[Collect Logs]で設定するLambdaを作成する。  

## Create
### Code
- archive_file.datadog_logs
  - lambdaにuploadするzipファイル

### aws
- aws_iam_policy_document.datadog_logs_lambda_policy_doc
- aws_iam_role.datadog_logs_lambda_role
- aws_iam_role_policy.datadog_logs_lambda_policy
- aws_lambda_function.datadog_logs


## Usage

```
module "lambda_datadog" {
  source     = "git@github.com:gacha-ru/terraform-aws-datadog-logs-lambda.git"
  ssm_key_name = "datadog APIキーをSSMに登録した時の名前(ex. /datadog/kings/DD_API_KEY)"
}
```

## Inputs
|Name|Description|type|Default|required|
|:--|:--|:--|:--|:--|
|ssm_key_name|APIキーをSSMに登録した時の名前|string|none|○|
|log_lambda_memory|lambdaに割り当てるメモリサイズ(MB)|number|128|×|
|log_lambda_timeout|lambdaタイムアウト時間(秒)|string|3|×|

## Outputs
|Name|Description|
|:--|:--|
|datadog_logs_lambda_role|lambdaに設定したIAMRoleのARN|
|lambda_spredirect_qualified_arn|AWS Interrationの[Collect Logs]に設定するARN|

## ex. Codeについて
[code/logs_monitoring](https://github.com/DataDog/datadog-serverless-functions/tree/master/aws/logs_monitoring)をbaseにしています(2019/4/1 現在)  
パラメータストアからDatadogAPIキーを取得できるように変更

```
# 49行目~
elif "DD_SSM_KEY" in os.environ:
    ssm_response = boto3.client('ssm').get_parameters(
            Names = [
                os.environ["DD_SSM_KEY"]
            ],
            WithDecryption = True
        )
    params = {}
    for param in ssm_response[ 'Parameters' ]:
        DD_API_KEY = param['Value']
```
