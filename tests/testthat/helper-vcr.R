library("vcr") # *Required* as vcr is set up on loading
invisible(vcr::vcr_configure(
  filter_sensitive_data = list(
    "<<<api_key>>>" = air:::get_secret("openai-key")$message
  ),
  dir = vcr::vcr_test_path("fixtures")
))
vcr::check_cassette_names()
