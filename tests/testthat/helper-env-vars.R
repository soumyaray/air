# Helper to preserve or fake environment variables during tests
# Set stubbing = FALSE to turn of stubbing
with_stubbed_credentials <- function(code_block, stubbing = TRUE) {
  key <- Sys.getenv("OPENAI_KEY")
  model <- Sys.getenv("OPENAI_MODEL")

  on.exit({
    Sys.setenv("OPENAI_KEY" = key)
    Sys.setenv("OPENAI_MODEL" = model)
  })

  if (stubbing) {
    Sys.setenv("OPENAI_KEY" = "fake-key")
    Sys.setenv("OPENAI_MODEL" = "fake-model")
  }

  code_block
}
