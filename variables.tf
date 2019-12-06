# 指定する変数
variable "ssm_key_name" {
  description = "datadog api keyを格納したパラメータストアキー"
}

variable "log_lambda_memory" {
  description = "lambdaに割り当てるメモリサイズ(MB)"
  default     = 128
}

variable "log_lambda_timeout" {
  description = "lambdaタイムアウト時間(秒)"
  default     = 3
}