#' @export
howto <- function(do, call_api = call_openai) {
  key <- get_secret_or_return("openai-key")
  model <- get_secret_or_return("openai-model")

  req <- ai_completion_request(do, model)
  res <- call_api(req$endpoint, key, req$json_body)

  code <- parse_response_message(res$message)

  cat(paste0(code, "\n"))
  invisible(code)
}
