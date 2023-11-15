#' Ask OpenAI to explain what given R code does.
#' The answer is written to console and returned as a string.
#'
#' @param this Character string of code to be explained
#' @param call_api Optional function to call another API
#' @return Invisible character string of explanation
#'
#' @examples
#' #' # You must provision an OpenAI API key before using this function.
#' \dontrun{
#' # whatis("paste0(vector1, vector2)")
#' # whatis("length(x) %% 2 == 1 ? x[(length(x) + 1) / 2] : NA")
#' }
#'
#' @export
whatis <- function(this, call_api = call_openai) {
  creds <- validated_credentials_or_stop()

  context <- paste(
    "I want you to act as an R code explanation expert.",
    "I want you to first explain what the overall code does,",
    "then explain what each sub-expression of the code does",
    "and finish with a simple example with its output, if possible.",
    "Do not overexplain or write too much.")

  explanation <- api_answer_or_stop(this, creds, context, call_api)

  message(paste0(explanation, "\n"))
  invisible(explanation)
}
