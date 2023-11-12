validated_credentials_or_stop <- function() {
  key_res <- get_key()
  model_res <- get_model()

  if (failure(key_res) || failure(model_res)) {
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
