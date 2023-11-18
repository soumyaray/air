validated_credentials_or_stop <- function() {
  key_res <- get_key()
  model_res <- get_model()

  if (is_failure(key_res) || is_failure(model_res)) {
    stop(paste("Please set your OpenAI key and model first.\n",
               "See package documentation for details."))
  }

  creds <- list(
    key = value(key_res),
    model = value(model_res)
  )

  class(creds) <- c("credentials", class(creds))
  creds
}

api_answer_or_stop <- function(input, creds, context, call_api = call_openai) {
  req <- ai_completion_request(input, creds$model, context)
  res <- call_api(req$endpoint, creds$key, req$json_body)

  if (is_failure(res)) {
    stop(value(res))
  }

  parse_response_message(value(res))
}
